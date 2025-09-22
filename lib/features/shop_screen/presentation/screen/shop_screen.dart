import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/di/dependency_injection.dart';
import 'package:wavex/features/shop_screen/data/models/add_to_cart_request_body.dart';
import 'package:wavex/features/shop_screen/logic/shop_cubit.dart';
import 'package:wavex/main.dart';

import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/login_required_dialog.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../data/models/get_categories_response.dart';
import '../../data/models/get_products_response.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int _selectedBottomNavIndex = 2;
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _fromPriceController = TextEditingController();
  final TextEditingController _toPriceController = TextEditingController();
  String _selectedSortOption = 'Low To High';
  final List<String> _sortOptions = ['Low To High', 'High To Low'];
  int currentPage = 1;
  bool isLoadingMore = false;
  int _selectedQuantity = 1;

  List<CategoriesData> filterTabs = [];
  List<ProductData> products = [];
  List<ProductData> allProducts = [];

  @override
  void initState() {
    super.initState();
    ShopCubit.get(context).getCategories();
    ShopCubit.get(context).getProducts(pageNumber: 1);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 20 &&
          !isLoadingMore) {
        setState(() {
          isLoadingMore = true;
          currentPage++;
        });
        _applyPagination(currentPage);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _applyPagination(int? currentPage) {
    ShopCubit.get(context).getProducts(
      pageNumber: currentPage,
      q: _searchController.text.isNotEmpty ? _searchController.text : null,
      priceFrom: _fromPriceController.text.isNotEmpty
          ? double.tryParse(_fromPriceController.text)
          : null,
      priceTo: _toPriceController.text.isNotEmpty
          ? double.tryParse(_toPriceController.text)
          : null,
      category:
          _selectedFilterIndex > 0 ? filterTabs[_selectedFilterIndex].id : null,
      sortPrice: _selectedSortOption == 'Low To High'
          ? 'asc'
          : _selectedSortOption == 'High To Low'
              ? 'desc'
              : null,
      loadMore: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          HeaderWidget(),
          _buildShopSection(localizations),
          _buildSearchBar(localizations),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  _buildHeroImage(),
                  _buildFilterTabs(),
                  _buildProductGrid(localizations),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
          BottomNavigation(currentIndex: _selectedBottomNavIndex),
        ],
      ),
    );
  }

  Widget _buildShopSection(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 10),
      child: Column(
        children: [
          // Text(
          //   AppLocalizations.of(context).translate("soon"),
          //   style: GoogleFonts.inter().copyWith(
          //     color: Colors.red,
          //     fontWeight: FontWeight.w700,
          //     fontSize: 20,
          //   ),
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          Row(
            children: [
              Row(
                children: [
                  Image.asset("assets/images/water_drop_icon.png"),
                  const SizedBox(width: 12),
                  Text(
                    localizations.translate("shop_now"),
                    style: GoogleFonts.inter().copyWith(
                      color: const Color(0xFF2E535F),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),

              // cart icon
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Color(0xFF2E535F)),
                onPressed: () {
                  // هنا تروح لصفحة الكارت
                  // Navigator.pushNamed(context, "/cart");
                  // أو:
                  navigatorKey.currentState!
                      .pushNamed(RouteStrings.shoppingCartScreen);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: localizations.translate("search_products_hint"),
                  prefixIcon:
                      const Icon(Icons.search_outlined, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xff45818B54)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: (value) => _applyPagination(null),
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _showFilterModal(localizations),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/images/carbon_settings-adjust.png",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/demo/5.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(
                child:
                    Icon(Icons.fitness_center, size: 40, color: Colors.grey)),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state is GetCategoriesSuccessState) {
          setState(() {
            filterTabs = [
              CategoriesData(name: "All", id: null, description: "test"),
              ...?state.categoriesResponse.data,
            ];
          });
        }

        if (state is AddToCartSuccessState) {
          CacheHelper.saveData(
              key: "orderId",
              value: state.addToCartResponse.data!.orderId ?? "");
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.addToCartResponse.message ?? ""),
                backgroundColor: Colors.green,
              ),
            );
        }
        if (state is AddToCartErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error ?? ""),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      builder: (context, state) {
        if (filterTabs.isNotEmpty) {
          return Container(
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filterTabs.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                    ShopCubit.get(context).getProducts(
                      // pageNumber: currentPage,
                      q: _searchController.text.isNotEmpty
                          ? _searchController.text
                          : null,
                      priceFrom: _fromPriceController.text.isNotEmpty
                          ? double.tryParse(_fromPriceController.text)
                          : null,
                      priceTo: _toPriceController.text.isNotEmpty
                          ? double.tryParse(_toPriceController.text)
                          : null,
                      category: _selectedFilterIndex > 0
                          ? filterTabs[_selectedFilterIndex].id
                          : null,
                      sortPrice: _selectedSortOption == 'Low To High'
                          ? 'asc'
                          : _selectedSortOption == 'High To Low'
                              ? 'desc'
                              : null,
                      loadMore: false,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : const Color(0xFFE2F2F5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        filterTabs[index].name ?? "",
                        style: GoogleFonts.bellotaText().copyWith(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF444444),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProductGrid(AppLocalizations localizations) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {
        if (state is GetProductsSuccessState) {
          setState(() {
            products = state.productsResponse.data?.data ?? [];
            allProducts = products;
            isLoadingMore = false;
          });
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () => _showProductDetailModal(product, localizations),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(product.image ?? ""),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name ?? "",
                                  maxLines: 1,
                                  style: GoogleFonts.openSans().copyWith(
                                    color: const Color(0xFF45818B),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(
                                  "${CacheHelper.getdata(key: "selectedCurrency") == "GBP" ? "£" : CacheHelper.getdata(key: "selectedCurrency") == "USD" ? "\$" : CacheHelper.getdata(key: "selectedCurrency") == "EGP" ? "ج.م" : "£"}${product.price}",
                                  style: GoogleFonts.openSans().copyWith(
                                    color: const Color(0xFF45818B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  )),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ShopCubit.get(context).addToCart(
                                      addToCartRequestBody:
                                          AddToCartRequestBody(
                                        orderId: CacheHelper.getdata(
                                                    key: "userToken") ==
                                                null
                                            ? CacheHelper.getdata(
                                                key: "orderId")
                                            : null,
                                        // orderId:
                                        //     CacheHelper.getdata(key: "orderId"),
                                        orderItems: [
                                          OrderItem(
                                            productId: product.id.toString(),
                                            quantity: 1,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF45818B),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: Text(
                                      localizations.translate("add_to_cart"),
                                      style: const TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showFilterModal(AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterModal(localizations),
    );
  }

  Widget _buildFilterModal(AppLocalizations localizations) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(localizations.translate("filter_your_page"),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor))),
              const SizedBox(height: 20),
              Text(localizations.translate("price"),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _priceTextField(
                        _fromPriceController, localizations.translate("from")),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _priceTextField(
                        _toPriceController, localizations.translate("to")),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(localizations.translate("sort_by"),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor)),
              const SizedBox(height: 16),
              _sortDropdown(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _filterButton(localizations.translate("reset"),
                        Colors.grey.shade300, Colors.black87, () {
                      _fromPriceController.clear();
                      _toPriceController.clear();
                      _selectedSortOption = 'Low To High';
                      _searchController.clear();
                      products = List.from(allProducts);
                      ShopCubit.get(context).getProducts(pageNumber: 1);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                              content: Text(
                                  localizations.translate("filters_reset")),
                              backgroundColor: AppColors.primaryColor),
                        );
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _filterButton(localizations.translate("apply"),
                        AppColors.primaryColor, Colors.white, () {
                      Navigator.pop(context);
                      _applyFilters();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                                '${localizations.translate("filters_applied")}: ${_fromPriceController.text} - ${_toPriceController.text}, Sort: $_selectedSortOption'),
                            backgroundColor: AppColors.primaryColor,
                          ),
                        );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor, width: 1),
          borderRadius: BorderRadius.circular(25)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.primaryColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _sortDropdown() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor, width: 1),
              borderRadius: BorderRadius.circular(25)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSortOption,
              onChanged: (String? newValue) {
                setState(() => _selectedSortOption = newValue!);
              },
              items: _sortOptions.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(value,
                        style: const TextStyle(
                            color: AppColors.primaryColor, fontSize: 16)),
                  ),
                );
              }).toList(),
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.keyboard_arrow_down,
                    color: AppColors.primaryColor),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _filterButton(
      String text, Color bgColor, Color fgColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: Text(text,
          style: GoogleFonts.inter()
              .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
    );
  }

  void _applyFilters() {
    setState(() {
      currentPage = 1;
      products.clear();
    });
    _applyPagination(null);
  }

  void _showProductDetailModal(
      ProductData product, AppLocalizations localizations) {
    setState(() {
      _selectedQuantity = 1;
    });
    showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
              value: getIt<ShopCubit>(),
              child: _buildProductDetailModal(product, localizations),
            ));
  }

  Widget _buildProductDetailModal(
      ProductData product, AppLocalizations localizations) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
      child: StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 148,
                      height: 160,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(product.image ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: const Color(0xFF4DB6AC),
                                  child: const Center(
                                      child: Text('WAVEX',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2))),
                                )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? "",
                            style: GoogleFonts.openSans().copyWith(
                              color: const Color(0xFF45818B),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                              "${CacheHelper.getdata(key: "selectedCurrency") == "GBP" ? "£" : CacheHelper.getdata(key: "selectedCurrency") == "USD" ? "\$" : CacheHelper.getdata(key: "selectedCurrency") == "EGP" ? "ج.م" : "£"}${product.price}",
                              // Text("",
                              style: GoogleFonts.openSans().copyWith(
                                  color: const Color(0xFF45818B),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 1.33)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _quantityButton(Icons.remove, () {
                                if (_selectedQuantity > 1)
                                  setState(() => _selectedQuantity--);
                              }),
                              const SizedBox(width: 10),
                              Text('$_selectedQuantity',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                              const SizedBox(width: 10),
                              _quantityButton(Icons.add,
                                  () => setState(() => _selectedQuantity++)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(product.description ?? "",
                    style: GoogleFonts.openSans().copyWith(
                        color: const Color(0xFF45818B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.63)),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        // onPressed: () {
                        //   Navigator.pop(context);
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //         content: Text(
                        //             'Added $_selectedQuantity ${product.name ?? ""} to cart'),
                        //         backgroundColor: const Color(0xFF4DB6AC)),
                        //   );
                        //
                        // },
                        onPressed: () {
                          Navigator.pop(context);
                          ShopCubit.get(context).addToCart(
                            addToCartRequestBody: AddToCartRequestBody(
                              orderId:
                                  CacheHelper.getdata(key: "userToken") == null
                                      ? CacheHelper.getdata(key: "orderId")
                                      : null,
                              // orderId: CacheHelper.getdata(key: "orderId"),
                              orderItems: [
                                OrderItem(
                                  productId: product.id.toString(),
                                  quantity: _selectedQuantity,
                                )
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: Text(localizations.translate("add_to_cart"),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    // const SizedBox(height: 12),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('Proceeding to checkout...'),
                    //           backgroundColor: Color(0xFF4DB6AC),
                    //         ),
                    //       );
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: AppColors.primaryColor,
                    //         foregroundColor: Colors.white,
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(25))),
                    //     child: Text(
                    //       localizations.translate("checkout_now"),
                    //       style: const TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          color: const Color(0xFF45818B),
          borderRadius: BorderRadius.circular(20)),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 15)),
    );
  }

  void showLoginRequiredDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LoginRequiredDialog());
  }
}

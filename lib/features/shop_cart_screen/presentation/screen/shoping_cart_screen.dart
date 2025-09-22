import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/helper/cache_helper/cache_helper.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/features/shop_cart_screen/data/models/get_cart_response.dart';
import 'package:wavex/features/shop_cart_screen/logic/shop_cart_cubit.dart';
import 'package:wavex/main.dart';
import '../../../../core/app_localization.dart';
import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../shop_screen/data/models/add_to_cart_request_body.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  int _selectedBottomNavIndex = 2; // Shopping bag icon is selected

  List<OrderItems> _cartItems = [];

  @override
  void initState() {
    ShopCartCubit.get(context).getCart(
      orderId: CacheHelper.getdata(key: "userToken") == null
          ? CacheHelper.getdata(key: "orderId")
          : null,

      // orderId: CacheHelper.getdata(key: "orderId")
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(isWithBack: true),
          BlocListener<ShopCartCubit, ShopCartState>(
            listener: (context, state) {
              if (state is GetCartSuccessState) {
                setState(() {
                  _cartItems = state.cartResponse.data?.orderItems ?? [];
                });
              }
              if (state is DecreaseItemSuccessState) {
                if (state.isFromDecrease) {
                  ShopCartCubit.get(context).getCart(
                    orderId: CacheHelper.getdata(key: "userToken") == null
                        ? CacheHelper.getdata(key: "orderId")
                        : null,
                    // orderId: CacheHelper.getdata(key: "orderId")
                  );
                }
              }
            },
            child: SizedBox.shrink(),
          ),
          Expanded(child: _buildCartScreen(localizations)),
          const SizedBox(height: 30),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 0),
            painter: BottomWavePainter(),
          ),
          BottomNavigation(
            currentIndex: _selectedBottomNavIndex,
          ),
        ],
      ),
    );
  }

  Widget _buildCartScreen(AppLocalizations localizations) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset("assets/images/water_drop_icon.png"),
              const SizedBox(width: 8),
              Text(localizations.translate("shop_cart_header"),
                  style: GoogleFonts.inter().copyWith(
                    color: const Color(0xFF2E535F),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
        ),
        Expanded(
          child: _cartItems.isNotEmpty?  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return _buildCartItem(item, index, localizations);
              },
            ),
          ) : Center(child: Text("Cart is Empty",),),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _cartItems.isNotEmpty? () {
                navigatorKey.currentState!
                    .pushNamed(RouteStrings.checkoutScreen);
              }: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF45818B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(localizations.translate("shop_cart_checkout"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(
      OrderItems item, int index, AppLocalizations localizations) {
    int quantity = _cartItems[index].quantity ?? 1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(item.product?.image ?? "",
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product?.name ?? "",
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF45818B),
                            )),
                        Row(
                          children: [
                            Text(
                                "${CacheHelper.getdata(key: "selectedCurrency") == "GBP" ? "£" : CacheHelper.getdata(key: "selectedCurrency") == "USD" ? "\$" : CacheHelper.getdata(key: "selectedCurrency") == "EGP" ? "ج.م" : "£"}${item.price ?? ""}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                )),
                            const Spacer(),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (quantity >= 1) {
                                        ShopCartCubit.get(context)
                                            .decreaseQuantity(
                                          orderItemId:
                                              _cartItems[index].id ?? 0,
                                          isFromDecrease: quantity == 1,
                                        );
                                        if (quantity != 1) {
                                          quantity--;
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF45818B),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.remove,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                    ShopCartCubit.get(context).addToCart(
                                      addToCartRequestBody:
                                          AddToCartRequestBody(
                                        orderId: CacheHelper.getdata(
                                                    key: "userToken") ==
                                                null
                                            ? CacheHelper.getdata(
                                                key: "orderId")
                                            : null,
                                        orderItems: [
                                          OrderItem(
                                            productId: _cartItems[index]
                                                .product
                                                ?.id
                                                .toString(),
                                            quantity: 1,
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF45818B),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final orderItemId = _cartItems[index].id ?? 0;
                              for (int i = quantity; i > 0; i--) {
                                ShopCartCubit.get(context).decreaseQuantity(
                                  orderItemId: orderItemId,
                                  isFromDecrease: i == 1,
                                );
                              }
                              // setState(() {
                              //   _cartItems.removeAt(index);
                              // });
                              // ScaffoldMessenger.of(context)
                              //   ..hideCurrentSnackBar()
                              //   ..showSnackBar(
                              //     SnackBar(
                              //       content: Text(localizations
                              //           .translate("shop_cart_item_removed")),
                              //       backgroundColor: const Color(0xFF45818B),
                              //     ),
                              //   );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF45818B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                                localizations.translate("shop_cart_remove"),
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

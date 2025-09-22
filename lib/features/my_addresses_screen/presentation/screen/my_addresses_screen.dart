import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/features/my_addresses_screen/data/models/get_my_addresses.dart';
import 'package:wavex/features/my_addresses_screen/logic/my_address_cubit.dart';
import 'package:wavex/main.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../core/theme/colors.dart';

class MyAddressesScreen extends StatefulWidget {
  const MyAddressesScreen({Key? key}) : super(key: key);

  @override
  State<MyAddressesScreen> createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends State<MyAddressesScreen>  with RouteAware{
  List<Address> addresses = Address.getSampleAddresses();

  List<AddressData> myAddresses = [];

  @override
  void initState() {
    // TODO: implement initState
    MyAddressCubit.get(context).getMyAddress();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // أول ما ترجع من AddManualAddressScreen
    MyAddressCubit.get(context).getMyAddress();
  }
  void _deleteAddress(int addressId) {
    // setState(() {
    //   addresses.removeWhere((address) => address.id == addressId);
    // });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Address deleted successfully'),
    //     backgroundColor: Colors.red,
    //   ),
    // );

    MyAddressCubit.get(context).deleteAddress(addressId: addressId);
  }

  void _editAddress(Address address) {
    ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
      SnackBar(
        content: Text('Edit ${address.type} address'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _addNewAddress() {
    navigatorKey.currentState!.pushNamed(RouteStrings.addManualAddressScreen,arguments: {
      "addressId" : null,
    });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Add new address'),
    //     backgroundColor: AppColors.primaryColor,
    //   ),
    // );
  }

  Widget _buildProfileCard() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4ABAD2),
            Color(0xFF479FB1),
            AppColors.primaryColor
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: GoogleFonts.leagueSpartan().copyWith(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        CacheHelper.getdata(key: "userImage") ?? "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //       padding: const EdgeInsets.all(4),
                  //       child: SvgPicture.asset(
                  //         "assets/svg_pictures/Icon.svg",
                  //         width: 25,
                  //       )),
                  // ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CacheHelper.getdata(key: "userName") ?? "Guest",
                      style: GoogleFonts.leagueSpartan().copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CacheHelper.getdata(key: "userPhone") != ""
                        ? Text(
                            CacheHelper.getdata(key: "userPhone") ?? "",
                            style: GoogleFonts.leagueSpartan().copyWith(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : const SizedBox.shrink(),
                    Text(
                      CacheHelper.getdata(key: "userEmail") ?? "",
                      maxLines: 1,
                      style: GoogleFonts.leagueSpartan().copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              HeaderWidget(
                isWithBack: true,
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      _buildProfileCard(),

                      const SizedBox(height: 30),

                      // My Addresses Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/water_drop_icon.png"),
                              const SizedBox(width: 12),
                              Text(
                                'My Addresses',
                                style: GoogleFonts.inter().copyWith(
                                  color: AppColors.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _addNewAddress,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              '+ Add New',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Address Cards
                      BlocConsumer<MyAddressCubit, MyAddressState>(
                        builder: (context, state) {
                          if (myAddresses.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final address = myAddresses[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDF7F9),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  address.name ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),

                                                // الايميل جوه Row + Expanded
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        address.email ?? "",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Color(0xCC23707C),
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 4),

                                                Text(
                                                  address.phone ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xCC23707C),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                ElevatedButton(
                                                  // onPressed: () =>
                                                  //     _editAddress(address),
                                                  onPressed: () {
                                                    navigatorKey.currentState!
                                                        .pushNamed(
                                                            RouteStrings
                                                                .addManualAddressScreen,
                                                            arguments: {
                                                          "addressId":
                                                              address.id ?? 0,
                                                        });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xff89BEC7),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                      vertical: 5,
                                                    ),
                                                    minimumSize:
                                                        const Size(100, 30),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Edit',
                                                    style: GoogleFonts
                                                            .leagueSpartan()
                                                        .copyWith(
                                                      color:
                                                          const Color(0xFF2E535F),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  onPressed: () => _deleteAddress(
                                                      address.id ?? 0),
                                                  // onPressed: () {},
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primaryColor,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                      vertical: 5,
                                                    ),
                                                    minimumSize:
                                                        const Size(100, 30),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Delete',
                                                    style: GoogleFonts
                                                            .leagueSpartan()
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 8),
                                      Text(
                                        address.address ?? "",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xCC23707C),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: myAddresses.length,
                            );
                          } else {
                            return const Center(
                              child: Text("No Addresses Found"),
                            );
                          }
                        },
                        listener: (context, state) {
                          if (state is GetMyAddressesSuccessState) {
                            setState(() {
                              myAddresses =
                                  state.myAddressesResponse.data ?? [];
                            });
                          }
                          if (state is DeleteAddressSuccessState) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                              SnackBar(
                                content: Text(
                                    state.deleteAddressResponse.message ?? ""),
                                backgroundColor: Colors.green,
                              ),
                            );
                            MyAddressCubit.get(context).getMyAddress();
                          }
                          if (state is DeleteAddressErrorState) {
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
                      )
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0),
                painter: BottomWavePainter(),
              ),
              const BottomNavigation(
                currentIndex: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Address {
  final String id;
  final String type;
  final String phone1;
  final String phone2;
  final String fullAddress;

  Address({
    required this.id,
    required this.type,
    required this.phone1,
    required this.phone2,
    required this.fullAddress,
  });

  static List<Address> getSampleAddresses() {
    return [
      Address(
        id: '1',
        type: 'Home',
        phone1: '01112121221522',
        phone2: '01112121221522',
        fullAddress:
            'address address address address address address address address address address . . .',
      ),
      Address(
        id: '2',
        type: 'Work',
        phone1: '01112121221522',
        phone2: '01112121221522',
        fullAddress:
            'address address address address address address address address address address . . .',
      ),
    ];
  }
}

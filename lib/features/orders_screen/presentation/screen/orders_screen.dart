import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/features/orders_screen/data/models/get_orders_response.dart';
import 'package:wavex/features/orders_screen/logic/orders_cubit.dart';
import 'package:wavex/main.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/header_widget.dart';
import '../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/format_data_to_string.dart';
import '../widgets/enhanced_order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<OrderData> ordersData = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    OrdersCubit.get(context).getOrders();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //       _scrollController.position.maxScrollExtent - 100) {
    //     if (!isLoadingMore && hasMore) {
    //       setState(() {
    //         isLoadingMore = true;
    //         currentPage++;
    //       });
    //       OrdersCubit.get(context).getOrders(page: currentPage);
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header
              HeaderWidget(
                isWithBack: true,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      _buildProfileCard(),

                      const SizedBox(height: 30),

                      // My Orders Title
                      Row(
                        children: [
                          Image.asset("assets/images/water_drop_icon.png"),
                          const SizedBox(width: 12),
                          Text(
                            'My Orders',
                            style: GoogleFonts.inter().copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // const SizedBox(height: 20),

                      BlocConsumer<OrdersCubit, OrdersState>(
                          builder: (context, state) {
                        if (ordersData.isNotEmpty) {
                          // Orders List
                          return Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount:
                                  ordersData.length + (isLoadingMore ? 1 : 0),
                              // separatorBuilder: (_, __) =>
                              //     const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                if (index < ordersData.length) {
                                  final order = ordersData[index];
                                  // return EnhancedOrderCard(
                                  //   order: order,
                                  //   // onOrderAgain: () {
                                  //   //
                                  //   // },
                                  //   onViewDetails: () {
                                  //     // Handle view details
                                  //     navigatorKey.currentState!.pushNamed(
                                  //         RouteStrings.orderDetailsScreen,arguments: {
                                  //           "orderId" : order.id??""
                                  //     });
                                  //     // ScaffoldMessenger.of(context).showSnackBar(
                                  //     //   const SnackBar(
                                  //     //     content: Text('View Details tapped'),
                                  //     //     duration: Duration(seconds: 1),
                                  //     //   ),
                                  //     // );
                                  //   },
                                  // );
                                  return _buildOrderCard(order);
                                }
                                if(ordersData.isEmpty){
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: Text("No Orders Found")),
                                  );
                                }
                                else {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: Text("No Orders Found")),
                          );
                        }
                      }, listener: (context, state) {
                        if (state is GetOrdersSuccessState) {
                          setState(() {
                            ordersData = state.ordersResponse.data ?? [];

                            // Check if there are more pages
                            // final lastPage =
                            //     state.ordersResponse.data?.lastPage ?? 1;
                            // print(lastPage);
                            // print(currentPage);
                            // hasMore = currentPage < lastPage;

                            // Stop loading spinner
                            // isLoadingMore = false;
                          });
                        }
                      }),
                    ],
                  ),
                ),
              ),
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 0),
                painter: BottomWavePainter(),
              ),
              const BottomNavigation(
                currentIndex: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: Image.network(
                CacheHelper.getdata(key: "userImage") ??
                    "https://media.istockphoto.com/id/1131164548/vector/avatar-5.jpg?s=612x612&w=0&k=20&c=CK49ShLJwDxE4kiroCR42kimTuuhvuo2FH5y_6aSgEo=",
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
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
    );
  }

  Widget _buildOrderCard(OrderData order) {
    return order.status != "cart"
        ? Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEDF7F9),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.status ?? "",
                        style: GoogleFonts.inter().copyWith(
                          color: order.status == "cancelled"
                              ? const Color(0xFFD70404)
                              : order.status == "on_the_way"
                                  ? const Color(0xFFF37D0F)
                                  : order.status == "processing"
                                      ? Colors.green
                                      : const Color(0xFF2E535F),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        )),
                    Expanded(
                      child: Text(
                          textAlign: TextAlign.end,
                          formatDate(context, order.createdAt),
                          style: GoogleFonts.inter().copyWith(
                            color: const Color(0xCC23707C),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Amount and Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(order.total.toString(),
                                style: GoogleFonts.inter().copyWith(
                                  color: order.status == "cancelled"
                                      ? const Color(0xFFD70404)
                                      : order.status == "on_the_way"
                                          ? const Color(0xFFF37D0F)
                                          : order.status == "processing"
                                              ? Colors.green
                                              : const Color(0xFF2E535F),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text(" GBP",
                                style: GoogleFonts.inter().copyWith(
                                  color: order.status == "cancelled"
                                      ? const Color(0xFFD70404)
                                      : order.status == "on_the_way"
                                          ? const Color(0xFFF37D0F)
                                          : order.status == "processing"
                                              ? Colors.green
                                              : const Color(0xFF2E535F),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                        // const SizedBox(height: 4),
                        // GestureDetector(
                        //   onTap: () {
                        //     // Handle view details
                        //     navigatorKey.currentState!.pushNamed(
                        //         RouteStrings.orderDetailsScreen,
                        //         arguments: {"orderId": order.id ?? ""});
                        //     // ScaffoldMessenger.of(context).showSnackBar(
                        //     //   const SnackBar(
                        //     //     content: Text('View Details tapped'),
                        //     //     duration: Duration(seconds: 1),
                        //     //   ),
                        //     // );
                        //   },
                        //   child: Text('View Details',
                        //       style: GoogleFonts.inter().copyWith(
                        //         color: const Color(0xCC23707C),
                        //         fontSize: 13,
                        //         fontWeight: FontWeight.w400,
                        //       )),
                        // ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle view details
                        navigatorKey.currentState!.pushNamed(
                            RouteStrings.orderDetailsScreen,
                            arguments: {"orderId": order.id ?? ""});
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text('View Details tapped'),
                        //     duration: Duration(seconds: 1),
                        //   ),
                        // );
                      },
                      child: Text('View Details',
                          style: GoogleFonts.inter().copyWith(
                            color: const Color(0xCC23707C),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          )),
                    ),
                    // Order Again Button
                    // ElevatedButton(
                    //   onPressed: () {
                    //     ScaffoldMessenger.of(context)
                    //       ..hideCurrentSnackBar()
                    //       ..showSnackBar(
                    //         const SnackBar(
                    //           content: Text('Order Again tapped'),
                    //           duration: Duration(seconds: 1),
                    //         ),
                    //       );
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: AppColors.primaryColor,
                    //     foregroundColor: Colors.white,
                    //     elevation: 0,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 16,
                    //       vertical: 8,
                    //     ),
                    //   ),
                    //   child: const Text(
                    //     'Order Again',
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

class Session {
  final String id;
  final String location;
  final String time;
  final String date;
  final SessionStatus status;

  Session({
    required this.id,
    required this.location,
    required this.time,
    required this.date,
    required this.status,
  });
}

enum SessionStatus {
  comingSoon,
  cancelled,
  attended,
}

extension SessionStatusExtension on SessionStatus {
  String get displayName {
    switch (this) {
      case SessionStatus.comingSoon:
        return 'Coming Soon';
      case SessionStatus.cancelled:
        return 'Cancelled';
      case SessionStatus.attended:
        return 'Attended';
    }
  }

  Color get color {
    switch (this) {
      case SessionStatus.comingSoon:
        return const Color(0xFFFF9800);
      case SessionStatus.cancelled:
        return const Color(0xFFE53E3E);
      case SessionStatus.attended:
        return const Color(0xFF718096);
    }
  }

  Color get borderColor {
    switch (this) {
      case SessionStatus.comingSoon:
        return const Color(0xFFFF9800);
      case SessionStatus.cancelled:
        return const Color(0xFFE53E3E);
      case SessionStatus.attended:
        return const Color(0xFF26C6DA);
    }
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  delivered,
  cancelled,
  rejected,
  onWay, // Added onWay status for the WaveX orders screen
}

class Order {
  final String id;
  final String customerName;
  final String items;
  final double total;
  final DateTime orderTime;
  OrderStatus status;

  final double amount;
  final String currency;
  final DateTime dateTime;

  Order({
    required this.id,
    this.customerName = '', // Made optional with default value
    this.items = '', // Made optional with default value
    this.total = 0.0, // Made optional with default value
    DateTime? orderTime, // Made optional
    required this.status,
    required this.amount, // Added required amount
    required this.currency, // Added required currency
    required this.dateTime, // Added required dateTime
  }) : orderTime =
            orderTime ?? DateTime.now(); // Default to now if not provided

  String get statusText {
    switch (status) {
      case OrderStatus.onWay:
        return 'On Way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.rejected:
        return 'Rejected';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.onWay:
        return const Color(0xFFFF9800); // Orange
      case OrderStatus.delivered:
        return const Color(0xFF757575); // Gray
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return const Color(0xFFE53935); // Red
      case OrderStatus.pending:
      case OrderStatus.confirmed:
      case OrderStatus.preparing:
      case OrderStatus.ready:
        return const Color(0xFF26C6DA); // Teal
    }
  }

  String get formattedAmount {
    return '${amount.toInt()} $currency';
  }

  String get formattedDate {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'june',
      'july',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];

    final weekday = weekdays[dateTime.weekday - 1];
    final month = months[dateTime.month - 1];
    final hour = dateTime.hour;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${dateTime.day} $weekday - $month - ${displayHour} $amPm';
  }
}

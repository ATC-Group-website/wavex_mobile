// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:wavex/core/components/header_widget.dart';
// import 'package:wavex/features/order_details_screen/logic/order_details_cubit.dart';
//
// import '../../../../core/components/bottom_navigation_bar.dart';
// import '../../../../core/components/bottom_wave_painter.dart';
// import '../../../../core/theme/colors.dart';
// import '../../data/models/order_details_response.dart';
//
// class OrderDetailsScreen extends StatefulWidget {
//   const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);
//   final String orderId;
//
//   @override
//   State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
// }
//
// class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     OrderDetailsCubit.get(context).getOrders(orderId: widget.orderId);
//     super.initState();
//   }
//
//   OrderData orderSummary= OrderData();
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Sample order data matching the design
//     // final orderSummary = OrderSummary(
//     //   items: [
//     //     OrderItem(name: 'Board', quantity: 1, price: 1000),
//     //     OrderItem(name: 'Board', quantity: 1, price: 1000),
//     //   ],
//     //   discount: 10,
//     //   shipping: 50,
//     //   totalCurrency: 'GBP',
//     // );
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // Header
//               HeaderWidget(isWithBack: true,),
//
//               // Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Order Details Section
//                       _buildSectionHeader('Order Details', "water_drop_icon.png"),
//                       const SizedBox(height: 16),
//                       _buildOrderDetailsCard(),
//
//                       const SizedBox(height: 24),
//
//                       // Delivery Address Section
//                       _buildSectionHeader('Delivery Address', "location.png"),
//                       const SizedBox(height: 16),
//                       _buildDeliveryAddressCard(),
//
//                       const SizedBox(height: 24),
//
//                       // Order Summary Section
//                       _buildSectionHeader('Order Summary', "money.png"),
//                       const SizedBox(height: 16),
//                       _buildOrderSummaryCard(orderSummary),
//
//                       const SizedBox(height: 100), // Extra space for wave
//                     ],
//                   ),
//                 ),
//               ),
//
//               CustomPaint(
//                 size: Size(MediaQuery.of(context).size.width, 0),
//                 painter: BottomWavePainter(),
//               ),
//               const BottomNavigation(
//                 currentIndex: 3,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(String title, String icon) {
//     return                       // My Orders Title
//       Row(
//         children: [
//           Image.asset("assets/images/$icon"),
//           const SizedBox(width: 12),
//           Text(
//             title,
//             style: GoogleFonts.inter().copyWith(
//               color: AppColors.primaryColor,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       );
//   }
//
//   Widget _buildOrderDetailsCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8F4F8),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: const Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'On Way',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.orange,
//                 ),
//               ),
//               Text(
//                 '1 Thursday - june - 8 AM',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Text(
//             '2500 GBP',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.orange,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Cash',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDeliveryAddressCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8F4F8),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'UserName',
//             style: GoogleFonts.leagueSpartan().copyWith(
//               color: const Color(0xFF44858F),
//               fontSize: 24,
//               fontWeight: FontWeight.w600,
//             )
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '01121212121',
//             style: GoogleFonts.leagueSpartan().copyWith(
//               color: const Color(0xFF44858F),
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//             )
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '11 Building - 15 Street - Floor - Apartment',
//             style: GoogleFonts.leagueSpartan().copyWith(
//               color: const Color(0xFF44858F),
//               fontSize: 18,
//               fontWeight: FontWeight.w400,
//             )
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOrderSummaryCard(OrderData summary) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE8F4F8),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           // Order items
//           ...summary.items.map((item) => Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   item.displayText,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   item.formattedPrice,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//
//           // Discount
//           Padding(
//             padding: const EdgeInsets.only(bottom: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Discount',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.red,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 Text(
//                   summary.formattedDiscount,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.red,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Shipping
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Shipping',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   summary.formattedShipping,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Divider
//           Container(
//             height: 1,
//             color: Colors.grey.withOpacity(0.3),
//             margin: const EdgeInsets.only(bottom: 16),
//           ),
//
//           // Total
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Total Price',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               Text(
//                 summary.formattedTotal,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/features/order_details_screen/logic/order_details_cubit.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/theme/colors.dart';
import '../../data/models/order_details_response.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);
  final String orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    OrderDetailsCubit.get(context).getOrders(orderId: widget.orderId);
    super.initState();
  }

  OrderData orderSummary = OrderData();

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

              BlocListener<OrderDetailsCubit, OrderDetailsState>(
                listener: (context, state) {
                  if (state is GetOrderDetailsSuccessState) {
                    setState(() {
                      orderSummary =
                          state.orderDetailsResponse.data ?? OrderData();
                    });
                  }
                },
                child: SizedBox.shrink(),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Details Section
                      _buildSectionHeader(
                          'Order Details', "water_drop_icon.png"),
                      const SizedBox(height: 16),
                      _buildOrderDetailsCard(),

                      const SizedBox(height: 24),

                      // Delivery Address Section
                      _buildSectionHeader('Delivery Address', "location.png"),
                      const SizedBox(height: 16),
                      _buildDeliveryAddressCard(),

                      const SizedBox(height: 24),

                      // Order Summary Section
                      _buildSectionHeader('Order Summary', "money.png"),
                      const SizedBox(height: 16),
                      _buildOrderSummaryCard(orderSummary),

                      const SizedBox(height: 100), // Extra space for wave
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

  Widget _buildSectionHeader(String title, String icon) {
    return Row(
      children: [
        Image.asset("assets/images/$icon"),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter().copyWith(
            color: AppColors.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getStatusDisplay(orderSummary.status ?? 'pending'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(orderSummary.status ?? 'pending'),
                ),
              ),
              Text(
                _formatDate(orderSummary.createdAt ?? ''),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${orderSummary.total?.toStringAsFixed(2) ?? '0.00'} GBP',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                orderSummary.paymentMethod ?? 'Cash',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPaymentStatusColor(
                      orderSummary.paymentStatus ?? 'pending'),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  orderSummary.paymentStatus ?? 'Pending',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddressCard() {
    final address = orderSummary.address;
    final user = orderSummary.user;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim().isEmpty
                  ? address?.name ?? 'UserName'
                  : '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
              style: GoogleFonts.leagueSpartan().copyWith(
                color: const Color(0xFF44858F),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 8),
          Text(user?.phone ?? address?.phone ?? '01121212121',
              style: GoogleFonts.leagueSpartan().copyWith(
                color: const Color(0xFF44858F),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              )),
          const SizedBox(height: 8),
          Text(_formatAddress(address),
              style: GoogleFonts.leagueSpartan().copyWith(
                color: const Color(0xFF44858F),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard(OrderData summary) {
    final orderItems = summary.orderItems ?? [];
    final subtotal = summary.cost ?? 0.0;
    final shipping = summary.shippingFees?.toDouble() ?? 0.0;
    final total = summary.total ?? 0.0;
    final discount =
        subtotal + shipping - total; // Calculate discount from difference

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Order items
          ...orderItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product ${item.productId} (${item.quantity}x)',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${item.total} GBP',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),

          // Subtotal
          // if (orderItems.isNotEmpty)
          //   Padding(
          //     padding: const EdgeInsets.only(bottom: 12),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         const Text(
          //           'Subtotal',
          //           style: TextStyle(
          //             fontSize: 14,
          //             color: Colors.grey,
          //           ),
          //         ),
          //         Text(
          //           '${subtotal.toStringAsFixed(2)} GBP',
          //           style: const TextStyle(
          //             fontSize: 14,
          //             color: Colors.grey,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),

          // Discount (if applicable)
          if (discount > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '-${discount.toStringAsFixed(2)} GBP',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Shipping
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shipping',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${shipping.toStringAsFixed(2)} GBP',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.only(bottom: 16),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${total.toStringAsFixed(2)} GBP',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'shipped':
        return 'On Way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final weekday = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ][date.weekday - 1];
      final month = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][date.month - 1];
      return '${date.day} $weekday - $month - ${date.hour} ${date.hour >= 12 ? 'PM' : 'AM'}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatAddress(Address? address) {
    if (address == null) return '11 Building - 15 Street - Floor - Apartment';

    List<String> parts = [];
    if (address.address != null && address.address!.isNotEmpty) {
      parts.add(address.address!);
    }
    if (address.apartment != null && address.apartment.toString().isNotEmpty) {
      parts.add('Apartment ${address.apartment}');
    }
    if (address.city != null && address.city.toString().isNotEmpty) {
      parts.add(address.city.toString());
    }
    if (address.governorate != null &&
        address.governorate.toString().isNotEmpty) {
      parts.add(address.governorate.toString());
    }

    return parts.isEmpty
        ? '11 Building - 15 Street - Floor - Apartment'
        : parts.join(' - ');
  }
}

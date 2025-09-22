import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/get_orders_response.dart';

class EnhancedOrderCard extends StatelessWidget {
  final OrderData order;
  final VoidCallback? onViewDetails;
  final VoidCallback? onOrderAgain;

  const EnhancedOrderCard({
    Key? key,
    required this.order,
    this.onViewDetails,
    this.onOrderAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildOrderCard(context, order);
  }

  Widget _buildOrderCard(BuildContext context, OrderData order) {
    if (order.status == "cart") {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Status Header with colored background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _getStatusColor(order.status).withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Status Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(order.status),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Status Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusDisplayText(order.status),
                          style: GoogleFonts.inter(
                            color: _getStatusColor(order.status),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Order #${order.id ?? 'N/A'}',
                          style: GoogleFonts.inter(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Date
                  Text(
                    formatDate(context, order.createdAt),
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Order Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Amount Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount',
                            style: GoogleFonts.inter(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '£${order.total?.toString() ?? '0'}',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF1A1A1A),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(
                                  'GBP',
                                  style: GoogleFonts.inter(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Payment Status Badge
                      if (order.paymentStatus != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: order.paymentStatus == 'paid'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: order.paymentStatus == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            order.paymentStatus?.toUpperCase() ?? '',
                            style: GoogleFonts.inter(
                              color: order.paymentStatus == 'paid'
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      // View Details Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onViewDetails ?? () {
                            // Default navigation logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('View Details tapped'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 16),
                          label: const Text('View Details'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2E535F),
                            side: const BorderSide(
                              color: Color(0xFF2E535F),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Order Again Button (only show for completed orders)
                      // if (order.status == 'delivered' || order.status == 'completed')
                      //   Expanded(
                      //     child: ElevatedButton.icon(
                      //       onPressed: onOrderAgain ?? () {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //             content: Text('Order Again tapped'),
                      //             duration: Duration(seconds: 1),
                      //           ),
                      //         );
                      //       },
                      //       icon: const Icon(Icons.refresh, size: 16),
                      //       label: const Text('Order Again'),
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: const Color(0xFF2E535F),
                      //         foregroundColor: Colors.white,
                      //         elevation: 0,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(12),
                      //         ),
                      //         padding: const EdgeInsets.symmetric(vertical: 12),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'cancelled':
        return const Color(0xFFD70404);
      case 'on_the_way':
      case 'shipped':
        return const Color(0xFFF37D0F);
      case 'processing':
        return const Color(0xFF10B981);
      case 'delivered':
      case 'completed':
        return const Color(0xFF059669);
      case 'pending':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF2E535F);
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'on_the_way':
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'processing':
        return Icons.hourglass_empty;
      case 'delivered':
      case 'completed':
        return Icons.check_circle_outline;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  String _getStatusDisplayText(String? status) {
    switch (status?.toLowerCase()) {
      case 'on_the_way':
        return 'On the Way';
      case 'cancelled':
        return 'Cancelled';
      case 'processing':
        return 'Processing';
      case 'delivered':
        return 'Delivered';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'shipped':
        return 'Shipped';
      default:
        return status?.toUpperCase() ?? 'Unknown';
    }
  }

  String formatDate(BuildContext context, String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

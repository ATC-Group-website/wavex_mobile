import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wavex/core/components/header_widget.dart';
import 'package:wavex/core/di/dependency_injection.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/core/theme/colors.dart';
import 'package:wavex/core/utils/convert_to_arabic_date.dart';
import 'package:wavex/features/sessions_screen/data/models/get_sessions_response.dart';
import 'package:wavex/features/sessions_screen/data/models/my_sessions_response.dart';
import 'package:wavex/features/sessions_screen/logic/sessions_cubit.dart';
import 'package:wavex/main.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/helper/cache_helper/cache_helper.dart';
import '../../../../core/utils/format_data_to_string.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SessionsCubit.get(context).getSessions(page: 1);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore &&
            pagination != null &&
            pagination!.hasMorePages == true) {
          isLoadingMore = true;
          SessionsCubit.get(context)
              .getSessions(page: (pagination!.currentPage ?? 1) + 1);
        }
      }
    });
    super.initState();
  }

  List<Sessions> sessionsData = [];
  Pagination? pagination;
  bool isLoadingMore = false;

  final ScrollController _scrollController = ScrollController();

  // _buildSessionCard(Sessions session, startTime, endTime) {
  //   return Container(
  //     // height: 800,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF7FAFC),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border(
  //         left: BorderSide(
  //           width: 4,
  //           color: session.status.toString().toLowerCase() == "cancelled"
  //               ? Colors.red
  //               : AppColors.primaryColor,
  //         ),
  //       ),
  //     ),
  //     padding: const EdgeInsets.all(16),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Image.asset(
  //           "assets/images/water_drop_icon.png",
  //           color: const Color(0xFF26C6DA),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       session.location?.areaName ?? "",
  //                       style: const TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                           color: Color(0xFF2D3748)),
  //                     ),
  //                   ),
  //                   Text(
  //                     formatDate(context,
  //                         session.sessionDate ?? DateTime.now().toString()),
  //                     style: const TextStyle(
  //                         fontSize: 10, color: Color(0xFF718096)),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Text(
  //                       session.program?.name ?? "",
  //                       style: const TextStyle(
  //                           fontSize: 16, color: Color(0xFF4A5568)),
  //                     ),
  //                   ),
  //                   Text(
  //                     "$startTime - $endTime",
  //                     style: const TextStyle(
  //                         fontSize: 12, color: Color(0xFF4A5568)),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.person,
  //                           color: Color(0xFF4DBDD5), size: 20),
  //                       const SizedBox(
  //                         width: 5,
  //                       ),
  //                       Text(
  //                         '${session.instructor?.firstName ?? ""} ${session.instructor?.lastName ?? ""}',
  //                         style: const TextStyle(
  //                             fontSize: 12, color: Color(0xFF718096)),
  //                       ),
  //                     ],
  //                   ),
  //                   Text(
  //                     session.status ?? "",
  //                     style: const TextStyle(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w600,
  //                         color: Color(0xffF37E10)),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // Widget _buildSessionCard(Sessions session, String startTime, String endTime) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 8),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           Colors.white,
  //           Colors.grey.shade50,
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.08),
  //           blurRadius: 20,
  //           offset: const Offset(0, 8),
  //         ),
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //       border: Border.all(
  //         color: Colors.grey.shade100,
  //         width: 1,
  //       ),
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           border: Border(
  //             left: BorderSide(
  //               width: 6,
  //               color: _getStatusColor(session.status),
  //             ),
  //           ),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Header Row
  //               Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           const Color(0xFF26C6DA).withOpacity(0.1),
  //                           const Color(0xFF26C6DA).withOpacity(0.05),
  //                         ],
  //                       ),
  //                       borderRadius: BorderRadius.circular(16),
  //                     ),
  //                     child: Image.asset(
  //                       "assets/images/water_drop_icon.png",
  //                       color: const Color(0xFF26C6DA),
  //                       width: 24,
  //                       height: 24,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           session.location?.areaName ?? "Unknown Location",
  //                           style: const TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(0xFF1A202C),
  //                             letterSpacing: -0.5,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           session.program?.name ?? "No Program",
  //                           style: TextStyle(
  //                             fontSize: 14,
  //                             color: Colors.grey.shade600,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 12,
  //                       vertical: 6,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: _getStatusColor(session.status).withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(20),
  //                       border: Border.all(
  //                         color:
  //                             _getStatusColor(session.status).withOpacity(0.3),
  //                         width: 1,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       session.status ?? "Unknown",
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w600,
  //                         color: _getStatusColor(session.status),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               // Date and Time Information
  //               Container(
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade50,
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: Colors.grey.shade200,
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     // Session Date Row
  //                     // Session Date Row
  //                     Row(
  //                       mainAxisSize: MainAxisSize.max, // يخلي الـ Row ياخد العرض المتاح
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: const Color(0xFF4DBDD5).withOpacity(0.1),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: const Icon(
  //                             Icons.calendar_today,
  //                             color: Color(0xFF4DBDD5),
  //                             size: 16,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Flexible(   // 👈 بدل Expanded
  //                           fit: FlexFit.loose,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Row(
  //                                 children: [
  //                                   const Text(
  //                                     'Session Date',
  //                                     style: TextStyle(
  //                                       fontSize: 12,
  //                                       color: Color(0xFF718096),
  //                                       fontWeight: FontWeight.w500,
  //                                     ),
  //                                   ),
  //                                   const Spacer(),
  //                                   Text(
  //                                     "$startTime - $endTime",
  //                                     style: const TextStyle(
  //                                       fontSize: 10,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Color(0xFF4A5568),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               const SizedBox(height: 2),
  //                               Text(
  //                                 formatDate(
  //                                   context,
  //                                   session.sessionDate ?? DateTime.now().toString(),
  //                                 ),
  //                                 style: const TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Color(0xFF2D3748),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //
  //                     const SizedBox(height: 12),
  //
  //                     // Booking Date Row (NEW)
  //                     Row(
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: Colors.orange.withOpacity(0.1),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: const Icon(
  //                             Icons.bookmark_added,
  //                             color: Colors.orange,
  //                             size: 16,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             const Text(
  //                               'Booking Date',
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: Color(0xFF718096),
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 2),
  //                             Text(
  //                               formatDate(
  //                                   context,
  //                                   session.bookingDate ??
  //                                       DateTime.now().toString()),
  //                               style: const TextStyle(
  //                                 fontSize: 12,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: Color(0xFF2D3748),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 16),
  //
  //               // Instructor Information
  //               Container(
  //                 padding: const EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: [
  //                       const Color(0xFF4DBDD5).withOpacity(0.05),
  //                       const Color(0xFF4DBDD5).withOpacity(0.02),
  //                     ],
  //                   ),
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: const Color(0xFF4DBDD5).withOpacity(0.2),
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.all(10),
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xFF4DBDD5).withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: const Icon(
  //                         Icons.person,
  //                         color: Color(0xFF4DBDD5),
  //                         size: 20,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           const Text(
  //                             'Instructor',
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: Color(0xFF718096),
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 2),
  //                           Text(
  //                             '${session.instructor?.firstName ?? "Unknown"} ${session.instructor?.lastName ?? "Instructor"}',
  //                             style: const TextStyle(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w600,
  //                               color: Color(0xFF2D3748),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildSessionCard(Sessions session, String startTime, String endTime) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 8),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [
  //           Colors.white,
  //           Colors.grey.shade50,
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.08),
  //           blurRadius: 20,
  //           offset: const Offset(0, 8),
  //         ),
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.04),
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //       border: Border.all(
  //         color: Colors.grey.shade100,
  //         width: 1,
  //       ),
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           border: Border(
  //             left: BorderSide(
  //               width: 6,
  //               color: _getStatusColor(session.status),
  //             ),
  //           ),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Header Row
  //               Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(12),
  //                     decoration: BoxDecoration(
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           const Color(0xFF26C6DA).withOpacity(0.1),
  //                           const Color(0xFF26C6DA).withOpacity(0.05),
  //                         ],
  //                       ),
  //                       borderRadius: BorderRadius.circular(16),
  //                     ),
  //                     child: Image.asset(
  //                       "assets/images/water_drop_icon.png",
  //                       color: const Color(0xFF26C6DA),
  //                       width: 24,
  //                       height: 24,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           session.location?.areaName ?? "Unknown Location",
  //                           style: const TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                             color: Color(0xFF1A202C),
  //                             letterSpacing: -0.5,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           session.program?.name ?? "No Program",
  //                           style: TextStyle(
  //                             fontSize: 14,
  //                             color: Colors.grey.shade600,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 12,
  //                       vertical: 6,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: _getStatusColor(session.status).withOpacity(0.1),
  //                       borderRadius: BorderRadius.circular(20),
  //                       border: Border.all(
  //                         color:
  //                         _getStatusColor(session.status).withOpacity(0.3),
  //                         width: 1,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       session.status ?? "Unknown",
  //                       style: TextStyle(
  //                         fontSize: 12,
  //                         fontWeight: FontWeight.w600,
  //                         color: _getStatusColor(session.status),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               // Date and Time Information
  //               Container(
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey.shade50,
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: Colors.grey.shade200,
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Column(
  //                   children: [
  //                     // Session Date Row
  //                     // Session Date Row
  //                     Row(
  //                       mainAxisSize: MainAxisSize.max, // يخلي الـ Row ياخد العرض المتاح
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: const Color(0xFF4DBDD5).withOpacity(0.1),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: const Icon(
  //                             Icons.calendar_today,
  //                             color: Color(0xFF4DBDD5),
  //                             size: 16,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Flexible(   // 👈 بدل Expanded
  //                           fit: FlexFit.loose,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Row(
  //                                 children: [
  //                                   const Text(
  //                                     'Session Date',
  //                                     style: TextStyle(
  //                                       fontSize: 12,
  //                                       color: Color(0xFF718096),
  //                                       fontWeight: FontWeight.w500,
  //                                     ),
  //                                   ),
  //                                   const Spacer(),
  //                                   Text(
  //                                     "$startTime - $endTime",
  //                                     style: const TextStyle(
  //                                       fontSize: 10,
  //                                       fontWeight: FontWeight.w600,
  //                                       color: Color(0xFF4A5568),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               const SizedBox(height: 2),
  //                               Text(
  //                                 formatDate(
  //                                   context,
  //                                   session.sessionDate ?? DateTime.now().toString(),
  //                                 ),
  //                                 style: const TextStyle(
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.w600,
  //                                   color: Color(0xFF2D3748),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //
  //                     const SizedBox(height: 12),
  //
  //                     // Booking Date Row (NEW)
  //                     Row(
  //                       children: [
  //                         Container(
  //                           padding: const EdgeInsets.all(8),
  //                           decoration: BoxDecoration(
  //                             color: Colors.orange.withOpacity(0.1),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: const Icon(
  //                             Icons.bookmark_added,
  //                             color: Colors.orange,
  //                             size: 16,
  //                           ),
  //                         ),
  //                         const SizedBox(width: 12),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             const Text(
  //                               'Booking Date',
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                                 color: Color(0xFF718096),
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 2),
  //                             Text(
  //                               formatDate(
  //                                   context,
  //                                   session.bookingDate ?? DateTime.now().toString()),
  //                               style: const TextStyle(
  //                                 fontSize: 12,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: Color(0xFF2D3748),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 16),
  //
  //               // Instructor Information
  //               Container(
  //                 padding: const EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: [
  //                       const Color(0xFF4DBDD5).withOpacity(0.05),
  //                       const Color(0xFF4DBDD5).withOpacity(0.02),
  //                     ],
  //                   ),
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: const Color(0xFF4DBDD5).withOpacity(0.2),
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       padding: const EdgeInsets.all(10),
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xFF4DBDD5).withOpacity(0.1),
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: const Icon(
  //                         Icons.person,
  //                         color: Color(0xFF4DBDD5),
  //                         size: 20,
  //                       ),
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           const Text(
  //                             'Instructor',
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color: Color(0xFF718096),
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 2),
  //                           Text(
  //                             '${session.instructor?.firstName ?? "Unknown"} ${session.instructor?.lastName ?? "Instructor"}',
  //                             style: const TextStyle(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w600,
  //                               color: Color(0xFF2D3748),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               if (session.isRefundable == true) ...[
  //                 const SizedBox(height: 16),
  //                 Container(
  //                   width: double.infinity,
  //                   child: ElevatedButton.icon(
  //                     onPressed: () {
  //                       // Handle refund action
  //                       _handleRefund(session);
  //                     },
  //                     icon: const Icon(
  //                       Icons.money_off,
  //                       size: 18,
  //                       color: Colors.white,
  //                     ),
  //                     label: const Text(
  //                       'Request Refund',
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w600,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.red.shade400,
  //                       foregroundColor: Colors.white,
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 20,
  //                         vertical: 12,
  //                       ),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       elevation: 2,
  //                       shadowColor: Colors.red.shade200,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildSessionCard(Sessions session, String startTime, String endTime) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 6,
                color: _getStatusColor(session.status),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF26C6DA).withOpacity(0.1),
                            const Color(0xFF26C6DA).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        "assets/images/water_drop_icon.png",
                        color: const Color(0xFF26C6DA),
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.location?.areaName ?? "Unknown Location",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A202C),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            session.program?.name ?? "No Program",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(session.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              _getStatusColor(session.status).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        session.status ?? "Unknown",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(session.status),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Date and Time Information
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Session Date Row
                      // Session Date Row
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        // يخلي الـ Row ياخد العرض المتاح
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4DBDD5).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF4DBDD5),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            // 👈 بدل Expanded
                            fit: FlexFit.loose,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Session Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF718096),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "$startTime - $endTime",
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF4A5568),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  formatDate(
                                    context,
                                    session.sessionDate ??
                                        DateTime.now().toString(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Booking Date Row (NEW)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.bookmark_added,
                              color: Colors.orange,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Booking Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                session.bookingDate ?? "",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Instructor Information
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF4DBDD5).withOpacity(0.05),
                        const Color(0xFF4DBDD5).withOpacity(0.02),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF4DBDD5).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4DBDD5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF4DBDD5),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Instructor',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${session.instructor?.firstName ?? "Unknown"} ${session.instructor?.lastName ?? "Instructor"}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (session.isRefundable == true) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Handle refund action
                        _handleRefund(session, session.isFree);
                      },
                      icon: const Icon(
                        Icons.money_off,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        session.isFree ? "Request Cancel" : 'Request Refund',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: Colors.red.shade200,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRefund(Sessions session, bool isFree) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: getIt<SessionsCubit>()..getReasons(),
          child: RefundDialog(
            session: session,
            isFree: isFree,
          ),
        );
      },
    );
  }

  void _processRefund(Sessions session, String reason) {
    // TODO: Add your refund processing logic here with reason
    // This could include API calls, state updates, etc.
    print(
        'Processing refund for sessionProcessing refund for session: ${session.id} with reason: $reason');
  }

  // void _handleRefund(Sessions session) {
  //   // Show confirmation dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Request Refund'),
  //         content: Text(
  //           'Are you sure you want to request a refund for this session at ${session.location?.areaName ?? "Unknown Location"}?',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // TODO: Implement actual refund logic here
  //               _processRefund(session);
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.red.shade400,
  //             ),
  //             child: const Text('Confirm Refund'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // void _processRefund(Sessions session) {
  //   // TODO: Add your refund processing logic here
  //   // This could include API calls, state updates, etc.
  //   print('Processing refund for session: ${session.id}');
  // }

// Helper method to get status color
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return const Color(0xFF4DBDD5);
      case 'pending':
        return Colors.orange;
      default:
        return const Color(0xFF4DBDD5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // navigatorKey.currentState!.pushNamed(
        //   RouteStrings.profileScreen,
        // );
        navigatorKey.currentState!.pop();
        return false; // عشان ما يرجعش للصفحة القديمة
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Wave background
            // Main content
            Column(
              children: [
                HeaderWidget(
                  isWithBack: true,
                ),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Image.asset("assets/images/water_drop_icon.png"),
                          const SizedBox(width: 12),
                          Text(
                            'My Sessions',
                            style: GoogleFonts.inter().copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      BlocConsumer<SessionsCubit, SessionsState>(
                        builder: (context, state) {
                          if (state is GetSessionsLoadingState &&
                              sessionsData.isEmpty) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if(state is GetSessionsSuccessState && sessionsData.isEmpty){
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("No Sessions Found")),
                            );
                          }
                          return Column(
                            children: List.generate(
                              sessionsData.length + (isLoadingMore ? 1 : 0),
                              (index) {
                                if (index == sessionsData.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                Sessions session = sessionsData[index];
                                DateTime startTimeDate = DateFormat("HH:mm:ss")
                                    .parse(session.startTime ?? "");
                                String startTime =
                                    DateFormat("hh:mm a").format(startTimeDate);

                                DateTime endTimeDate = DateFormat("HH:mm:ss")
                                    .parse(session.endTime ?? "");
                                String endTime =
                                    DateFormat("hh:mm a").format(endTimeDate);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildSessionCard(
                                      session, startTime, endTime),
                                );
                              },
                            ),
                          );
                        },
                        listener: (context, state) {
                          if (state is GetSessionsSuccessState) {
                            setState(() {
                              pagination =
                                  state.sessionsResponse.data?.pagination ??
                                      Pagination();
                              if (pagination?.currentPage == 1) {
                                sessionsData = state.sessionsResponse.data?.user
                                        ?.sessions ??
                                    [];
                              } else {
                                sessionsData.addAll(state.sessionsResponse.data
                                        ?.user?.sessions ??
                                    []);
                              }
                              isLoadingMore = false;
                            });
                          }
                          if (state is MakeRefundSuccessState) {
                            SessionsCubit.get(context).getSessions(
                                page: (pagination!.currentPage ?? 1));
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content:
                                      Text(state.refundResponse.message ?? ""),
                                  // <-- show Stripe error
                                  backgroundColor: Colors.green,
                                ),
                              );
                          }
                          if (state is MakeRefundErrorState) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.error ?? ""),
                                  // <-- show Stripe error
                                  backgroundColor: Colors.red,
                                ),
                              );
                          }
                          if (state is CancelSessionSuccessState) {
                            SessionsCubit.get(context).getSessions(
                                page: (pagination!.currentPage ?? 1));
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content:
                                      Text(state.refundResponse.message ?? ""),
                                  // <-- show Stripe error
                                  backgroundColor: Colors.green,
                                ),
                              );
                          }
                          if (state is CancelSessionErrorState) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(state.error ?? ""),
                                  // <-- show Stripe error
                                  backgroundColor: Colors.red,
                                ),
                              );
                          }
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
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
}

class RefundDialog extends StatefulWidget {
  final Sessions session;
  final bool isFree;

  const RefundDialog({Key? key, required this.isFree, required this.session})
      : super(key: key);

  @override
  _RefundDialogState createState() => _RefundDialogState();
}

class _RefundDialogState extends State<RefundDialog> {
  String? selectedReason;
  List<String> refundReasons = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionsCubit, SessionsState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is GetRefundReasonsSuccessState) {
          refundReasons = state.reasonsResponse.data ?? [];
        }
      },
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.money_off,
                  color: Colors.red.shade400,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Request Refund',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Session: ${widget.session.location?.areaName ?? "Unknown Location"}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Please select a reason for the refund:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedReason,
                    hint: const Text(
                      'Select reason...',
                      style: TextStyle(color: Colors.grey),
                    ),
                    isExpanded: true,
                    items: refundReasons.map((String reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(
                          reason,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedReason = newValue;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: selectedReason == null
                  ? null
                  : widget.isFree
                      ? () {
                          Navigator.of(context).pop();
                          // Call the parent widget's refund processing method
                          // context
                          //     .findAncestorStateOfType<_SessionsScreenState>()
                          //     ?._processRefund(widget.session, selectedReason!);

                          SessionsCubit.get(context).cancelSession(
                              sessionId: widget.session.id ?? 0,
                              reason: selectedReason ?? "");
                        }
                      : () {
                          Navigator.of(context).pop();
                          // Call the parent widget's refund processing method
                          // context
                          //     .findAncestorStateOfType<_SessionsScreenState>()
                          //     ?._processRefund(widget.session, selectedReason!);

                          SessionsCubit.get(context).makeRefund(
                              sessionId: widget.session.id ?? 0,
                              reason: selectedReason ?? "");
                        },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedReason == null
                    ? Colors.grey.shade300
                    : Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

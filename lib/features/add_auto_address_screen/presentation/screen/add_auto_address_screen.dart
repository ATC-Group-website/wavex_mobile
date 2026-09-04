import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wavex/core/components/custom_text_field.dart';
import 'package:wavex/main.dart';

import '../../../../core/components/bottom_navigation_bar.dart';
import '../../../../core/components/bottom_wave_painter.dart';
import '../../../../core/components/header_widget.dart';
import '../../../../core/route/route_strings/route_strings.dart';
import '../../../../core/theme/colors.dart';

class AddAutoAddressScreen extends StatefulWidget {
  const AddAutoAddressScreen({Key? key}) : super(key: key);

  @override
  State<AddAutoAddressScreen> createState() => _AddAutoAddressScreenState();
}

class _AddAutoAddressScreenState extends State<AddAutoAddressScreen> {
  GoogleMapController? _mapController;
  final TextEditingController _addressLabelController = TextEditingController();
  bool _isDefaultAddress = false;
  LatLng? _currentLocation; // Atlanta coordinates
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addSampleMarkers();
    _getCurrentLocation();
  }

  void _addSampleMarkers() {
    // Sample markers to match the design
    _markers = {
      const Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(33.7490, -84.3880),
        infoWindow: InfoWindow(title: 'Location 1'),
      ),
      const Marker(
        markerId: MarkerId('marker2'),
        position: LatLng(33.7590, -84.3780),
        infoWindow: InfoWindow(title: 'Location 2'),
      ),
      const Marker(
        markerId: MarkerId('marker3'),
        position: LatLng(33.7390, -84.3980),
        infoWindow: InfoWindow(title: 'Location 3'),
      ),
      const Marker(
        markerId: MarkerId('marker4'),
        position: LatLng(33.7690, -84.3680),
        infoWindow: InfoWindow(title: 'Location 4'),
      ),
      const Marker(
        markerId: MarkerId('marker5'),
        position: LatLng(33.7290, -84.4080),
        infoWindow: InfoWindow(title: 'Location 5'),
      ),
    };
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
          const SnackBar(
              content: Text(
                  'Location permissions are permanently denied. Please enable them in settings.')),
        );
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
        SnackBar(content: Text('Unable to get current location: $e')),
      );
    }
  }

  void _saveAddress() {
    if (_addressLabelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
        const SnackBar(content: Text('Please enter an address label')),
      );
      return;
    }

    ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
      SnackBar(
        content: Text(
          'Address "${_addressLabelController.text}" saved successfully!',
        ),
        backgroundColor: const Color(0xFF26C6DA),
      ),
    );

    // Navigate back or to addresses list
    Navigator.pop(context);
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

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add New Address title
                      Row(
                        children: [
                          Image.asset("assets/images/water_drop_icon.png"),
                          const SizedBox(width: 12),
                          Text(
                            'Add New Address',
                            style: GoogleFonts.inter().copyWith(
                              color: AppColors.primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Map
                      _currentLocation != null
                          ? Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _mapController = controller;
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: _currentLocation!,
                                        zoom: 11,
                                      ),
                                      markers: _markers,
                                      myLocationEnabled: true,
                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: false,
                                    ),

                                    // Locate Me button
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: _getCurrentLocation,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: AppColors.primaryColor,
                                              )),
                                          child: Text('Locate Me',
                                              style: GoogleFonts.leagueSpartan()
                                                  .copyWith(
                                                color: const Color(0xFF45818B),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      const SizedBox(height: 10),

                      // Or Add It Manually
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle manual address entry
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text('Manual address entry feature'),
                            //   ),
                            // );
                            navigatorKey.currentState!.pushNamed(RouteStrings.addManualAddressScreen);
                          },
                          child: Text(
                            'Or Add It Manually',
                            style: TextStyle(
                              color: Color(0xFF26C6DA),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Address Label
                      Text(
                        'Address Label',
                        style: GoogleFonts.leagueSpartan().copyWith(
                          color: const Color(0xFF45818B),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Address Label Input
                      CustomTextField(
                          controller: _addressLabelController,
                          hintText: 'add your address label'),
                      const SizedBox(height: 10),

                      // Set as default checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: _isDefaultAddress,
                            onChanged: (value) {
                              setState(() {
                                _isDefaultAddress = value ?? false;
                              });
                            },
                            activeColor: AppColors.primaryColor,
                          ),
                          Text('Set as default address',
                              style: GoogleFonts.leagueSpartan().copyWith(
                                color: const Color(0xFF44858F),
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child:  Text(
                            'Save',
                            style: GoogleFonts.inter().copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  @override
  void dispose() {
    _addressLabelController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/main.dart';
import '../../splash_screen/presentation/screen/splash_screen.dart';

class VideoSplashScreen extends StatefulWidget {
  @override
  _VideoSplashScreenState createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/intro.mp4")
      ..initialize().then((_) {
        setState(() {}); // Refresh when video is ready
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        _goToSplash();
      }
    });
  }

  void _goToSplash() {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      RouteStrings.splashScreen,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller.value.isInitialized
          ? Stack(
              children: [

                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: TextButton(
                    onPressed: () {
                      _goToSplash();
                    },
                    child: Text(
                      "Skip",
                      style: GoogleFonts.inter().copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

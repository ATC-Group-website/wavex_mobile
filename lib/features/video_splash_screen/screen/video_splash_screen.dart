import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:wavex/core/route/route_strings/route_strings.dart';
import 'package:wavex/main.dart';

class VideoSplashScreen extends StatefulWidget {
  const VideoSplashScreen({super.key});

  @override
  State<VideoSplashScreen> createState() => _VideoSplashScreenState();
}

class _VideoSplashScreenState extends State<VideoSplashScreen> {
  late VideoPlayerController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/intro.mp4");
    _controller.addListener(_onVideoChanged);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    await _controller.initialize();
    if (!mounted) return;

    setState(() {});
    await _controller.play();
  }

  void _onVideoChanged() {
    final value = _controller.value;
    final hasFinished = value.isInitialized &&
        value.duration > Duration.zero &&
        value.position >= value.duration;

    if (hasFinished) {
      _goToSplash();
    }
  }

  void _goToSplash() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      RouteStrings.splashScreen,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoChanged);
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
                    fit: BoxFit.cover,
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
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

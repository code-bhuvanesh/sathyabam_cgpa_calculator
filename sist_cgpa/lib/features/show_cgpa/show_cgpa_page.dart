import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowCgpa extends StatefulWidget {
  static const String routeName = "/showCgpa";
  const ShowCgpa({super.key, required this.cgpa});
  final double cgpa;

  @override
  State<ShowCgpa> createState() => _ShowCgpaState();
}

class _ShowCgpaState extends State<ShowCgpa>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final int _stopFrame; // Frame to stop the animation

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );

    // You can set the frame to stop here
    // _stopFrame = 900; // Replace with the desired frame

    // _controller.addListener(() {
    //   // Calculate the current frame
    //   final frame =
    //       (_controller.value * _controller.duration!.inMilliseconds / 1000) *
    //           60; // Assuming 60 fps
    //   if (frame >= _stopFrame) {
    //     _controller.stop();
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var transformedCgpa = (cgpa * 100).toInt();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie_anim1.json',
              // controller: _controller,
            ),
            const SizedBox(
              height: 100,
            ),
            Text(
              " Your CGPA is ${widget.cgpa.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }
}

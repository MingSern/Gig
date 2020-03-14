import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;

  FadeIn({
    @required this.child,
    @required this.duration,
  });

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = Tween(
      begin: 0.0,
      end: 5.0,
    ).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();

    return Scaffold(
      body: FadeTransition(
        opacity: animation,
        child: widget.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/assets.gen.dart';
import '../bloc/splash_bloc.dart';

/// {@template splash_place_holder}
/// Splash place holder during checking auth
/// {@endtemplate}
class SplashPlaceHolder extends StatefulWidget {
  /// {@macro splash_place_holder}
  const SplashPlaceHolder({super.key});

  @override
  _SplashPlaceHolderState createState() => _SplashPlaceHolderState();
}

class _SplashPlaceHolderState extends State<SplashPlaceHolder>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );
    _animation2 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );
    _animation3 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeInOut),
    );

    // Bắt đầu animation với delay để tạo hiệu ứng lần lượt
    _startAnimation();
  }

  void _startAnimation() {
    if (!mounted) return; // Check if widget is still in the widget tree

    _controller1.forward().then((_) {
      if (mounted) _controller1.reverse();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        _controller2.forward().then((_) {
          if (mounted) _controller2.reverse();
          Future.delayed(const Duration(milliseconds: 200), () {
            if (!mounted) return;
            _controller3.forward().then((_) {
              if (mounted) _controller3.reverse();
            });
          });
        });
      });
    });

    // Schedule the next loop after a delay, ensuring the widget is mounted
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) _startAnimation();
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Your login session has expired. Please login again"),
                backgroundColor: Colors.red,
              ),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animation1,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation1.value),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Assets.images.splash1.image(
                      width: 30,
                      height: 40,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation2,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation2.value),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Assets.images.splash2.image(
                      width: 30,
                      height: 40,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation3,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation3.value),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Assets.images.splash3.image(
                      width: 30,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

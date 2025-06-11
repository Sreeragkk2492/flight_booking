// screens/splash_screen.dart
import 'package:flight_booking/theme/theme.dart';
import 'package:flight_booking/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _airplaneController;
  late AnimationController _logoController;
  late Animation<Offset> _airplaneAnimation;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    
    _airplaneController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    _logoController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _airplaneAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0.0),
      end: Offset(1.5, -0.5),
    ).animate(CurvedAnimation(
      parent: _airplaneController,
      curve: Curves.easeInOutQuart,
    ));

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 500));
    _logoController.forward();
    await Future.delayed(Duration(milliseconds: 300));
    _airplaneController.forward();
    
    await Future.delayed(Duration(seconds: 3));
    Get.off(() => HomeScreen(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryYellow,
              AppTheme.primaryYellow.withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Airplane Animation
            Center(
              child: SlideTransition(
                position: _airplaneAnimation,
                child: Text(
                  '✈️',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            ),
            // Logo Animation
            Center(
              child: ScaleTransition(
                scale: _logoAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'YellowJet',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBlue,
                      ),
                    ),
                    Text(
                      'AI Travel',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppTheme.darkBlue.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _airplaneController.dispose();
    _logoController.dispose();
    super.dispose();
  }
}
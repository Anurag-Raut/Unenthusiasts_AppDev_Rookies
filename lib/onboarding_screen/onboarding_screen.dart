import 'package:flutter/material.dart';
import 'package:wastenot/onboarding_screen/adminOnBoard.dart';
import 'package:wastenot/onboarding_screen/providerOnBoard.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'customerOnboard.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late final PageController pageController;
  late final Animatable<Color?> background;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _initialize() {
    background = TweenSequence<Color?>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.orange[600],
          end: Colors.deepPurple[400],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.deepPurple[400],
          end: Colors.yellow[300],
        ),
      ),
    ]);
    pageController = PageController();
  }

  @override
  void reassemble() {
    pageController.dispose();
    _initialize();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: AnimatedBuilder(
          animation: pageController,
          builder: (context, child) {
            final color = pageController.hasClients ? pageController.page! / 2 : .0;

            return DecoratedBox(
              decoration: BoxDecoration(
                color: background.evaluate(AlwaysStoppedAnimation(color)),
              ),
              child: child,
            );
          },
          child: PageView(
            controller: pageController,
            children: const [
              Center(child: FirstScreen()),
              Center(child: Second_screen()),
              Center(child: Third_screen()),
            ],
          ),
        ),
        
        bottomSheet: Container(
          
          
          height: 60,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              
              SmoothPageIndicator(
                
                  controller: pageController, // PageController
                  count: 3,
                  effect: WormEffect(), // your preferred effect
                  onDotClicked: (index) {}),
            ],
          ),
        ));
  }
}

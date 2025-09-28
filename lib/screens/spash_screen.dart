import 'package:flutter/material.dart';

// --- Constants for better readability ---
const Duration _kAnimationDuration = Duration(milliseconds: 2500);
const Duration _kNavigationDelay = Duration(milliseconds: 3000); // Wait for anim to finish
const Color _kSaffron = Color(0xFFFF9933); // Primary color
const Color _kDarkOrange = Color(0xFFE65100); // Dark text color
const Color _kGreyText = Color(0xFF757575); // Secondary text color

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation variables
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startNavigationTimer();
  }

  // Helper method to set up all animations
  void _initializeAnimations() {
    // 1. Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: _kAnimationDuration,
    );

    // 2. Define Animations
    // ICON SCALE: Begins small and 'pops' out.
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // FADE: Delayed fade-in for text elements.
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // SLIDE: Slide up for text elements.
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // COLOR: Animates the icon border/color from light to solid.
    _colorAnimation = ColorTween(
      begin: _kSaffron.withOpacity(0.4),
      end: _kSaffron,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 3. Start Animation
    _controller.forward();
  }

  // Helper method for navigation logic
  void _startNavigationTimer() async {
    // Wait for the total navigation delay (slightly longer than animation)
    await Future.delayed(_kNavigationDelay, () {});

    // Check if the widget is still in the tree before navigating
    if (mounted) {
      // NOTE: Ensure '/home' is correctly registered in your MaterialApp routes.
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            // Enhanced Gradient: More subtle and balanced.
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _kSaffron,
                Color(0xFFFFB74D), // A slightly brighter intermediate orange
                Colors.white,
                Color(0xFFF5F5F5), // Off-white near the bottom
              ],
              stops: [0.0, 0.35, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // --- Animated Background Circle Elements ---
              _buildBackgroundCircle(
                size,
                top: size.height * -0.08,
                right: size.width * -0.08,
                scaleFactor: 1.0,
                opacity: 0.1,
              ),
              _buildBackgroundCircle(
                size,
                bottom: size.height * -0.12,
                left: size.width * -0.12,
                scaleFactor: 0.75,
                opacity: 0.08,
              ),

              // --- Main Content (Icon, Text, Loader) ---
              Center(
                // SingleChildScrollView is a great addition for small screens!
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1. Logo/Icon Container
                      _buildLogoIcon(size),

                      SizedBox(height: size.height * 0.05),

                      // 2. App Name
                      _buildAnimatedText(
                        text: 'Mandir Seva',
                        size: size,
                        fontSizeFactor: 0.12,
                        color: _kDarkOrange,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        shadows: const [
                          Shadow(
                            blurRadius: 12, // Increased blur for a softer shadow
                            color: Colors.black26,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.02),

                      // 3. Tagline
                      _buildAnimatedText(
                        text: 'Serving the Divine',
                        size: size,
                        fontSizeFactor: 0.055,
                        color: _kGreyText,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.2,
                      ),

                      SizedBox(height: size.height * 0.08),

                      // 4. Animated Loading Indicator
                      _buildLoadingIndicator(size),

                      const SizedBox(height: 20),

                      // 5. Loading Text
                      _buildLoadingText(size),
                    ],
                  ),
                ),
              ),

              // --- Fixed Bottom Text ---
              _buildBottomAttribution(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders for better code organization ---

  Widget _buildBackgroundCircle(
      Size size, {
        double? top,
        double? bottom,
        double? left,
        double? right,
        required double scaleFactor,
        required double opacity,
      }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Use the fade animation to bring the circles in
          return Transform.scale(
            scale: _fadeAnimation.value * scaleFactor,
            child: Container(
              width: size.width * 0.5, // Slightly larger size
              height: size.width * 0.5,
              decoration: BoxDecoration(
                color: _kSaffron.withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoIcon(Size size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double iconContainerSize = size.width * 0.38; // Slightly larger icon
        return Container(
          height: iconContainerSize,
          width: iconContainerSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: _colorAnimation.value ?? _kSaffron,
              width: 5,
            ),
            boxShadow: [
              BoxShadow(
                // Box Shadow grows/pulses with the animation
                color: _kSaffron.withOpacity(0.4 * _controller.value),
                blurRadius: 30, // Increased blur for a softer glow
                spreadRadius: 5,
                offset: const Offset(0, 8), // More distinct lift
              ),
            ],
            // Subtle internal gradient for a 3D effect
            gradient: const RadialGradient(
              colors: [
                Colors.white,
                Color(0xFFFFF3E0),
              ],
              stops: [0.6, 1.0],
            ),
          ),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.temple_hindu,
              size: iconContainerSize * 0.6,
              color: _colorAnimation.value ?? _kSaffron,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText({
    required String text,
    required Size size,
    required double fontSizeFactor,
    required Color color,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    List<Shadow>? shadows,
  }) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.width * fontSizeFactor,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
            shadows: shadows,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Size size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: size.width * 0.1,
          height: size.width * 0.1,
          child: CircularProgressIndicator(
            // Color pulses slightly brighter near the end
            valueColor: AlwaysStoppedAnimation<Color>(
              _kSaffron.withOpacity(0.7 + (_controller.value * 0.3)),
            ),
            strokeWidth: 4,
            // Show indeterminate if animation is complete, otherwise show progress
            value: _controller.status == AnimationStatus.completed
                ? null
                : _controller.value,
          ),
        );
      },
    );
  }

  Widget _buildLoadingText(Size size) {
    return FadeTransition(
      // Dedicated fade animation for the loading text, slightly delayed
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.65, 1.0),
        ),
      ),
      child: Text(
        'Loading...',
        style: TextStyle(
          fontSize: size.width * 0.04,
          color: const Color(0xFF9E9E9E),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBottomAttribution() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: FadeTransition(
        // Delayed fade for the bottom text
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.75, 1.0),
          ),
        ),
        child: const Column(
          children: [
            Text(
              'App developed by',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF9E9E9E),
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 2),
            Text(
              // **BOLDED AS REQUESTED**
              'VisionEdge',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: _kGreyText,
                fontWeight: FontWeight.w800, // Made bolder
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class VirtualTourScreen extends StatefulWidget {
  const VirtualTourScreen({super.key});

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  final PageController _pageController = PageController();
  int _currentTourIndex = 0;
  final List<Map<String, dynamic>> _tourSpots = [
    {
      'name': 'Main Entrance',
      'description': 'Begin your spiritual journey at the grand, beautifully carved entrance to the temple complex.',
      'image': '🏛️',
      'color': Colors.indigo,
    },
    {
      'name': 'Sanctum Sanctorum',
      'description': 'The heart of the temple. Feel the divine energy near the main deity in this sacred space.',
      'image': '🕉️',
      'color': Colors.deepOrange,
    },
    {
      'name': 'Prayer Hall',
      'description': 'A spacious hall designed for devotees to gather for collective prayers and spiritual discourses.',
      'image': '🙏',
      'color': Colors.teal,
    },
    {
      'name': 'Meditation Gardens',
      'description': 'A tranquil, peaceful area with lush greenery, perfect for quiet contemplation and meditation.',
      'image': '🌳',
      'color': Colors.green,
    },
    {
      'name': 'Prasadalaya',
      'description': 'Enjoy fresh, blessed food and refreshments to complete your spiritual experience.',
      'image': '🍽️',
      'color': Colors.brown,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final newPage = _pageController.page!.round();
    if (newPage != _currentTourIndex) {
      setState(() {
        _currentTourIndex = newPage;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSpot = _tourSpots[_currentTourIndex];
    final Color spotColor = currentSpot['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Virtual Temple Tour',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: spotColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  spotColor.withOpacity(0.15),
                  spotColor.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Main Content
          PageView.builder(
            controller: _pageController,
            itemCount: _tourSpots.length,
            itemBuilder: (context, index) {
              return _buildTourSpotCard(_tourSpots[index]);
            },
          ),

          // Navigation Controls
          _buildNavigationControls(),

          // Progress Indicator
          _buildBottomProgressIndicator(),
        ],
      ),
      floatingActionButton: _buildFloatingActions(spotColor),
    );
  }

  Widget _buildTourSpotCard(Map<String, dynamic> spot) {
    final Color spotColor = spot['color'] as Color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container with enhanced design
          Container(
            padding: const EdgeInsets.all(40),
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  spotColor.withOpacity(0.2),
                  spotColor.withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: spotColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: spotColor.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              spot['image'],
              style: const TextStyle(fontSize: 64),
            ),
          ),

          // Title with better typography
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: spotColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              spot['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: spotColor,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Description with improved layout
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              spot['description'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _currentTourIndex > 0 ? 1.0 : 0.3,
              child: _NavigationButton(
                icon: Icons.arrow_back_ios_rounded,
                onPressed: _currentTourIndex > 0 ? _previousSpot : null,
              ),
            ),

            // Next Button
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _currentTourIndex < _tourSpots.length - 1 ? 1.0 : 0.3,
              child: _NavigationButton(
                icon: Icons.arrow_forward_ios_rounded,
                onPressed: _currentTourIndex < _tourSpots.length - 1 ? _nextSpot : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomProgressIndicator() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Progress text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spot ${_currentTourIndex + 1} of ${_tourSpots.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    _tourSpots[_currentTourIndex]['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              LinearProgressIndicator(
                value: (_currentTourIndex + 1) / _tourSpots.length,
                backgroundColor: Colors.grey.shade200,
                color: Colors.indigo,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              const SizedBox(height: 16),

              // Dot indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tourSpots.length, (index) {
                  final bool isActive = _currentTourIndex == index;
                  return GestureDetector(
                    onTap: () => _goToSpot(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isActive ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.indigo : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActions(Color spotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AR Experience Button
          FloatingActionButton(
            onPressed: _startARExperience,
            tooltip: 'AR Experience',
            heroTag: 'ar_fab',
            backgroundColor: spotColor,
            foregroundColor: Colors.white,
            elevation: 2,
            child: const Icon(Icons.view_in_ar_rounded, size: 24),
          ),
          const SizedBox(height: 12),

          // Snapshot Button
          FloatingActionButton.extended(
            onPressed: _takeTourSnapshot,
            icon: const Icon(Icons.photo_camera_rounded, size: 20),
            label: const Text(
              'Capture',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: spotColor,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ],
      ),
    );
  }

  // Navigation Methods
  void _nextSpot() {
    if (_currentTourIndex < _tourSpots.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousSpot() {
    if (_currentTourIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToSpot(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // Action Methods
  void _startARExperience() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.view_in_ar_rounded, color: Colors.indigo),
            SizedBox(width: 8),
            Text('AR Experience'),
          ],
        ),
        content: const Text(
          'Launching augmented reality view for an immersive temple experience. '
              'Point your camera to explore the temple in 3D.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Simulate AR experience start
              _showARLoading();
            },
            child: const Text('Launch AR'),
          ),
        ],
      ),
    );
  }

  void _showARLoading() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Preparing AR Experience...'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _takeTourSnapshot() {
    // Simulate camera shutter effect
    setState(() {
      // Briefly show a flash effect
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.photo_library_rounded, size: 20),
            SizedBox(width: 8),
            Text('Snapshot saved to gallery'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Simulate opening gallery
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Opening photo gallery...'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Separate widget for navigation buttons for better performance
class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _NavigationButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: onPressed != null ? Colors.indigo : Colors.grey,
        ),
      ),
    );
  }
}
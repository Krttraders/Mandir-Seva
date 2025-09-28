import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChrome के लिए आवश्यक

class LiveDarshanScreen extends StatefulWidget {
  const LiveDarshanScreen({super.key});

  @override
  State<LiveDarshanScreen> createState() => _LiveDarshanScreenState();
}

class _LiveDarshanScreenState extends State<LiveDarshanScreen> {
  bool _isPlaying = true;
  bool _isFullscreen = false;
  bool _controlsVisible = true; // Controls की दृश्यता के लिए नया state

  // Timer या Future का उपयोग Controls को छिपाने के लिए किया जाता है
  Future<void>? _hideControlsFuture;

  @override
  void initState() {
    super.initState();
    // Start the control hiding process after 3 seconds on initial load
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    // Exit fullscreen if app is closed in fullscreen mode
    if (_isFullscreen) {
      _setFullscreenMode(false);
    }
    super.dispose();
  }

  // --- Logic Methods ---

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      // Controls को play/pause के बाद भी visible रखें
      _controlsVisible = true;
      _startHideControlsTimer();
    });
  }

  void _setFullscreenMode(bool isFullscreen) {
    setState(() {
      _isFullscreen = isFullscreen;
    });

    if (isFullscreen) {
      // Enter Fullscreen: Hide system bars (status bar and navigation bar)
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
      // Force landscape orientation (optional, but standard for video players)
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Exit Fullscreen: Restore system bars
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      // Restore vertical orientation
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _toggleFullscreen() {
    _setFullscreenMode(!_isFullscreen);

    // Fullscreen में जाने/बाहर आने पर controls को एक बार दिखाएं
    setState(() {
      _controlsVisible = true;
    });
    _startHideControlsTimer();
  }

  void _toggleControlsVisibility() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    // यदि ControlsVisible हो जाते हैं, तो उन्हें 3 सेकंड बाद छिपाना शुरू करें
    if (_controlsVisible) {
      _startHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsFuture?.ignore(); // Cancel previous timer if exists
    _hideControlsFuture = Future.delayed(const Duration(seconds: 3), () {
      if (_controlsVisible) {
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  int _getRandomViewers() {
    // More dynamic random number
    return 100 + (DateTime.now().second * 7 + DateTime.now().minute * 5) % 800;
  }

  // --- Widget Builders ---

  Widget _buildVideoPlayer(BuildContext context) {
    final double aspectRatio = _isFullscreen ? MediaQuery.of(context).size.width / MediaQuery.of(context).size.height : 16 / 9;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: GestureDetector(
        onTap: _toggleControlsVisibility, // Tap to show/hide controls
        child: Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Simulated video feed (Replaced with a more immersive visual)
              Container(
                width: double.infinity,
                height: double.infinity,
                // Using a color derived from the primary theme for better look
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.shade800,
                      Colors.deepOrange.shade400,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.temple_hindu,
                      size: 90,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isPlaying ? 'LIVE DARSHAN' : 'PAUSED',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: _isFullscreen ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(blurRadius: 5, color: Colors.black54)
                          ]
                      ),
                    ),
                  ],
                ),
              ),

              // LIVE NOW Badge (always visible)
              Positioned(
                top: _isFullscreen ? 20 : 10,
                left: _isFullscreen ? 20 : 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 8),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Controls (Visible only when tapped)
              if (_controlsVisible)
                _buildVideoControls(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoControls(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black45, // Semi-transparent overlay for controls
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Center Play/Pause button
            Expanded(
              child: Center(
                child: IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: Colors.white,
                  ),
                  iconSize: 70,
                ),
              ),
            ),

            // Bottom control bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_getRandomViewers()} Viewers',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),

                  Row(
                    children: [
                      // Exit Fullscreen Button (only visible in fullscreen)
                      if (_isFullscreen)
                        IconButton(
                          onPressed: _toggleFullscreen,
                          icon: const Icon(
                            Icons.fullscreen_exit,
                            color: Colors.white,
                          ),
                          tooltip: 'Exit Fullscreen',
                        ),

                      // Enter Fullscreen Button (only visible when not fullscreen)
                      if (!_isFullscreen)
                        IconButton(
                          onPressed: _toggleFullscreen,
                          icon: const Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                          ),
                          tooltip: 'Fullscreen',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sanctum Sanctorum - Live Darshan 🙏',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${_getRandomViewers()} people watching',
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text(
                    '24/7 Live Stream',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Experience the divine presence of Shree Mandir through our uninterrupted live darshan service. '
                'Tune in anytime from anywhere to connect with the main deity and spiritual environment.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Conditionally hide/show AppBar
      appBar: _isFullscreen ? null : AppBar(
        title: const Text('Live Darshan'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      // Use Column/ListView outside fullscreen, use a simple container in fullscreen
      body: _isFullscreen
          ? Center(child: _buildVideoPlayer(context))
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildVideoPlayer(context),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }
}
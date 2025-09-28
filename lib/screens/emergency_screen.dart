import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'dart:async'; // Timer के लिए

// StatelessWidget से StatefulWidget में बदला गया ताकि Long Press state मैनेज हो सके
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  // Mock Data
  String _currentLocation = "GPS is initializing..."; // Start with a loading state
  final List<String> _manualLocations = [
    "Main Prayer Hall (North Side)",
    "Queue Line 4 Near Gate 2",
    "Prasad Counter Area",
    "Basement Parking - Block C",
    "Western Exit Gate",
  ];
  final String _guardPhoneNumber = "+919876543210";
  final String _adminPhoneNumber = "+911234567890";

  // State Variables
  bool _isGpsActive = false;
  // 🔥 MOCK STATE: True if the user's location is inside the 500m radius of the temple.
  bool _isWithinTempleBoundary = false;
  bool _isPressing = false;
  double _longPressProgress = 0.0;
  Timer? _longPressTimer;
  final int _longPressDurationMs = 1500;

  @override
  void initState() {
    super.initState();
    // Simulate GPS activation after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isGpsActive = true;
          // 🔥 MOCKING: Initially, show user is OUTSIDE the 500m boundary.
          _currentLocation = "Live GPS: OUTSIDE 500m radius (Near Market St.)";
          _isWithinTempleBoundary = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  // --- NEW FEATURE: Manual Location Picker Dialog ---
  void _openManualLocationPicker() async {
    final selectedLocation = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Your Exact Spot (Inside Temple)'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _manualLocations.map((location) {
                return ListTile(
                  title: Text(location),
                  onTap: () => Navigator.of(dialogContext).pop(location),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );

    if (selectedLocation != null) {
      setState(() {
        _currentLocation = "Manual: $selectedLocation";
        _isGpsActive = false; // Manually set location means GPS is overridden
        // 🔥 MOCKING: Manual selection means user is inside the temple.
        _isWithinTempleBoundary = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location set manually to: $selectedLocation")),
      );
    }
  }

  // --- Mock Location Refresh (Improved) ---
  void _refreshLocation() {
    if (_isGpsActive) {
      // If GPS is active, simulate a real GPS update
      setState(() {
        // A simple way to show 'live' data without real GPS
        // If the current status is outside, keep it outside on refresh
        if (!_isWithinTempleBoundary) {
          _currentLocation = "Live GPS: OUTSIDE 500m radius (Updated: ${DateTime.now().second}s)";
        } else {
          // If the current status is inside (which would only happen after manual entry in this mock),
          // we assume GPS is still working but we'll stick to the Manual location for the SOS.
          _currentLocation = "Live GPS: Near Gate 3, Coordinates: 26.91°N, 75.79°E (Updated: ${DateTime.now().second}s)";
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Live GPS location refreshed.")),
      );
    } else {
      // If manually set, prompt the user to refresh GPS or select again
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location is manually set. Use 'Select Specific Spot' to change.")),
      );
    }
  }

  // --- SOS Logic (Updated to check 500m boundary) ---
  void _startLongPressTimer() {
    // 🔥 500M CHECK: Check if the user is inside the boundary first.
    if (!_isWithinTempleBoundary) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("🚨 SOS cannot be sent. You must be within the 500m temple boundary or select a specific spot."),
          backgroundColor: Colors.red.shade700,
        ),
      );
      // Stop the process if the check fails
      return;
    }

    // Existing timer logic starts here (only if within boundary)
    _longPressProgress = 0.0;
    _isPressing = true;

    const tick = Duration(milliseconds: 50);
    int totalTicks = _longPressDurationMs ~/ 50;
    int currentTick = 0;

    _longPressTimer = Timer.periodic(tick, (timer) {
      if (!_isPressing) {
        _longPressTimer?.cancel();
        setState(() { _longPressProgress = 0.0; });
        return;
      }

      currentTick++;
      setState(() { _longPressProgress = currentTick / totalTicks; });

      if (currentTick >= totalTicks) {
        _longPressTimer?.cancel();
        _sendSOS();
      }
    });
  }

  void _stopLongPressTimer() {
    _longPressTimer?.cancel();
    if (_longPressProgress < 1.0) {
      setState(() {
        _isPressing = false;
        _longPressProgress = 0.0;
      });
    }
  }

  void _sendSOS() async {
    setState(() {
      _isPressing = false;
      _longPressProgress = 1.0;
    });

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🚨 SOS Sent! Help alerted at: ${_currentLocation}"),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red.shade700,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if(mounted) setState(() => _longPressProgress = 0.0);
    });
  }

  // Direct Call Function (Unchanged)
  void _makeCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    // Using a more reliable launch method like the previous file
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // Launched successfully
      } else {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch calling app. Number is invalid.")),
      );
    }
  }

  // Safety Tip Card (Unchanged)
  Widget _buildSafetyTipCard() {
    return Card(
      color: Colors.yellow.shade100,
      elevation: 2,
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Safety Tip:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 4),
            Text(
              "Stay calm, clearly state your exact location and the nature of the emergency to the responder.",
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double buttonSize = 220;
    final primaryColor = Colors.red.shade600;

    // Determine the GPS status icon and color
    IconData gpsIcon;
    Color gpsColor;

    if (_isWithinTempleBoundary) {
      gpsIcon = Icons.location_on;
      gpsColor = Colors.green.shade700;
    } else {
      gpsIcon = Icons.location_off; // Use 'off' or 'disabled' to clearly show the restriction
      gpsColor = Colors.red.shade700; // Red color for 'outside boundary' state
    }

    // Determine SOS Button Color based on boundary check
    Color sosButtonColor = _isWithinTempleBoundary ? primaryColor : Colors.grey.shade500;

    // Determine the text shown on the SOS button
    String buttonStatusText;
    if (_longPressProgress >= 1.0) {
      buttonStatusText = "SENT";
    } else if (_isWithinTempleBoundary) {
      buttonStatusText = "HOLD FOR ${_longPressDurationMs~/1000}s";
    } else {
      buttonStatusText = "OUTSIDE 500m ZONE"; // New: Status when outside
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Alert"),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location Display Card (Enhanced)
            Card(
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(gpsIcon, color: gpsColor),
                    title: Text(
                      _isWithinTempleBoundary ? "Location Inside 500m Boundary" : "Location OUTSIDE 500m Boundary",
                      style: TextStyle(color: gpsColor, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(_currentLocation, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    trailing: IconButton(
                      icon: Icon(Icons.refresh, color: Colors.blue.shade700),
                      onPressed: _refreshLocation,
                      tooltip: 'Refresh Location',
                    ),
                  ),
                  // New: Manual Location Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _openManualLocationPicker, // Manual Picker
                        icon: const Icon(Icons.list_alt, size: 18),
                        label: const Text("Select Specific Spot Manually"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // SOS Button with Progress Indicator (Updated Logic and UI)
            Center(
              child: GestureDetector(
                onLongPressStart: (_) => _startLongPressTimer(),
                onLongPressEnd: (_) => _stopLongPressTimer(),

                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: CircularProgressIndicator(
                        value: _longPressProgress,
                        strokeWidth: 15.0,
                        backgroundColor: Colors.red.shade100,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          // Color changes based on boundary status
                          _isWithinTempleBoundary
                              ? (_longPressProgress < 1.0 ? Colors.red.shade400 : Colors.green)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: buttonSize - 30,
                      height: buttonSize - 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Color changes based on boundary status
                        color: _isPressing && _isWithinTempleBoundary
                            ? Colors.red.shade900
                            : sosButtonColor,
                        boxShadow: [
                          BoxShadow(
                            color: sosButtonColor.withOpacity(0.5),
                            blurRadius: _isPressing ? 25 : 10,
                            spreadRadius: _isPressing ? 5 : 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              _isWithinTempleBoundary ? Icons.warning_amber_rounded : Icons.lock_outline, // Lock icon when disabled
                              size: 60,
                              color: Colors.white
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "SOS",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            buttonStatusText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Safety Tip Card Feature
            _buildSafetyTipCard(),

            const SizedBox(height: 20),

            const Text(
              "Or call directly:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            // Additional Call Buttons (Unchanged)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makeCall(_guardPhoneNumber),
                    icon: const Icon(Icons.security),
                    label: const Text("Call Guard"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _makeCall(_adminPhoneNumber),
                    icon: const Icon(Icons.person),
                    label: const Text("Call Admin"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      side: BorderSide(color: Colors.blue.shade700),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
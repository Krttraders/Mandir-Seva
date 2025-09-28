import 'package:flutter/material.dart';
import '../services/mock_service.dart'; // मान लिया गया कि इसमें getTempleStats है
import '../services/weather_service.dart';
import '../widgets/crowd_heatmap.dart';
import 'EventsScreen.dart';
import 'ScheduleScreen.dart';
import 'TempleInfoScreen.dart';
import 'LiveDarshanScreen.dart';
import 'DonationScreen.dart';
import 'VirtualTourScreen.dart';

// यह मानें कि आप एक named route का उपयोग करेंगे: '/signin'
// import '../authentication/signin_screen.dart'; // वास्तविक ऐप में इसे इंपोर्ट करें

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _weatherData;
  late Future<Map<String, dynamic>> _templeStats;

  // Realtime Working के लिए Live Darshan का डेटा _templeStats से ही लेंगे
  // ताकि 'getLiveDarshanStatus' वाली त्रुटि न आए।

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _weatherData = WeatherService.getWeatherData();
    // हम मान रहे हैं कि MockService.getTempleStats() में लाइव दर्शक और स्टेटस की जानकारी भी है
    _templeStats = Future.value(Map<String, dynamic>.from(MockService.getTempleStats()));
  }

  Future<void> _refreshData() async {
    setState(() {
      _fetchData();
    });
    // सभी Future के पूरा होने का इंतजार करें
    await Future.wait([_weatherData, _templeStats]);
  }

  void _handleLogout() {
    // यहाँ आप Firebase या अन्य सेवा के लिए वास्तविक Logout Logic जोड़ सकते हैं

    // logout होते ही SignInScreen पर चले जाएं
    // सुनिश्चित करें कि '/signin' route आपके main.dart में परिभाषित है।
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/signin',
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'MandirSeva',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        centerTitle: false,
        actions: [
          _buildAppBarIcon(
            icon: Icons.notifications_outlined,
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            badgeCount: 3,
          ),
          _buildAppBarIcon(
            icon: Icons.dashboard_outlined,
            onPressed: () => Navigator.pushNamed(context, '/operator'),
          ),
          // *** LOGOUT BUTTON ***
          _buildAppBarIcon(
            icon: Icons.logout,
            onPressed: _handleLogout,
            color: Colors.white,
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // Weather Widget
              _buildWeatherWidget(),
              const SizedBox(height: 16),

              // Quick Stats Section
              _buildQuickStats(context),

              const SizedBox(height: 16),

              // Crowd Status Card
              _buildCrowdStatusCard(context),
              const SizedBox(height: 20),

              // *** Live Darshan Preview (अब _templeStats का उपयोग कर रहा है) ***
              _buildLiveDarshanPreview(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LiveDarshanScreen()),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Actions Section
              _buildQuickActionsSection(context),
              const SizedBox(height: 20),

              // Emergency Button
              _buildEmergencyButton(context),
            ],
          ),
        ),
      ),
    );
  }

  //
  // --- Widgets ---
  //

  Widget _buildAppBarIcon({
    required IconData icon,
    required VoidCallback onPressed,
    int badgeCount = 0,
    Color color = Colors.white,
    String? tooltip,
  }) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
          tooltip: tooltip,
        ),
        if (badgeCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Mandir',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
        ),
        const SizedBox(height: 4),
        Text(
          'Plan your visit with real-time updates',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildWeatherWidget() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // डेटा नहीं मिलने पर डिफ़ॉल्ट मान
        final data = snapshot.data ?? {};
        final temperature = data['temperature']?.toString() ?? '--';
        final condition = data['condition'] ?? 'Unknown';
        final feelsLike = data['feelsLike']?.toString() ?? '--';
        final humidity = data['humidity']?.toString() ?? '--';

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // आइकन को कंडीशन के आधार पर बदला जा सकता है
                    Icon(_getWeatherIcon(condition), color: Colors.amber, size: 36),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$temperature°C',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          condition,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Feels like $feelsLike°C',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 1,
                    ),
                    Text(
                      'Humidity $humidity%',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getWeatherIcon(String condition) {
    // सरल लॉजिक (Simple logic)
    if (condition.toLowerCase().contains('sun') || condition.toLowerCase().contains('clear')) {
      return Icons.wb_sunny;
    } else if (condition.toLowerCase().contains('rain')) {
      return Icons.cloudy_snowing;
    } else if (condition.toLowerCase().contains('cloud')) {
      return Icons.cloud;
    }
    return Icons.wb_sunny; // Default
  }

  Widget _buildQuickStats(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _templeStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: List.generate(3, (index) => Expanded(child: _buildStatCardPlaceholder())),
          );
        }

        // Live Darshan के लिए भी यहाँ से डेटा लिया गया है
        final data = snapshot.data ?? {'visitorsToday': 0, 'liveVisitors': 0, 'aartiToday': 0};

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people_alt,
                count: data['visitorsToday']?.toString() ?? '0',
                label: 'Visitors today',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                icon: Icons.person_pin_circle,
                count: data['liveVisitors']?.toString() ?? '0',
                label: 'Live visitors',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatCard(
                icon: Icons.lightbulb_outline,
                count: data['aartiToday']?.toString() ?? '0',
                label: 'Aarti today',
                color: Colors.deepOrange,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardPlaceholder() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 100,
        child: Center(child: CircularProgressIndicator(color: Colors.grey[300])),
      ),
    );
  }

  Widget _buildCrowdStatusCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.people_alt_outlined, color: Colors.blue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Live Crowd Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _refreshData,
                    color: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Crowd Heatmap
              CrowdHeatmap(zoneDensity: MockService.getCrowdDensity()),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/booking'),
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('Book Your Slot', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // *** Live Darshan Preview (अब _templeStats का उपयोग कर रहा है) ***
  Widget _buildLiveDarshanPreview({required VoidCallback onTap}) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _templeStats,
      builder: (context, snapshot) {
        // Fallback or Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(height: 80, child: const Center(child: CircularProgressIndicator())),
          );
        }

        // Data available
        final data = snapshot.data ?? {};
        // MockService.getTempleStats() में लाइव डेटा नहीं होने पर डिफ़ॉल्ट मान
        // आपको अपनी MockService या API से वास्तविक डेटा प्राप्त करने के लिए यह फ़ील्ड जोड़ना होगा
        final String status = data['liveStreamStatus'] ?? 'Sanctum Sanctorum';
        final int viewers = data['liveViewers'] ?? (data['liveVisitors'] ?? 0); // liveVisitors से भी ले सकते हैं
        final bool isLive = data['isLive'] ?? (viewers > 0); // मान लें कि अगर दर्शक हैं तो लाइव है

        final Color liveColor = isLive ? Colors.red : Colors.grey;

        return InkWell(
          onTap: isLive ? onTap : null,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: isLive
                      ? [liveColor.withOpacity(0.1), Colors.white]
                      : [Colors.grey[100]!, Colors.white],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // 1. Icon/Thumbnail Placeholder
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: liveColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.live_tv_outlined, color: liveColor, size: 30),
                    ),
                    const SizedBox(width: 12),

                    // 2. Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // LIVE Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: liveColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  isLive ? 'LIVE' : 'OFFLINE',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Status Text
                              Flexible(
                                child: Text(
                                  status,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Live Darshan Stream',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isLive ? Colors.black87 : Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isLive ? 'Join $viewers people watching' : 'Check back for next Darshan',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // 3. Action Icon
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: isLive ? Colors.red : Colors.grey,
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (isLive)
                                BoxShadow(color: Colors.red.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))
                            ]
                        ),
                        child: Icon(isLive ? Icons.play_arrow : Icons.pause, color: Colors.white, size: 28),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800]),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.schedule_outlined,
                title: "Today's\nSchedule",
                color: Colors.green,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.event_note_outlined,
                title: 'Special\nEvents',
                color: Colors.purple,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.info_outline,
                title: 'Temple\nInfo',
                color: Colors.amber,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TempleInfoScreen())),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.live_tv,
                title: 'Live\nDarshan',
                color: Colors.red,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveDarshanScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.currency_rupee,
                title: 'Online\nDonation',
                color: Colors.teal,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DonationScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.video_camera_back,
                title: 'Virtual\nTour',
                color: Colors.indigo,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VirtualTourScreen())),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, '/emergency'),
        icon: const Icon(Icons.emergency_outlined, size: 24),
        label: const Text('EMERGENCY SOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: Colors.redAccent.withOpacity(0.3),
        ),
      ),
    );
  }
}
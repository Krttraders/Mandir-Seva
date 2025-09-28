import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// --- MAIN ENTRY POINT ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temple Info App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Using ColorScheme for better Material 3 integration
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
        ).copyWith(
          secondary: Colors.orangeAccent,
        ),
        useMaterial3: true,
      ),
      // NOTE: If using this code directly, remember to remove the `home:` property
      // and use routes if you are integrating this screen after a SplashScreen.
      home: const TempleInfoScreen(),
    );
  }
}

// -------------------------------------------------------------------
// 🔥 CORRECTED CODE FOR TEMPLE INFORMATION SCREEN
// -------------------------------------------------------------------

class TempleInfoScreen extends StatefulWidget {
  const TempleInfoScreen({super.key});

  @override
  State<TempleInfoScreen> createState() => _TempleInfoScreenState();
}

class _TempleInfoScreenState extends State<TempleInfoScreen> {
  // --- Temple Data (No changes needed here) ---
  final List<Map<String, dynamic>> temples = const [
    {
      'name': 'Shri Kashi Vishwanath Temple, Varanasi',
      'image': Icons.temple_hindu,
      'history': 'One of the most ancient Shiva temples, original built in 11th century, repeatedly destroyed and rebuilt-the present structure built by Ahilyabai Holkar in 1780.',
      'address': 'Vishwanath Gali, Chowk, Varanasi, UP - 221001',
      'contact': '+91-7080292930',
      'email': 'info@shrikashivishwanath.org',
      'rules': 'No cameras/phones inside, modest attire, shoes outside, no large bags. Queue system, women/men entrance separate in peak times.',
      'facilities': 'Cloakroom, drinking water, wheelchairs, helpdesk, guided tours, shops, clean washrooms.',
      'festivals': {
        'Maha Shivratri': 'Top in India-crowds, all-night Rudra Abhishek, bhajans, longest opening hours, city-wide celebrations.',
        'Ram Navami/Janmashtami/Diwali': 'Small, special aartis in evening, temple decorated, not main event'
      },
      // IMPORTANT: Use the actual Address for the Google Maps URL
      'location': 'Vishwanath Gali, Chowk, Varanasi, UP - 221001',
      'primaryColor': Colors.orange,
    },
    {
      'name': 'Brihadeeswara Temple, Thanjavur',
      'image': Icons.account_balance,
      'history': 'Iconic Chola-era Shiva temple finished ~1010 AD by King Raja Raja Chola I; UNESCO World Heritage.',
      'address': 'Sivaganga Fort, Thanjavur, TN - 613007',
      'contact': '+91-9443313352',
      'email': 'brihadeeswara@tnhrce.in',
      'rules': 'Only traditional clothes, no shoes inside, photography outside allowed, respect monument signs.',
      'facilities': 'Restrooms, drinking water, wheelchairs (on demand), ticket counter, guides, free entry.',
      'festivals': {
        'Maha Shivratri': 'Huge music, dance, night-time poojas, very popular.',
        'Other festivals': 'Minimal for Vaishnav, moderate for Diwali (decor, processions)'
      },
      'location': 'Sivaganga Fort, Thanjavur, TN - 613007',
      'primaryColor': Colors.brown,
    },
    {
      'name': 'Sree Padmanabhaswamy Temple, Thiruvananthapuram',
      'image': Icons.temple_hindu,
      'history': 'Ancient Vishnu (Anantha) temple, records since ~8th century, treasure vaults, Dravidian architecture.',
      'address': 'W Nada, East Fort, Trivandrum, Kerala - 695023',
      'contact': '0471-2464606',
      'email': 'admin@spst.in',
      'rules': 'Strict dress code: dhoti for men, saree/salwar for women, no electronics/bags; bath before entry.',
      'facilities': 'Cloakroom, paid washroom, changing rooms, guides.',
      'festivals': {
        'Janmashtami/Ram Navami': 'Main Vishnu celebrations-huge decor, bhajans, processions.',
        'Diwali/Shivratri': 'Simple decor; minor role'
      },
      'location': 'W Nada, East Fort, Trivandrum, Kerala - 695023',
      'primaryColor': Colors.purple,
    },
    {
      'name': 'Jagannath Temple, Puri',
      'image': Icons.temple_hindu,
      'history': '12th-century Krishna (Jagannath) temple, iconic rath yatra, one of Char Dham.',
      'address': 'Grand Road, Puri, Odisha - 752001',
      'contact': '+91-6752-222002',
      'email': '',
      'rules': 'Only Hindus allowed, no shoes/cameras/mobile, modest clothing, queue required.',
      'facilities': 'Cloakroom, shops, restrooms, wheelchairs (limited), prasad counters.',
      'festivals': {
        'Janmashtami/Ram Navami': 'Enormous - huge bhajans, extra darshans, major crowds.',
        'Diwali': 'Grand lighting, fireworks.',
        'Maha Shivratri': 'Peripheral shrines only, not major event.'
      },
      'location': 'Grand Road, Puri, Odisha - 752001',
      'primaryColor': Colors.red,
    },
    {
      'name': 'Somnath Temple, Gujarat',
      'image': Icons.waves,
      'history': 'Legendary first Jyotirlinga; repeatedly rebuilt, current temple ~1951; seaside location.',
      'address': 'Prabhas Patan, Veraval, Gujarat - 362268',
      'contact': '+91-2876-232001',
      'email': 'somnathtrust@gmail.com',
      'rules': 'No photography, cameras, leather inside; plain clothing; remove shoes.',
      'facilities': 'Ticketing, major cloakroom, canteen, shops, wheelchair access, light & sound show.',
      'festivals': {
        'Maha Shivratri': 'Top-massive overnight pooja, bhajans, laser show.',
        'Other festivals': 'Small to moderate per Vaishnav traditions and local customs.'
      },
      'location': 'Prabhas Patan, Veraval, Gujarat - 362268',
      'primaryColor': Colors.blue,
    },
    {
      'name': 'Sun Temple, Konark',
      'image': Icons.brightness_high,
      'history': 'Built 13th century, UNESCO World Heritage, dedicated to Surya (not for daily worship)',
      'address': 'Konark, Puri, Odisha - 752111',
      'contact': '+91-6758-236821',
      'email': '',
      'rules': 'Ticket required, no ritual worship in sanctum, open to all.',
      'facilities': 'Guides, museum, restrooms, light & sound show, ticketed entry.',
      'festivals': {
        'Diwali': 'Tourist décor, light show only, no ritual festival.',
        'Maha Shivratri/Ram Navami/Janmashtami': 'No major events.'
      },
      'location': 'Konark, Puri, Odisha - 752111',
      'primaryColor': Colors.amber,
    },
    {
      'name': 'Meenakshi Amman Temple, Madurai',
      'image': Icons.account_balance,
      'history': 'Parvati and Shiva temple, dates back 1600s CE, famous for gopurams, bustling rituals',
      'address': 'Madurai Main, TN - 625001',
      'contact': '+91-452-2344360',
      'email': '',
      'rules': 'Traditional dress mandatory; no phones/cams inside sanctum; shoes off.',
      'facilities': 'Restrooms, guides, donation desks, many shops.',
      'festivals': {
        'Maha Shivratri': 'Large crowds, musical events, overnight aarti.',
        'Other festivals': 'Grand diwali illumination, Janmashtami ceremonies but more focused on local legends.'
      },
      'location': 'Madurai Main, TN - 625001',
      'primaryColor': Colors.pink,
    },
    {
      'name': 'Shri Laxmi Narayan Temple (Birla Mandir), Delhi',
      'image': Icons.temple_hindu,
      'history': 'Built by the Birla family (1933–1939), inaugurated by Mahatma Gandhi with the unique rule that all castes are welcome. Dedicated to Vishnu (Narayan) and Lakshmi, with side shrines for Shiva, Krishna, Ganesha, Buddha, and Hanuman. Was Delhi\'s largest temple before Akshardham.',
      'address': 'Mandir Marg, near Gol Market, Connaught Place, New Delhi 110001',
      'contact': '011-23363637',
      'email': '',
      'rules': 'All are welcome, remove shoes, respectful attire, photography allowed only in some areas.',
      'facilities': 'Large gardens, Geeta Bhawan, cloakroom, wheelchair access, clean washrooms, shops, no entry fee.',
      'festivals': {
        'Janmashtami/Diwali': 'Main events- spectacular lights, big crowds, long prayers, bhajans, decorations.',
        'Ram Navami/Shivratri': 'Observed with special poojas and aartis, but less grand than Janmashtami/Diwali.'
      },
      'location': 'Mandir Marg, near Gol Market, Connaught Place, New Delhi 110001',
      'primaryColor': Colors.green,
    },
    {
      'name': 'Tirupati Balaji (Sri Venkateswara Swamy), Tirumala',
      'image': Icons.temple_hindu,
      'history': 'Vishnu temple, global pilgrimage, inscriptions from 9th-century',
      'address': 'Tirumala, AP - 517504',
      'contact': '+91-877-2264258',
      'email': 'contact@tirumala.org',
      'rules': 'No electronics, shoes, bags; strict dress, use official lanes.',
      'facilities': 'Annaprasadam (free meal), many cloakrooms, tickets online, medical care, rooms.',
      'festivals': {
        'Janmashtami/Ram Navami': 'Huge, packed, bhajans, processions, long wait times.',
        'Diwali': 'Big lights, much less crowd than Brahmotsavam.',
        'Maha Shivratri': 'No special observance; temple is Vishnu-centric.'
      },
      'location': 'Tirumala, AP - 517504',
      'primaryColor': Colors.deepPurple,
    },
    {
      'name': 'Vaishno Devi, Katra',
      'image': Icons.terrain,
      'history': 'Ancient Shakti cave, major yatra, goddess\' abode, legends dating to Mahabharata period',
      'address': 'Trikuta Hills, Bhawan, Katra, J&K - 182301',
      'contact': '+91-1991-232887',
      'email': '',
      'rules': 'Compulsory registration at base, bags scanned, suitable clothing for weather, no leather.',
      'facilities': 'Free rest stops, food points, medical on path, lockers, wheelchairs at Bhawan.',
      'festivals': {
        'Navratri': 'Epic-folk music, 24x7 darshan.',
        'Other festivals': 'All marked with special puja, major lighting for Diwali and Janmashtami; Shivratri not main focus.'
      },
      'location': 'Trikuta Hills, Bhawan, Katra, J&K - 182301',
      'primaryColor': Colors.teal,
    },
  ];

  late String _selectedTemple;

  @override
  void initState() {
    super.initState();
    _selectedTemple = temples.first['name'] as String;
  }

  // --- External Link Launcher (Improved for robustness) ---
  void _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      // Use launchUrl directly without canLaunchUrl for reliability with different schemes
      // Use externalApplication mode for a cleaner launch of other apps (like mail/map)
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        // Show a helpful message if the link fails
        String message;
        if (url.startsWith('mailto')) {
          message = 'Email app not found. Please set up a default email client.';
        } else if (url.startsWith('tel')) {
          message = 'Phone dialer not found or call failed.';
        } else {
          message = 'Could not launch link. Please check your device settings.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  // --- Map URL Generator for Directions (CORRECTED) ---
  // This generates a simple, reliable Google Maps URL for directions.
  String _getMapDirectionsUrl(String destinationAddress) {
    // 1. URL-encode the address to handle spaces and special characters.
    final encodedAddress = Uri.encodeComponent(destinationAddress);

    // 2. Use the standard Google Maps URL structure.
    // 'dir' means directions. Omitting 'origin' defaults to the user's current location.
    return 'https://www.google.com/maps/dir/?api=1&destination=$encodedAddress';
    // The previous URL was malformed; this structure is standard and reliable.
  }


  // -------------------------------------------------------------------
  // --- BUILD METHODS (Only minor changes in button onPressed handlers) ---
  // -------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temple Information'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Temple Selection Dropdown ---
            _buildTempleSelector(context),

            // --- Dynamic Content Area ---
            _buildTempleContent(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Dropdown Selector (No changes here) ---
  Widget _buildTempleSelector(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepOrange),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTemple,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrange),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedTemple = newValue;
              });
            }
          },
          items: temples.map<DropdownMenuItem<String>>((temple) {
            return DropdownMenuItem<String>(
              value: temple['name'] as String,
              child: Text(
                temple['name'] as String,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // --- Dynamic Content Builder ---
  Widget _buildTempleContent(BuildContext context) {
    // Find the currently selected temple data
    final temple = temples.firstWhere((t) => t['name'] == _selectedTemple);
    final Color primaryColor = temple['primaryColor'] as Color;

    // **FIXED URL:** Prepare the map URL for directions
    final mapDirectionsUrl = _getMapDirectionsUrl(temple['location'] as String);

    // Prepare the email URL with 'mailto:' prefix
    final emailUrl = 'mailto:${temple['email']}';


    return Column(
      children: [
        // --- Temple Header ---
        Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: primaryColor.withOpacity(0.1),
            border: Border.all(color: primaryColor, width: 2),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      temple['name'] as String,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        shadows: const [
                          Shadow(blurRadius: 4.0, color: Colors.white, offset: Offset(0, 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Floating Action Buttons for quick actions
                    Row(
                      children: [
                        // 1. Call Button
                        FloatingActionButton.small(
                          heroTag: 'callBtn',
                          onPressed: () => _launchUrl(context, 'tel:${temple['contact']}'),
                          backgroundColor: primaryColor,
                          child: const Icon(Icons.call, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 8),
                        // 2. Map Directions Button (Uses the new URL)
                        FloatingActionButton.small(
                          heroTag: 'mapBtn',
                          onPressed: () => _launchUrl(context, mapDirectionsUrl),
                          backgroundColor: primaryColor,
                          child: const Icon(Icons.map, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 8),
                        // 3. Email Button (Uses the new mailto: URL)
                        if (temple['email'] != null && (temple['email'] as String).isNotEmpty)
                          FloatingActionButton.small(
                            heroTag: 'emailBtn',
                            onPressed: () => _launchUrl(context, emailUrl),
                            backgroundColor: primaryColor,
                            child: const Icon(Icons.email, color: Colors.white, size: 18),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Icon(
                  temple['image'] as IconData,
                  size: 48,
                  color: primaryColor.withOpacity(0.5),
                ),
              )
            ],
          ),
        ),

        // --- Temple Details Cards ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildInfoCard(
                icon: Icons.history,
                title: 'History',
                content: temple['history'] as String,
                color: primaryColor,
              ),

              _buildAddressCard(
                context: context,
                icon: Icons.location_on,
                title: 'Address & Contact',
                address: temple['address'] as String,
                phone: temple['contact'] as String,
                email: temple['email'] as String,
                // Pass the new Map Directions URL to the OutlinedButton
                onMapTap: () => _launchUrl(context, mapDirectionsUrl),
                color: primaryColor,
              ),

              _buildInfoCard(
                icon: Icons.gavel,
                title: 'Rules & Guidelines',
                content: temple['rules'] as String,
                color: primaryColor,
              ),

              _buildInfoCard(
                icon: Icons.accessible,
                title: 'Facilities',
                content: temple['facilities'] as String,
                color: primaryColor,
              ),

              // --- Festivals Card ---
              _buildFestivalsCard(
                context: context,
                icon: Icons.festival,
                title: 'Festival Celebrations',
                festivals: temple['festivals'] as Map<String, dynamic>,
                color: primaryColor,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  // --- Standard Info Card Widget (No changes here) ---
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Address Card with Map/Call Action ---
  Widget _buildAddressCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String address,
    required String phone,
    required String email,
    required VoidCallback onMapTap,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Address Text
            Text(
              address,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            const SizedBox(height: 4),
            // Phone Text
            Text(
              'Phone: ${phone.replaceAll('+91', '+91-')}',
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Email: $email',
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ],
            const Divider(height: 24),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onMapTap, // This now calls the Directions function
                    icon: Icon(Icons.directions, color: color),
                    label: Text('Get Directions', style: TextStyle(color: color)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: color),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _launchUrl(context, 'tel:$phone'),
                    icon: Icon(Icons.phone, color: color),
                    label: Text('Call', style: TextStyle(color: color)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: color),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- Festivals Card (No changes here) ---
  Widget _buildFestivalsCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Map<String, dynamic> festivals,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...festivals.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ${entry.key}:',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    entry.value as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
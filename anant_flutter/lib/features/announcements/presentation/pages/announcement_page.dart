import 'package:anant_client/anant_client.dart';
import 'package:flutter/foundation.dart';
import 'package:anant_flutter/common/loading_indicator.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:anant_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Announcement> announcements = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName');
      final role = prefs.getString('role') ?? 'student';
      
      if (userName == null || userName.isEmpty) {
        setState(() {
          _error = 'User not logged in';
          _isLoading = false;
        });
        return;
      }

      // Fetch announcements from server
      final serverAnnouncements = await client.announcement.getAnnouncementsForUser(
        userName,
        role,
      );

      setState(() {
        announcements = serverAnnouncements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load announcements: $e';
        _isLoading = false;
      });
      debugPrint('Error loading announcements: $e');
    }
  }

  Color _getColorForPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
      case 'urgent':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Announcements'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAnnouncements,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : announcements.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.campaign_outlined,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No announcements yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ResponsiveLayout(
                      mobileBody: _buildMobileLayout(),
                      desktopBody: _buildDesktopLayout(),
                    ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: RefreshIndicator(
          onRefresh: _loadAnnouncements,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: announcements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildAnnouncementCard(announcements[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.8,
          ),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            return _buildAnnouncementCard(announcements[index]);
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement item) {
    final color = _getColorForPriority(item.priority);
    final dateStr = DateFormat('MMM dd, yyyy').format(item.createdAt);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  dateStr,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (item.priority.toLowerCase() != 'normal') ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  item.priority.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  item.content,
                  style: const TextStyle(
                    color: Color(0xFF2D3142),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            if (item.targetAudience != 'All') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people_outline, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'For: ${item.targetAudience}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

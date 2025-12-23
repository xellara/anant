import 'package:anant_flutter/config/role_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  bool _maintenanceMode = false;
  bool _allowRegistration = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _autoBackup = true;
  String _academicYear = '2024-2025';
  String _schoolName = 'XYZ International School';
  String _currency = 'INR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('System Settings'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // School Information
          _buildSection(
            'School Information',
            Icons.school,
            Colors.blue,
            [
              _buildTextField('School Name', _schoolName, (value) => _schoolName = value),
              const SizedBox(height: 16),
              _buildDropdown(
                'Academic Year',
                _academicYear,
                ['2024-2025', '2025-2026', '2026-2027'],
                (value) => setState(() => _academicYear = value!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Currency',
                _currency,
                ['INR', 'USD', 'EUR', 'GBP'],
                (value) => setState(() => _currency = value!),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // System Configuration
          _buildSection(
            'System Configuration',
            Icons.settings,
            Colors.orange,
            [
              _buildSwitchTile(
                'Maintenance Mode',
                'System will be unavailable to users',
                _maintenanceMode,
                (value) => setState(() => _maintenanceMode = value),
                Colors.red,
              ),
              _buildSwitchTile(
                'Allow New Registration',
                'Enable new user registration',
                _allowRegistration,
                (value) => setState(() => _allowRegistration = value),
              ),
              _buildSwitchTile(
                'Automatic Backup',
                'Daily backup at 2:00 AM',
                _autoBackup,
                (value) => setState(() => _autoBackup = value),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Notifications
          _buildSection(
            'Notifications',
            Icons.notifications,
            Colors.purple,
            [
              _buildSwitchTile(
                'Email Notifications',
                'Send email alerts to users',
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
              ),
              _buildSwitchTile(
                'SMS Notifications',
                'Send SMS alerts to users',
                _smsNotifications,
                (value) => setState(() => _smsNotifications = value),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Security
          _buildSection(
            'Security',
            Icons.security,
            Colors.green,
            [
              ListTile(
                title: const Text('Password Policy'),
                subtitle: const Text('Minimum 8 characters, 1 uppercase, 1 number'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password policy settings')),
                  );
                },
              ),
              ListTile(
                title: const Text('Session Timeout'),
                subtitle: const Text('30 minutes'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Session timeout settings')),
                  );
                },
              ),
              ListTile(
                title: const Text('Two-Factor Authentication'),
                subtitle: const Text('Configure 2FA settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('2FA settings')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Database & Backup
          _buildSection(
            'Database & Backup',
            Icons.storage,
            Colors.teal,
            [
              ListTile(
                leading: const Icon(Icons.backup, color: Colors.blue),
                title: const Text('Backup Now'),
                subtitle: const Text('Last backup: 2 hours ago'),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Backup started...')),
                    );
                  },
                  child: const Text('Backup'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.restore, color: Colors.orange),
                title: const Text('Restore Data'),
                subtitle: const Text('Restore from previous backup'),
                trailing: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Restore options')),
                    );
                  },
                  child: const Text('Restore'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Save All Changes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Color color, List<Widget> children) {
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
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
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, [Color? activeColor]) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? Theme.of(context).primaryColor,
    );
  }
}

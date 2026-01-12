import 'package:anant_flutter/features/profile_screen.dart';
import 'package:anant_flutter/features/role_dashboards/role_dashboards.dart';
import 'package:flutter/material.dart';

class AnantDashboardScreen extends StatelessWidget {
  const AnantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericRoleDashboard(
      roleName: 'Anant',
      features: [
        DashboardFeature(
          title: 'Organizations',
          subtitle: 'Manage Organizations',
          icon: Icons.business,
          color: Colors.amber.shade700,
          onTap: () {
            // TODO: Navigate to Org Management
          },
        ),
        DashboardFeature(
          title: 'Users',
          subtitle: 'Global User Search',
          icon: Icons.people_outline,
          color: Colors.blueGrey,
          onTap: () {
            // TODO: Navigate to User Management
          },
        ),
        DashboardFeature(
          title: 'System',
          subtitle: 'Settings & Config',
          icon: Icons.settings_applications,
          color: Colors.grey.shade800,
          onTap: () {},
        ),
        DashboardFeature(
          title: 'Import',
          subtitle: 'Bulk CSV Upload',
          icon: Icons.upload_file,
          color: Colors.green.shade700,
          onTap: () {},
        ),
      ],
      navItems: const [
         {'icon': Icons.home_rounded, 'label': 'Home'},
         {'icon': Icons.business, 'label': 'Orgs'},
         {'icon': Icons.people, 'label': 'Users'},
         {'icon': Icons.person_rounded, 'label': 'Profile'},
      ],
      pages: [ 
        const SizedBox(height: 0), // Placeholder for Home
        Center(child: Text("Organizations Page")),
        Center(child: Text("Users Page")),
        const ProfileScreen(),
      ], 
    );
  }
}

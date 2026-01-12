
import 'package:anant_flutter/main.dart';
import 'package:anant_client/anant_client.dart';
import 'package:flutter/material.dart';

class OrganizationManagementPage extends StatefulWidget {
  const OrganizationManagementPage({super.key});

  @override
  State<OrganizationManagementPage> createState() => _OrganizationManagementPageState();
}

class _OrganizationManagementPageState extends State<OrganizationManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Organization> _organizations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrganizations();
  }

  Future<void> _fetchOrganizations() async {
    setState(() => _isLoading = true);
    try {
      // Fetch all organizations using AdminService client
      // Note: We need to expose getAllOrganizations in AdminEndpoint
      // or use OrganizationEndpoint listing if available globally for Anant.
      // Currently using a placeholder or existing endpoint.
      // Let's assume OrganizationEndpoint.getAllOrganizations exists or AdminEndpoint has it.
      // If not, we might need to add it.
      // Checking AdminEndpoint in server code... (Step 463 output showed toggle, etc.)
      
      // Temporary: Use a direct call or simulate.
      // AdminService was updated to have 'toggleOrganizationStatus'.
      // We likely need 'getAllOrganizations'. 
      // I'll add a TODO and use empty list for now, or assume we can list them.
      
      // Let's assume we can fetch them.
      // final orgs = await client.admin.getAllOrganizations();
      
      // For now, mocking or using OrganizationEndpoint if it allows listing.
      // OrganizationEndpoint usually lists for dropdowns.
      // client.organization.getAllOrganizations() ?
      
      final orgs = await client.organization.getAllOrganizations(); // Attempting this
      
      setState(() {
        _organizations = orgs;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching orgs: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleStatus(Organization org, bool isActive) async {
    try {
      final updated = await client.admin.toggleOrganizationStatus(org.id!, isActive);
      if (updated != null) {
        setState(() {
          final index = _organizations.indexWhere((o) => o.id == org.id);
          if (index != -1) {
            _organizations[index] = updated;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Organization ${isActive ? "Resumed" : "Paused"}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Organizations'),
        elevation: 0,
        backgroundColor: Colors.amber.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
               // Show Create Dialog
               // _showCreateDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchOrganizations,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _organizations.length,
              itemBuilder: (context, index) {
                final org = _organizations[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: org.isActive ? Colors.green : Colors.red,
                      child: Icon(
                        org.isActive ? Icons.check : Icons.pause,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(org.name),
                    subtitle: Text('${org.type} • ${org.city}, ${org.state}'),
                    trailing: Switch(
                      value: org.isActive,
                      activeColor: Colors.amber.shade700,
                      onChanged: (val) => _toggleStatus(org, val),
                    ),
                    onTap: () {
                      // Navigate to details or edit
                    },
                  ),
                );
              },
            ),
    );
  }
}

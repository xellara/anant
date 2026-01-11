import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/features/admin/pages/bulk_import_users_page.dart';
import 'package:anant_flutter/common/loading_indicator.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:anant_flutter/main.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  String _selectedRole = 'All';
  final List<String> _roles = ['All', 'Admin', 'Principal', 'Teacher', 'Student', 'Parent', 'Accountant', 'Clerk', 'Librarian', 'Transport', 'Hostel'];
  
  List<User> _allUsers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch all users from server
      final users = await client.user.getAllUsers();
      
      setState(() {
        _allUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load users: $e';
        _isLoading = false;
      });
      debugPrint('Error loading users: $e');
    }
  }

  List<User> get _filteredUsers {
    if (_selectedRole == 'All') return _allUsers;
    return _allUsers.where((u) => u.role.name.toLowerCase() == _selectedRole.toLowerCase()).toList();
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.red;
      case 'Principal':
        return Colors.purple;
      case 'Teacher':
        return Colors.blue;
      case 'Student':
        return Colors.green;
      case 'Parent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New User',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _roles.skip(1).map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User added successfully')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add User'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Manage Users'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.uploadSimple(), color: Colors.white),
            tooltip: 'Bulk Import Users',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const BulkImportUsersPage()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _isLoading ? null : FloatingActionButton.extended(
        onPressed: _showAddUserDialog,
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(PhosphorIcons.plus()),
        label: const Text('Add User'),
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(PhosphorIcons.warningCircle(), size: 80, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_error!, style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ResponsiveLayout(
                  mobileBody: _buildListLayout(isGrid: false),
                  desktopBody: _buildDesktopLayout(),
                  tabletBody: _buildListLayout(isGrid: true),
                ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        _buildStatsAndFilter(isDesktop: true),
        Expanded(
          child: _filteredUsers.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                  ),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(_filteredUsers[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildListLayout({bool isGrid = false}) {
    return Column(
      children: [
        _buildStatsAndFilter(isDesktop: false),
        Expanded(
          child: _filteredUsers.isEmpty
              ? _buildEmptyState()
              : isGrid
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(_filteredUsers[index]);
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        return _buildUserCard(_filteredUsers[index]);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildStatsAndFilter({required bool isDesktop}) {
    return Column(
      children: [
        // Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            children: [
              const Text('Filter by Role:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _roles.map((role) {
                      final isSelected = _selectedRole == role;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(role),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRole = role;
                            });
                          },
                          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Stats Cards
        Container(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard('Total Users', '${_allUsers.length}', PhosphorIcons.users(), Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Filtered', '${_filteredUsers.length}', PhosphorIcons.funnel(), Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard('Roles', '${_roles.length - 1}', PhosphorIcons.identificationBadge(), Colors.orange),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
     return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.users(), size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
  }

  Widget _buildUserCard(User user) {
    final roleColor = _getRoleColor(user.role.name);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: roleColor.withOpacity(0.2),
          child: Text(
            user.fullName?.isNotEmpty == true 
                ? user.fullName![0].toUpperCase()
                : user.anantId?.substring(0, 1).toUpperCase() ?? 'U',
            style: TextStyle(color: roleColor, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.fullName ?? user.anantId ?? 'Unknown User',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Important for Grid items
          children: [
            const SizedBox(height: 4),
            Text(user.anantId ?? 'No ID', maxLines: 1, overflow: TextOverflow.ellipsis),
            if (user.mobileNumber != null) ...[
              const SizedBox(height: 2),
              Text(user.mobileNumber!, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user.role.name,
                    style: TextStyle(fontSize: 12, color: roleColor, fontWeight: FontWeight.bold),
                  ),
                ),
                if (user.className != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      user.className!,
                      style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          onSelected: (value) async {
            if (value == 'delete') {
              await _deleteUser(user);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing ${user.fullName}')),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _deleteUser(User user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && user.id != null) {
      try {
        final success = await client.user.deleteUser(user.id!);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
          _loadUsers(); // Reload the list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete user')),
          );
        }
      } catch (e) {
        debugPrint('Error deleting user: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

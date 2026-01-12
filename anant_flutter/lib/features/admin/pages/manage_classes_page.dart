import 'package:anant_client/anant_client.dart';
import 'package:anant_flutter/common/loading_indicator.dart';
import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/main.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ManageClassesPage extends StatefulWidget {
  const ManageClassesPage({super.key});

  @override
  State<ManageClassesPage> createState() => _ManageClassesPageState();
}

class _ManageClassesPageState extends State<ManageClassesPage> {
  List<Classes> _classes = [];
  List<User> _allUsers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch classes and users from server
      final classes = await client.classes.getAllClasseses();
      final users = await client.user.getAllUsers(limit: 100);
      
      setState(() {
        _classes = classes;
        _allUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load classes: $e';
        _isLoading = false;
      });
      debugPrint('Error loading classes: $e');
    }
  }

  int _getStudentCountForClass(String className) {
    return _allUsers.where((u) => 
      u.className == className && u.role == UserRole.student
    ).length;
  }

  int _getTeacherCountForClass(String className) {
    return _allUsers.where((u) => 
      u.className == className && u.role == UserRole.teacher
    ).length;
  }

  List<String> _getSectionsForClass(String className) {
    final sections = _allUsers
        .where((u) => u.className == className && u.sectionName != null)
        .map((u) => u.sectionName!)
        .toSet()
        .toList();
    sections.sort();
    return sections;
  }

  Future<void> _deleteClass(Classes classData) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Class'),
        content: Text('Are you sure you want to delete ${classData.name}?'),
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

    if (confirm == true && classData.id != null) {
      try {
        final success = await client.classes.deleteClasses(classData.id!);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Class deleted successfully')),
          );
          _loadClasses();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete class')),
          );
        }
      } catch (e) {
        debugPrint('Error deleting class: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showAddClassDialog() {
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
                'Add New Class',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Grade/Class',
                  hintText: 'e.g., 1, 2, 11, 12',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Sections',
                  hintText: 'e.g., A, B, C (comma separated)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
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
                        const SnackBar(content: Text('Class added successfully')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Class'),
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
    int totalStudents = 0;
    int totalTeachers = 0;
    
    if (!_isLoading && _error == null) {
      for (var classData in _classes) {
        totalStudents += _getStudentCountForClass(classData.name);
        totalTeachers += _getTeacherCountForClass(classData.name);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Manage Classes'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),
      floatingActionButton: _isLoading ? null : FloatingActionButton.extended(
        onPressed: _showAddClassDialog,
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(PhosphorIcons.plus()),
        label: const Text('Add Class'),
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
                        onPressed: _loadClasses,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
        children: [
          // Stats Overview
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Classes', '${_classes.length}', PhosphorIcons.chalkboard(), Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Students', '$totalStudents', PhosphorIcons.users(), Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Teachers', '$totalTeachers', PhosphorIcons.chalkboardTeacher(), Colors.orange),
                ),
              ],
            ),
          ),

          // Class List
          Expanded(
            child: _classes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(PhosphorIcons.chalkboard(), size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text('No classes found', style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadClasses,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _classes.length,
                      itemBuilder: (context, index) {
                        final classData = _classes[index];
                        final sections = _getSectionsForClass(classData.name);
                        final students = _getStudentCountForClass(classData.name);
                        final teachers = _getTeacherCountForClass(classData.name);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ExpansionTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  PhosphorIcons.chalkboardTeacher(),
                                  color: Theme.of(context).primaryColor,
                                  size: 28,
                                ),
                              ),
                            ),
                            title: Text(
                              classData.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Text('${sections.length} section(s) • $students students • ${classData.academicYear}'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(PhosphorIcons.users(), size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 8),
                                        Text('$students students enrolled', style: TextStyle(color: Colors.grey[700])),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(PhosphorIcons.chalkboardTeacher(), size: 16, color: Colors.grey[600]),
                                        const SizedBox(width: 8),
                                        Text('$teachers teachers assigned', style: TextStyle(color: Colors.grey[700])),
                                      ],
                                    ),
                                    if (classData.courseName != null) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(PhosphorIcons.book(), size: 16, color: Colors.grey[600]),
                                          const SizedBox(width: 8),
                                          Text('Course: ${classData.courseName}', style: TextStyle(color: Colors.grey[700])),
                                        ],
                                      ),
                                    ],
                                    if (sections.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Sections:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: sections.map((section) {
                                          return Chip(
                                            label: Text('Section $section'),
                                            avatar: CircleAvatar(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              child: Text(
                                                section.substring(0, 1).toUpperCase(),
                                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Edit ${classData.name}')),
                                            );
                                          },
                                          icon: Icon(PhosphorIcons.pencilSimple(), size: 16),
                                          label: const Text('Edit'),
                                        ),
                                        const SizedBox(width: 8),
                                        OutlinedButton.icon(
                                          onPressed: () => _deleteClass(classData),
                                          icon: Icon(PhosphorIcons.trash(), size: 16, color: Colors.red),
                                          label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

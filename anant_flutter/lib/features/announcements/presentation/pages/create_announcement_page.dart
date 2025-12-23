import 'package:anant_flutter/config/role_theme.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CreateAnnouncementPage extends StatefulWidget {
  const CreateAnnouncementPage({super.key});

  @override
  State<CreateAnnouncementPage> createState() => _CreateAnnouncementPageState();
}

class _CreateAnnouncementPageState extends State<CreateAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedPriority = 'Normal';
  String _selectedAudience = 'All';
  bool _allClasses = true;
  final List<String> _selectedClasses = [];

  final List<String> _priorities = ['Low', 'Normal', 'High', 'Urgent'];
  final Map<String, Color> _priorityColors = {
    'Low': Colors.blue,
    'Normal': Colors.green,
    'High': Colors.orange,
    'Urgent': Colors.red,
  };

  final List<String> _audiences = ['All', 'Students', 'Teachers', 'Parents', 'Staff'];
  
  // Mock class data
  final List<String> _availableClasses = [
    'Class 1-A', 'Class 1-B',
    'Class 2-A', 'Class 2-B',
    'Class 3-A', 'Class 3-B',
    'Class 4-A', 'Class 4-B',
    'Class 5-A', 'Class 5-B',
    'Class 6-A', 'Class 6-B',
    'Class 7-A', 'Class 7-B',
    'Class 8-A', 'Class 8-B',
    'Class 9-A', 'Class 9-B',
    'Class 10-A', 'Class 10-B',
    'Class 11-Science', 'Class 11-Commerce',
    'Class 12-Science', 'Class 12-Commerce',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitAnnouncement() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAudience == 'Students' && !_allClasses && _selectedClasses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one class'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Here you would save the announcement to the backend
      String targetInfo = _selectedAudience;
      if (_selectedAudience == 'Students') {
        if (_allClasses) {
          targetInfo += ' (All Classes)';
        } else {
          targetInfo += ' (${_selectedClasses.join(', ')})';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Announcement created for: $targetInfo'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showClassSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Classes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _availableClasses.length,
                        itemBuilder: (context, index) {
                          final className = _availableClasses[index];
                          final isSelected = _selectedClasses.contains(className);
                          return CheckboxListTile(
                            title: Text(className),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                if (value == true) {
                                  _selectedClasses.add(className);
                                } else {
                                  _selectedClasses.remove(className);
                                }
                              });
                              setState(() {});
                            },
                            activeColor: Theme.of(context).primaryColor,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Done'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        title: const Text('Create Announcement'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
      ),

      body: ResponsiveLayout(
        mobileBody: _buildFormContent(isDesktop: false),
        desktopBody: _buildDesktopLayout(),
        tabletBody: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
     return Center(
       child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Panel: Instructions
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.campaign_rounded, size: 64, color: Colors.white),
                      const SizedBox(height: 24),
                      const Text(
                        'Broadcast Your Message',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Reach students, teachers, parents, or staff instantly. Select your audience, set the priority, and publish update to the dashboard.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Tips section
                       Container(
                         padding: const EdgeInsets.all(16),
                         decoration: BoxDecoration(
                           color: Colors.white.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(16),
                         ),
                         child: const Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Icon(Icons.lightbulb_outline, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text('Quick Tips', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                               ],
                             ),
                             SizedBox(height: 12),
                             Text('• Use clear and concise titles.', style: TextStyle(color: Colors.white)),
                             SizedBox(height: 8),
                             Text('• Mark urgent updates as "High" or "Urgent".', style: TextStyle(color: Colors.white)),
                             SizedBox(height: 8),
                             Text('• Double check the target audience.', style: TextStyle(color: Colors.white)),
                           ],
                         ),
                       )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 32),
              // Right Panel: Form
              Expanded(
                flex: 6,
                child: _buildFormContent(isDesktop: true),
              ),
            ],
          ),
       ),
     );
  }

  Widget _buildFormContent({bool isDesktop = false}) {
    return SingleChildScrollView(
        padding: isDesktop ? EdgeInsets.zero : const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) ...[
                 const Text(
                   'Announcement Details',
                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                 ),
                 const SizedBox(height: 32),
              ],
              // Title Field
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter announcement title',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Audience Selector
              const Text(
                'Target Audience',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAudience,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _audiences.map((audience) {
                      IconData icon = Icons.people;
                      switch (audience) {
                        case 'All':
                          icon = Icons.public;
                          break;
                        case 'Students':
                          icon = Icons.school;
                          break;
                        case 'Teachers':
                          icon = Icons.person;
                          break;
                        case 'Parents':
                          icon = Icons.family_restroom;
                          break;
                        case 'Staff':
                          icon = Icons.badge;
                          break;
                      }
                      return DropdownMenuItem(
                        value: audience,
                        child: Row(
                          children: [
                            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 12),
                            Text(audience),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAudience = value!;
                        if (_selectedAudience != 'Students') {
                          _allClasses = true;
                          _selectedClasses.clear();
                        }
                      });
                    },
                  ),
                ),
              ),
              
              // Class Selection (only for Students)
              if (_selectedAudience == 'Students') ...[
                const SizedBox(height: 24),
                const Text(
                  'Class Selection',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<bool>(
                        title: const Text('All Classes'),
                        value: true,
                        groupValue: _allClasses,
                        onChanged: (value) {
                          setState(() {
                            _allClasses = value!;
                            if (_allClasses) {
                              _selectedClasses.clear();
                            }
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      RadioListTile<bool>(
                        title: const Text('Specific Classes'),
                        value: false,
                        groupValue: _allClasses,
                        onChanged: (value) {
                          setState(() {
                            _allClasses = value!;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                
                if (!_allClasses) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showClassSelector,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedClasses.isEmpty
                                  ? 'Select Classes'
                                  : '${_selectedClasses.length} class(es) selected',
                              style: TextStyle(
                                color: _selectedClasses.isEmpty ? Colors.grey[600] : Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                  if (_selectedClasses.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedClasses.map((className) {
                        return Chip(
                          label: Text(className, style: const TextStyle(fontSize: 12)),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedClasses.remove(className);
                            });
                          },
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          deleteIconColor: Theme.of(context).primaryColor,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ],

              const SizedBox(height: 24),

              // Priority Selector
              const Text(
                'Priority',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPriority,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _priorities.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _priorityColors[priority],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(priority),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Content Field
              const Text(
                'Content',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Enter announcement content',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Preview Button
              OutlinedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in title and content to preview'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }
                  _showPreview();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.preview_rounded, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'Preview Announcement',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitAnnouncement,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Publish Announcement',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _showPreview() {
    String targetInfo = _selectedAudience;
    if (_selectedAudience == 'Students') {
      if (_allClasses) {
        targetInfo += ' (All Classes)';
      } else {
        targetInfo += ' (${_selectedClasses.join(', ')})';
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Preview Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.preview_rounded, color: Colors.white),
                      const SizedBox(width: 12),
                      const Text(
                        'Preview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                
                // Preview Content
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Audience Info Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.visibility, size: 14, color: Colors.blue[700]),
                            const SizedBox(width: 6),
                            Text(
                              'Visible to: $targetInfo',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Announcement Card Preview
                      Container(
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
                                        color: _priorityColors[_selectedPriority]!.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _titleController.text,
                                        style: TextStyle(
                                          color: _priorityColors[_selectedPriority],
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
                                    'Just now',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _contentController.text,
                                style: const TextStyle(
                                  color: Color(0xFF2D3142),
                                  fontSize: 15,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Info Note
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This is how your announcement will appear to users',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Preview Actions
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _submitAnnouncement();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Publish Now'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

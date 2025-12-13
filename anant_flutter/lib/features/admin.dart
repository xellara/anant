// import 'package:anant_client/anant_client.dart';
// import 'package:anant_flutter/main.dart';
// import 'package:flutter/material.dart';

// // ---------------------------
// // The Main Admin Home UI
// // ---------------------------
// class AdminHomePage extends StatefulWidget {
//   const AdminHomePage({super.key});

//   @override
//   State<AdminHomePage> createState() => _AdminHomePageState();
// }

// class _AdminHomePageState extends State<AdminHomePage> {
//   int _selectedIndex = 0;

//   // The bottom nav screens:
//   late final List<Widget> _pages = [
//     const OrganizationListPage(),
//     const PickOrganizationForClassesPage(),
//     const PickOrganizationForSectionsPage(),
//     const PickOrganizationForCoursesPage(),
//     const PickOrganizationForUsersPage(),
//     const AttendanceListPage(), // Attendance management page
//   ];

//   void _onItemTapped(int index) {
//     setState(() => _selectedIndex = index);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Panel')),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.apartment), label: 'Orgs'),
//           BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Classes'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sections'),
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
//           BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Attendance'),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================================
// // 1) ORGANIZATION CRUD
// // ============================================================================
// class OrganizationListPage extends StatefulWidget {
//   const OrganizationListPage({super.key});

//   @override
//   State<OrganizationListPage> createState() => _OrganizationListPageState();
// }

// class _OrganizationListPageState extends State<OrganizationListPage> {
//   late Future<List<Organization>> _futureOrgs;

//   @override
//   void initState() {
//     super.initState();
//     _reloadOrgs();
//   }

//   void _reloadOrgs() {
//     _futureOrgs = client.organization.getAllOrganizations();
//   }

//   Future<void> _deleteOrg(int orgId) async {
//     await client.organization.deleteOrganization(orgId);
//     setState(() => _reloadOrgs());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<Organization>>(
//         future: _futureOrgs,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final orgs = snapshot.data!;
//           if (orgs.isEmpty) return const Center(child: Text('No Organizations found.'));
//           return ListView.builder(
//             itemCount: orgs.length,
//             itemBuilder: (context, index) {
//               final org = orgs[index];
//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(org.name),
//                   subtitle: Text(org.type ?? ''),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteOrg(org.id!),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const OrganizationFormPage()),
//           );
//           setState(() => _reloadOrgs());
//         },
//       ),
//     );
//   }
// }

// class OrganizationFormPage extends StatefulWidget {
//   const OrganizationFormPage({Key? key}) : super(key: key);

//   @override
//   State<OrganizationFormPage> createState() => _OrganizationFormPageState();
// }

// class _OrganizationFormPageState extends State<OrganizationFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _typeCtrl = TextEditingController();

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     final org = Organization(
//       name: _nameCtrl.text,
//       type: _typeCtrl.text,
//       createdAt: DateTime.now(), 
//       organizationName: 'ExampleOrg',
//     );
//     await client.organization.createOrganization(org);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Organization')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(children: [
//             TextFormField(
//               controller: _nameCtrl,
//               decoration: const InputDecoration(labelText: 'Organization Name'),
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _typeCtrl,
//               decoration: const InputDecoration(labelText: 'Type (School/College)'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _submit, child: const Text('Save')),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // 2) CLASS CRUD
// // ============================================================================
// class PickOrganizationForClassesPage extends StatelessWidget {
//   const PickOrganizationForClassesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _OrganizationPicker(
//       title: 'Select Org for Classes',
//       onOrgSelected: (org) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => ClassListPage(organizationId: org.id!)),
//         );
//       },
//     );
//   }
// }

// class ClassListPage extends StatefulWidget {
//   final int organizationId;
//   const ClassListPage({Key? key, required this.organizationId}) : super(key: key);

//   @override
//   State<ClassListPage> createState() => _ClassListPageState();
// }

// class _ClassListPageState extends State<ClassListPage> {
//   late Future<List<Classes>> _futureClasses;

//   @override
//   void initState() {
//     super.initState();
//     _reloadClasses();
//   }

//   void _reloadClasses() {
//     _futureClasses = client.classes.getClasses(widget.organizationId).then((value) => value != null ? [value] : []);
//   }

//   Future<void> _deleteClass(int classId) async {
//     await client.classes.deleteClasses(classId);
//     setState(() => _reloadClasses());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Classes (Org ID: ${widget.organizationId})')),
//       body: FutureBuilder<List<Classes>>(
//         future: _futureClasses,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final classes = snapshot.data!;
//           if (classes.isEmpty) return const Center(child: Text('No Classes yet.'));
//           return ListView.builder(
//             itemCount: classes.length,
//             itemBuilder: (context, index) {
//               final c = classes[index];
//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(c.name),
//                   subtitle: Text(c.academicYear),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteClass(c.id!),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => ClassFormPage(organizationId: widget.organizationId)),
//           );
//           setState(() => _reloadClasses());
//         },
//       ),
//     );
//   }
// }

// class ClassFormPage extends StatefulWidget {
//   final int organizationId;
//   const ClassFormPage({Key? key, required this.organizationId}) : super(key: key);

//   @override
//   State<ClassFormPage> createState() => _ClassFormPageState();
// }

// class _ClassFormPageState extends State<ClassFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _yearCtrl = TextEditingController();

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     final newClass = Classes(
//       organizationId: widget.organizationId,
//       name: _nameCtrl.text,
//       academicYear: _yearCtrl.text,
//       isActive: true,
//     );
//     await client.classes.createClasses(newClass);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Class')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(children: [
//             Text('Org ID: ${widget.organizationId}'),
//             TextFormField(
//               controller: _nameCtrl,
//               decoration: const InputDecoration(labelText: 'Class Name'),
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _yearCtrl,
//               decoration: const InputDecoration(labelText: 'Academic Year'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _submit, child: const Text('Save')),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // 3) SECTION CRUD
// // ============================================================================
// class PickOrganizationForSectionsPage extends StatelessWidget {
//   const PickOrganizationForSectionsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _OrganizationPicker(
//       title: 'Select Org for Sections',
//       onOrgSelected: (org) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => SectionOrgSelectedPage(organizationId: org.id!)),
//         );
//       },
//     );
//   }

// }

// class SectionOrgSelectedPage extends StatelessWidget {
//   final int organizationId;
//   const SectionOrgSelectedPage({Key? key, required this.organizationId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _ClassPicker(
//       organizationId: organizationId,
//       onClassSelected: (cls) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => SectionListPage(
//               organizationId: organizationId,
//               className: (cls as Classes).name,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ClassPicker extends StatefulWidget {
//   final int organizationId;
//   final void Function(Classes) onClassSelected;
//   const _ClassPicker({required this.organizationId, required this.onClassSelected});

//   @override
//   State<_ClassPicker> createState() => _ClassPickerState();
// }

// class _ClassPickerState extends State<_ClassPicker> {
//   late Future<List<Classes>> _futureClasses;

//   @override
//   void initState() {
//     super.initState();
//     _futureClasses = client.classes.getClasses(widget.organizationId).then((value) => value != null ? [value] : []);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Pick Class (Org ID: ${widget.organizationId})')),
//       body: FutureBuilder<List<Classes>>(
//         future: _futureClasses,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final classes = snapshot.data!;
//           if (classes.isEmpty) return const Center(child: Text('No classes.'));
//           return ListView.builder(
//             itemCount: classes.length,
//             itemBuilder: (context, index) {
//               final c = classes[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(c.name),
//                   subtitle: Text(c.academicYear),
//                   onTap: () => widget.onClassSelected(c),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class SectionListPage extends StatefulWidget {
//   final int organizationId;
//   final String className;
//   const SectionListPage({Key? key, required this.organizationId, required this.className}) : super(key: key);

//   @override
//   State<SectionListPage> createState() => _SectionListPageState();
// }

// class _SectionListPageState extends State<SectionListPage> {
//   late Future<List<Section>> _futureSections;

//   @override
//   void initState() {
//     super.initState();
//     _reloadSections();
//   }

//   void _reloadSections() {
//     _futureSections = client.section.getSection(widget.organizationId).then((section) => section != null ? [section] : []);
//   }

//   Future<void> _deleteSection(int sectionId) async {
//     await client.section.deleteSection(sectionId);
//     setState(() => _reloadSections());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sections (Org ${widget.organizationId}, Class: ${widget.className})')),
//       body: FutureBuilder<List<Section>>(
//         future: _futureSections,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final sections = snapshot.data!;
//           if (sections.isEmpty) return const Center(child: Text('No Sections.'));
//           return ListView.builder(
//             itemCount: sections.length,
//             itemBuilder: (context, index) {
//               final sec = sections[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(sec.name),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteSection(sec.id!),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => SectionFormPage(organizationId: widget.organizationId, className: widget.className)),
//           );
//           setState(() => _reloadSections());
//         },
//       ),
//     );
//   }
// }

// class SectionFormPage extends StatefulWidget {
//   final int organizationId;
//   final String className;
//   const SectionFormPage({Key? key, required this.organizationId, required this.className}) : super(key: key);

//   @override
//   State<SectionFormPage> createState() => _SectionFormPageState();
// }

// class _SectionFormPageState extends State<SectionFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _sectionNameCtrl = TextEditingController();

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     final sec = Section(
//       organizationId: widget.organizationId,
//       className: widget.className,
//       name: _sectionNameCtrl.text,
//       isActive: true,
//     );
//     await client.section.createSection(sec);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add Section to ${widget.className}')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(children: [
//             Text('Org ID: ${widget.organizationId}, Class: ${widget.className}'),
//             TextFormField(
//               controller: _sectionNameCtrl,
//               decoration: const InputDecoration(labelText: 'Section Name'),
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _submit, child: const Text('Save')),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // 4) COURSE CRUD
// // ============================================================================
// class PickOrganizationForCoursesPage extends StatelessWidget {
//   const PickOrganizationForCoursesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _OrganizationPicker(
//       title: 'Select Org for Courses',
//       onOrgSelected: (org) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => CourseListPage(organizationId: org.id!)),
//         );
//       },
//     );
//   }
// }

// class CourseListPage extends StatefulWidget {
//   final int organizationId;
//   const CourseListPage({Key? key, required this.organizationId}) : super(key: key);

//   @override
//   State<CourseListPage> createState() => _CourseListPageState();
// }

// class _CourseListPageState extends State<CourseListPage> {
//   late Future<List<Course>> _futureCourses;

//   @override
//   void initState() {
//     super.initState();
//     _reloadCourses();
//   }

//   void _reloadCourses() {
//     _futureCourses = client.course.getCourse(widget.organizationId).then((course) => course != null ? [course] : []);
//   }

//   Future<void> _deleteCourse(int courseId) async {
//     await client.course.deleteCourse(courseId);
//     setState(() => _reloadCourses());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Courses (Org: ${widget.organizationId})')),
//       body: FutureBuilder<List<Course>>(
//         future: _futureCourses,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final courses = snapshot.data!;
//           if (courses.isEmpty) return const Center(child: Text('No Courses.'));
//           return ListView.builder(
//             itemCount: courses.length,
//             itemBuilder: (context, index) {
//               final crs = courses[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(crs.name),
//                   subtitle: Text(crs.code ?? ''),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteCourse(crs.id!),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => CourseFormPage(organizationId: widget.organizationId)),
//           );
//           setState(() => _reloadCourses());
//         },
//       ),
//     );
//   }
// }

// class CourseFormPage extends StatefulWidget {
//   final int organizationId;
//   const CourseFormPage({Key? key, required this.organizationId}) : super(key: key);

//   @override
//   State<CourseFormPage> createState() => _CourseFormPageState();
// }

// class _CourseFormPageState extends State<CourseFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _codeCtrl = TextEditingController();

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     final crs = Course(
//       organizationId: widget.organizationId,
//       name: _nameCtrl.text,
//       code: _codeCtrl.text,
//       isActive: true,
//     );
//     await client.course.createCourse(crs);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Course')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(children: [
//             Text('Org ID: ${widget.organizationId}'),
//             TextFormField(
//               controller: _nameCtrl,
//               decoration: const InputDecoration(labelText: 'Course Name'),
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _codeCtrl,
//               decoration: const InputDecoration(labelText: 'Course Code'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _submit, child: const Text('Save')),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // 5) USER CRUD
// // ============================================================================
// class PickOrganizationForUsersPage extends StatelessWidget {
//   const PickOrganizationForUsersPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return _OrganizationPicker(
//       title: 'Select Org for Users',
//       onOrgSelected: (org) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => UserListPage(orgId: org.id!, orgName: org.name)),
//         );
//       },
//     );
//   }
// }

// class UserListPage extends StatefulWidget {
//   final int orgId;
//   final String orgName;
//   const UserListPage({Key? key, required this.orgId, required this.orgName}) : super(key: key);

//   @override
//   State<UserListPage> createState() => _UserListPageState();
// }

// class _UserListPageState extends State<UserListPage> {
//   late Future<List<User>> _futureUsers;

//   @override
//   void initState() {
//     super.initState();
//     _reloadUsers();
//   }

//   void _reloadUsers() {
//     _futureUsers = client.user.me(widget.orgId).then((user) => user != null ? [user] : []);
//   }

//   Future<void> _deleteUser(int userId) async {
//     await client.user.deleteUser(userId);
//     setState(() => _reloadUsers());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Users in ${widget.orgName} (ID=${widget.orgId})')),
//       body: FutureBuilder<List<User>>(
//         future: _futureUsers,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final users = snapshot.data!;
//           if (users.isEmpty) return const Center(child: Text('No Users.'));
//           return ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               final u = users[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(u.fullName ?? 'Unknown'),
//                   subtitle: Text('Role=${u.role}, Class=${u.className}, Sec=${u.sectionName}'),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteUser(u.id!),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => UserFormPage(orgId: widget.orgId, orgName: widget.orgName)),
//           );
//           setState(() => _reloadUsers());
//         },
//       ),
//     );
//   }
// }

// class UserFormPage extends StatefulWidget {
//   final int orgId;
//   final String orgName;
//   const UserFormPage({Key? key, required this.orgId, required this.orgName}) : super(key: key);

//   @override
//   State<UserFormPage> createState() => _UserFormPageState();
// }

// class _UserFormPageState extends State<UserFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullNameCtrl = TextEditingController();
//   final _classNameCtrl = TextEditingController();
//   final _sectionNameCtrl = TextEditingController();
//   final _admissionCtrl = TextEditingController();

//   UserRole _role = UserRole.student;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add User to ${widget.orgName}')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(children: [
//             Text('Org ID=${widget.orgId}, Org Name=${widget.orgName}'),
//             TextFormField(
//               controller: _fullNameCtrl,
//               decoration: const InputDecoration(labelText: 'Full Name'),
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             DropdownButtonFormField<UserRole>(
//               value: _role,
//               decoration: const InputDecoration(labelText: 'Role'),
//               items: UserRole.values.map((r) {
//                 return DropdownMenuItem(value: r, child: Text(r.name));
//               }).toList(),
//               onChanged: (val) {
//                 if (val != null) setState(() => _role = val);
//               },
//             ),
//             TextFormField(
//               controller: _classNameCtrl,
//               decoration: const InputDecoration(labelText: 'Class Name'),
//             ),
//             TextFormField(
//               controller: _sectionNameCtrl,
//               decoration: const InputDecoration(labelText: 'Section Name'),
//             ),
//             TextFormField(
//               controller: _admissionCtrl,
//               decoration: const InputDecoration(labelText: 'Admission Number'),
//               validator: (v) => v!.isEmpty ? 'Required' : null,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: (){}, child: const Text('Save')),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // 6) ATTENDANCE CRUD
// // ============================================================================
// class AttendanceListPage extends StatefulWidget {
//   const AttendanceListPage({Key? key}) : super(key: key);

//   @override
//   State<AttendanceListPage> createState() => _AttendanceListPageState();
// }

// class _AttendanceListPageState extends State<AttendanceListPage> {
//   late Future<List<Attendance>> _futureAttendances;

//   @override
//   void initState() {
//     super.initState();
//     _reloadAttendances();
//   }

//   void _reloadAttendances() {
//     _futureAttendances = client.attendance.getAllAttendances();
//   }

//   Future<void> _deleteAttendance(int attendanceId) async {
//     // await client.attendance.deleteAttendance(attendanceId);
//     setState(() => _reloadAttendances());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Attendance Records')),
//       body: FutureBuilder<List<Attendance>>(
//         future: _futureAttendances,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final attendances = snapshot.data!;
//           if (attendances.isEmpty) return const Center(child: Text('No Attendance records found.'));
//           return ListView.builder(
//             itemCount: attendances.length,
//             itemBuilder: (context, index) {
//               final att = attendances[index];
//               return Card(
//                 margin: const EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text('${att.className} - ${att.sectionName}'),
//                   subtitle: Text('Student: ${att.studentAnantId} | Status: ${att.status}'),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteAttendance(att.id!),
//                   ),
//                   onTap: () {
//                     // Optionally add navigation to update/view details
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AttendanceFormPage()),
//           );
//           setState(() => _reloadAttendances());
//         },
//       ),
//     );
//   }
// }

// class AttendanceFormPage extends StatefulWidget {
//   const AttendanceFormPage({Key? key}) : super(key: key);

//   @override
//   State<AttendanceFormPage> createState() => _AttendanceFormPageState();
// }

// class _AttendanceFormPageState extends State<AttendanceFormPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _organizationIdCtrl = TextEditingController();
//   final _classNameCtrl = TextEditingController();
//   final _sectionNameCtrl = TextEditingController();
//   final _subjectNameCtrl = TextEditingController();
//   final _studentAnantIdCtrl = TextEditingController();
//   final _startTimeCtrl = TextEditingController();
//   final _endTimeCtrl = TextEditingController();
//   final _dateCtrl = TextEditingController();
//   final _markedByAnantIdCtrl = TextEditingController();
//   final _remarksCtrl = TextEditingController();
//   String _status = 'Present';

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     final attendance = Attendance(
//       organizationName: _organizationIdCtrl.text,
//       className: _classNameCtrl.text,
//       sectionName: _sectionNameCtrl.text,
//       subjectName: _subjectNameCtrl.text.isNotEmpty ? _subjectNameCtrl.text : null,
//       studentAnantId: _studentAnantIdCtrl.text,
//       startTime: _startTimeCtrl.text,
//       endTime: _endTimeCtrl.text,
//       date: DateTime.tryParse(_dateCtrl.text) ?? DateTime.now(),
//       markedByAnantId: _markedByAnantIdCtrl.text,
//       status: _status,
//       remarks: _remarksCtrl.text.isNotEmpty ? _remarksCtrl.text : null,
//     );
//     await client.attendance.createAttendance(attendance);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Mark Attendance')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(children: [
//             TextFormField(
//               controller: _organizationIdCtrl,
//               decoration: const InputDecoration(labelText: 'Organization ID'),
//               keyboardType: TextInputType.number,
//               validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _classNameCtrl,
//               decoration: const InputDecoration(labelText: 'Class Name'),
//               validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _sectionNameCtrl,
//               decoration: const InputDecoration(labelText: 'Section Name'),
//               validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _subjectNameCtrl,
//               decoration: const InputDecoration(labelText: 'Subject Name (Optional)'),
//             ),
//             TextFormField(
//               controller: _studentAnantIdCtrl,
//               decoration: const InputDecoration(labelText: 'Student Anant ID'),
//               validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _startTimeCtrl,
//               decoration: const InputDecoration(labelText: 'Start Time (ISO 8601)'),
//             ),
//             TextFormField(
//               controller: _endTimeCtrl,
//               decoration: const InputDecoration(labelText: 'End Time (ISO 8601)'),
//             ),
//             TextFormField(
//               controller: _dateCtrl,
//               decoration: const InputDecoration(labelText: 'Date (ISO 8601)'),
//               validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _markedByAnantIdCtrl,
//               decoration: const InputDecoration(labelText: 'Marked By Anant ID'),
//               validator: (v) => v == null || v.isEmpty ? 'Required' : null,
//             ),
//             DropdownButtonFormField<String>(
//               value: _status,
//               decoration: const InputDecoration(labelText: 'Status'),
//               items: ['Present', 'Absent', 'Late', 'Excused'].map((status) {
//                 return DropdownMenuItem(value: status, child: Text(status));
//               }).toList(),
//               onChanged: (value) {
//                 if (value != null) setState(() => _status = value);
//               },
//             ),
//             TextFormField(
//               controller: _remarksCtrl,
//               decoration: const InputDecoration(labelText: 'Remarks (Optional)'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(onPressed: _submit, child: const Text('Save Attendance')),
//           ]),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // HELPER: ORGANIZATION PICKER (used by multiple pages)
// // ============================================================================
// class _OrganizationPicker extends StatefulWidget {
//   final String title;
//   final void Function(Organization) onOrgSelected;
//   const _OrganizationPicker({required this.title, required this.onOrgSelected});

//   @override
//   State<_OrganizationPicker> createState() => _OrganizationPickerState();
// }

// class _OrganizationPickerState extends State<_OrganizationPicker> {
//   late Future<List<Organization>> _futureOrgs;

//   @override
//   void initState() {
//     super.initState();
//     _futureOrgs = client.organization.getAllOrganizations();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: FutureBuilder<List<Organization>>(
//         future: _futureOrgs,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//           final orgs = snapshot.data!;
//           if (orgs.isEmpty) return const Center(child: Text('No orgs found.'));
//           return ListView.builder(
//             itemCount: orgs.length,
//             itemBuilder: (context, index) {
//               final org = orgs[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(org.name),
//                   subtitle: Text(org.type ?? ''),
//                   onTap: () => widget.onOrgSelected(org),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

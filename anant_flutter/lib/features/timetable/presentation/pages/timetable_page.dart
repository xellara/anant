import 'package:anant_flutter/common/widgets/circular_back_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:anant_flutter/common/widgets/responsive_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:anant_flutter/config/role_theme.dart';
import '../../domain/entities/timetable_entry.dart';
import '../../data/repositories/timetable_repository_impl.dart';
import '../../domain/usecases/get_timetable.dart';
import '../bloc/timetable_bloc.dart';
import '../bloc/timetable_event.dart';
import '../bloc/timetable_state.dart';

class TimetablePage extends StatelessWidget {
  final String? role;

  const TimetablePage({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimetableBloc(
        getTimetable: GetTimetable(TimetableRepositoryImpl()),
      )..add(LoadTimetable(role: role)),
      child: const TimetableView(),
    );
  }
}

class TimetableView extends StatefulWidget {
  const TimetableView({super.key});

  @override
  State<TimetableView> createState() => _TimetableViewState();
}

class _TimetableViewState extends State<TimetableView> {
  bool showTableView = false;

  final List<String> _days = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  String get _today {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    return _days.contains(dayName) ? dayName : 'Monday';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CircularBackButton(),
        title: const Text('Timetable'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.primaryGradient,
          ),
        ),
        actions: [
          if (!ResponsiveLayout.isDesktop(context))
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(showTableView ? PhosphorIcons.squaresFour(PhosphorIconsStyle.fill) : PhosphorIcons.table(PhosphorIconsStyle.fill)),
                tooltip: showTableView ? 'Show Today\'s Classes' : 'Show Full Timetable',
                onPressed: () {
                  setState(() {
                    showTableView = !showTableView;
                  });
                },
              ),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: BlocBuilder<TimetableBloc, TimetableState>(
            builder: (context, state) {
              if (state is TimetableLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TimetableError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is TimetableLoaded) {
                return SafeArea(
                  child: ResponsiveLayout(
                    mobileBody: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showTableView
                          ? _buildTableView(state.timetable)
                          : _buildTodayList(state.timetable),
                    ),
                    desktopBody: _buildTableView(state.timetable),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTodayList(List<TimetableSlot> timetable) {
    final today = _today;
    final todaySlots = timetable.where((slot) => slot.weekSchedule.containsKey(today)).toList();

    if (todaySlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.calendarX(), size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              'No classes for $today',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: todaySlots.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 8),
            child: Text(
              'Today\'s Schedule ($today)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        }

        final slot = todaySlots[index - 1];
        final session = slot.weekSchedule[today]!;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: Theme.of(context).extension<AppGradients>()?.cardGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      PhosphorIcons.chalkboardTeacher(PhosphorIconsStyle.fill),
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.subject,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (slot.showTeacher)
                          Row(
                            children: [
                              Icon(PhosphorIcons.user(), size: 16, color: Colors.grey[500]),
                              const SizedBox(width: 6),
                              Text(
                                session.faculty,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(PhosphorIcons.clock(), size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 6),
                            Text(
                              '${slot.startTime} - ${slot.endTime}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableView(List<TimetableSlot> timetable) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Table(
              defaultColumnWidth: const FixedColumnWidth(140),
              border: TableBorder(
                horizontalInside: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                verticalInside: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  children: [
                    _buildTableHeader('Time'),
                    ..._days.map((day) => _buildTableHeader(day)),
                  ],
                ),
                // Rows
                ...timetable.map((slot) {
                  return TableRow(
                    decoration: BoxDecoration(
                      color: timetable.indexOf(slot).isEven 
                          ? Colors.white 
                          : const Color(0xFFF9FAFB),
                    ),
                    children: [
                      _buildTableCell('${slot.startTime}\n-\n${slot.endTime}', isTime: true),
                      ..._days.map((day) {
                        final session = slot.weekSchedule[day];
                        if (session == null) return _buildTableCell('');
                        return _buildTableCell(
                          slot.showTeacher ? '${session.subject}\n(${session.faculty})' : session.subject,
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isTime = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isTime ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            color: isTime ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}

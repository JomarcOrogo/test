import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/riasec_models.dart';
import '../../widgets/counselor_sidebar.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  // Sample in-progress assessments (students currently taking the assessment)
  final List<Map<String, dynamic>> _inProgressAssessments = [
    {
      'studentId': 'student001',
      'studentName': 'John Doe',
      'studentNumber': '2024-001',
      'startedAt': DateTime.now().subtract(const Duration(minutes: 15)),
      'currentQuestion': 8,
      'totalQuestions': 30,
      'progress': 0.27,
    },
    {
      'studentId': 'student002',
      'studentName': 'Jane Smith',
      'studentNumber': '2024-002',
      'startedAt': DateTime.now().subtract(const Duration(minutes: 5)),
      'currentQuestion': 3,
      'totalQuestions': 30,
      'progress': 0.10,
    },
    {
      'studentId': 'student003',
      'studentName': 'Bob Johnson',
      'studentNumber': '2024-003',
      'startedAt': DateTime.now().subtract(const Duration(minutes: 25)),
      'currentQuestion': 12,
      'totalQuestions': 30,
      'progress': 0.40,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: CounselorSidebar(currentRoute: '/guidance-counselor/monitoring'),
      appBar: AppBar(
        title: const Text('Live Assessment Monitoring'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          // Live View Indicator
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryGreen, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Return to Main Menu',
            onPressed: () => context.go('/guidance-counselor/dashboard'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Notification Banner
          if (_inProgressAssessments.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: AppTheme.primaryBlue.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_inProgressAssessments.length} student(s) currently taking the assessment',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Statistics Summary
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppTheme.backgroundLight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('In Progress', '${_inProgressAssessments.length}', AppTheme.primaryBlue),
                _buildStatItem('Completed Today', '8', AppTheme.primaryGreen),
                _buildStatItem('Avg. Time', '25 min', AppTheme.primaryOrange),
              ],
            ),
          ),

          // In-Progress Assessments List
          Expanded(
            child: _inProgressAssessments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assessment_outlined,
                          size: 64,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Active Assessments',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Students currently taking the assessment will appear here',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _inProgressAssessments.length,
                    itemBuilder: (context, index) {
                      final assessment = _inProgressAssessments[index];
                      final timeElapsed = DateTime.now().difference(assessment['startedAt'] as DateTime);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                                        child: Icon(
                                          Icons.person,
                                          color: AppTheme.primaryBlue,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            assessment['studentName'] as String,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'ID: ${assessment['studentNumber']}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Chip(
                                    label: const Text(
                                      'IN PROGRESS',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                                    labelStyle: TextStyle(
                                      color: AppTheme.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Progress Bar
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Progress',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        '${assessment['currentQuestion']}/${assessment['totalQuestions']} questions',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: assessment['progress'] as double,
                                    backgroundColor: AppTheme.dividerColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                                    minHeight: 8,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: AppTheme.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Started ${_formatDuration(timeElapsed)} ago',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      return '${duration.inSeconds} seconds';
    } else if (duration.inHours < 1) {
      return '${duration.inMinutes} minutes';
    } else {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    }
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

}

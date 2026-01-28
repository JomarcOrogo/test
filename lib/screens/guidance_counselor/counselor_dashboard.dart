import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/counselor_sidebar.dart';

class CounselorDashboard extends StatefulWidget {
  const CounselorDashboard({super.key});

  @override
  State<CounselorDashboard> createState() => _CounselorDashboardState();
}

class _CounselorDashboardState extends State<CounselorDashboard> {
  String _timeFilter = 'today'; // 'today', 'week', 'month', 'all'

  void _showRecentActivityMenu(BuildContext context) {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button!.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'approved',
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 20, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Approved 3 Course Recommendations', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('2 minutes ago', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pending',
          child: Row(
            children: [
              Icon(Icons.pending, size: 20, color: AppTheme.primaryOrange),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('5 New Assessments Pending Review', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('15 minutes ago', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'feedback',
          child: Row(
            children: [
              Icon(Icons.feedback, size: 20, color: AppTheme.primaryPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Submitted AI Feedback', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('1 hour ago', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'approved':
          case 'pending':
            context.go('/guidance-counselor/pending-approvals');
            break;
          case 'feedback':
            context.go('/guidance-counselor/ai-feedback');
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CounselorSidebar(currentRoute: '/guidance-counselor/dashboard'),
      appBar: AppBar(
        title: const Text('Guidance Counselor Dashboard'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          // Recent Activity Dropdown
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.history),
              tooltip: 'Recent Activity',
              onPressed: () => _showRecentActivityMenu(context),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryPurple.withOpacity(0.1),
                      child: Icon(
                        Icons.psychology,
                        size: 30,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Counselor!',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Monitor student assessments and provide feedback to improve AI recommendations',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Filters
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'today', label: Text('Today')),
                      ButtonSegment(value: 'week', label: Text('This Week')),
                      ButtonSegment(value: 'month', label: Text('This Month')),
                      ButtonSegment(value: 'all', label: Text('All Time')),
                    ],
                    selected: {_timeFilter},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _timeFilter = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Pending Approvals',
                    '12',
                    Icons.pending_actions,
                    AppTheme.primaryOrange,
                    () => context.go('/guidance-counselor/pending-approvals'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Students',
                    '156',
                    Icons.people,
                    AppTheme.primaryBlue,
                    () => context.go('/guidance-counselor/student-records'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Assessments Today',
                    '8',
                    Icons.assessment,
                    AppTheme.primaryGreen,
                    () => context.go('/guidance-counselor/monitoring'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'AI Feedback Given',
                    '45',
                    Icons.feedback,
                    AppTheme.primaryPurple,
                    () => context.go('/guidance-counselor/ai-feedback'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Analytics Section
            Card(
              color: AppTheme.primaryPurple.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: AppTheme.primaryPurple),
                        const SizedBox(width: 12),
                        Text(
                          'Analytics Overview',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAnalyticItem(
                            'Approval Rate',
                            '87%',
                            AppTheme.primaryGreen,
                            Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAnalyticItem(
                            'Avg. Response Time',
                            '2.5 hrs',
                            AppTheme.primaryBlue,
                            Icons.timer,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAnalyticItem(
                            'AI Accuracy',
                            '92%',
                            AppTheme.primaryPurple,
                            Icons.psychology,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

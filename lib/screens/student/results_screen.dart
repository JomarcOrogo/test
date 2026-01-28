import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/riasec_models.dart';
import '../../widgets/student_sidebar.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample results data for demo
    final scores = [
      RIASECScore(type: RIASECType.investigative, score: 85, percentage: 85.0),
      RIASECScore(type: RIASECType.artistic, score: 72, percentage: 72.0),
      RIASECScore(type: RIASECType.social, score: 65, percentage: 65.0),
      RIASECScore(type: RIASECType.enterprising, score: 58, percentage: 58.0),
      RIASECScore(type: RIASECType.realistic, score: 45, percentage: 45.0),
      RIASECScore(type: RIASECType.conventional, score: 40, percentage: 40.0),
    ];

    final primaryType = scores[0].type;
    final secondaryType = scores[1].type;

    // Top 3 Recommended Courses with RIASEC correspondence
    final recommendedCourses = [
      {
        'name': 'Computer Science',
        'matchingTypes': [primaryType, secondaryType],
        'reason': 'Matches your ${primaryType.name} and ${secondaryType.name} interests',
      },
      {
        'name': 'Data Science',
        'matchingTypes': [primaryType],
        'reason': 'Aligns with your ${primaryType.name} personality type',
      },
      {
        'name': 'Research Methods',
        'matchingTypes': [primaryType, secondaryType],
        'reason': 'Combines your ${primaryType.name} and ${secondaryType.name} strengths',
      },
    ];

    return Scaffold(
      drawer: StudentSidebar(currentRoute: '/student/results'),
      appBar: AppBar(
        title: const Text('Assessment Results'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Return to Main Menu',
            onPressed: () => context.go('/student/dashboard'),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _showShareDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Results Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.celebration,
                      size: 64,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Assessment Completed!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your results have been processed and sent to your email',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTypeChip(primaryType, isPrimary: true),
                        const SizedBox(width: 8),
                        const Text('+'),
                        const SizedBox(width: 8),
                        _buildTypeChip(secondaryType, isPrimary: false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // RIASEC Scores
            Text(
              'Your RIASEC Scores',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...scores.map((score) => _buildScoreCard(context, score)),
            const SizedBox(height: 24),

            // Recommended Courses (Top 3)
            Text(
              'Top 3 Recommended Courses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...recommendedCourses.asMap().entries.map((entry) {
              final index = entry.key;
              final course = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    course['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: (course['matchingTypes'] as List<RIASECType>).map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Chip(
                            label: Text(
                              type.code,
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: _getTypeColor(type).withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: _getTypeColor(type),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Why this course matches you:',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            course['reason'] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Email Notification Status
            Card(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Results Sent to Email',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'A detailed report has been sent to your registered email address',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Resending email...'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/student/history'),
                    icon: const Icon(Icons.history),
                    label: const Text('View History'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/student/student-details'),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake Assessment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(RIASECType type, {required bool isPrimary}) {
    return Chip(
      label: Text(
        '${type.code} - ${type.name}',
        style: TextStyle(
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      backgroundColor: isPrimary
          ? AppTheme.primaryBlue.withOpacity(0.2)
          : AppTheme.primaryGreen.withOpacity(0.2),
      avatar: CircleAvatar(
        backgroundColor: isPrimary ? AppTheme.primaryBlue : AppTheme.primaryGreen,
        child: Text(
          type.code,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, RIASECScore score) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                      backgroundColor: _getTypeColor(score.type).withOpacity(0.1),
                      child: Text(
                        score.type.code,
                        style: TextStyle(
                          color: _getTypeColor(score.type),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          score.type.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          score.type.description,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '${score.score}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getTypeColor(score.type),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: score.percentage / 100,
              backgroundColor: AppTheme.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(_getTypeColor(score.type)),
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(RIASECType type) {
    switch (type) {
      case RIASECType.realistic:
        return AppTheme.primaryRed;
      case RIASECType.investigative:
        return AppTheme.primaryBlue;
      case RIASECType.artistic:
        return AppTheme.primaryPurple;
      case RIASECType.social:
        return AppTheme.primaryGreen;
      case RIASECType.enterprising:
        return AppTheme.primaryYellow;
      case RIASECType.conventional:
        return AppTheme.primaryOrange;
    }
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Results'),
        content: const Text('Share your assessment results via email or download as PDF'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Results shared successfully')),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}

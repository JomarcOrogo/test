import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/riasec_models.dart';
import '../../widgets/counselor_sidebar.dart';

class StudentRecordsScreen extends StatefulWidget {
  const StudentRecordsScreen({super.key});

  @override
  State<StudentRecordsScreen> createState() => _StudentRecordsScreenState();
}

class _StudentRecordsScreenState extends State<StudentRecordsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'all';
  String? _filterCourse;
  int? _filterYearLevel;
  bool _showAdvancedFilters = false;

  // Sample archived student records (with StudentDetails and AssessmentResult)
  final List<ArchivedStudentRecord> _archivedRecords = [
    ArchivedStudentRecord(
      id: 'arch001',
      studentDetails: StudentDetails(
        firstName: 'John',
        lastName: 'Doe',
        middleName: 'Michael',
        suffixes: null,
        age: 17,
        birthdate: DateTime(2007, 5, 15),
        gender: 'Male',
        strand: 'STEM',
        gradeLevel: 'Grade 12',
      ),
      assessmentResult: AssessmentResult(
        id: 'assess001',
        studentId: 'student001',
        completedAt: DateTime.now().subtract(const Duration(days: 5)),
        scores: [
          RIASECScore(type: RIASECType.investigative, score: 85, percentage: 85.0),
          RIASECScore(type: RIASECType.realistic, score: 78, percentage: 78.0),
          RIASECScore(type: RIASECType.artistic, score: 65, percentage: 65.0),
        ],
        primaryType: RIASECType.investigative,
        secondaryType: RIASECType.realistic,
        recommendedCourses: ['Computer Science', 'Engineering', 'Data Science'],
        status: 'approved',
      ),
      recommendedCourses: [
        CourseRecommendation(
          id: '1',
          courseName: 'Computer Science',
          courseCode: 'CS101',
          description: 'Introduction to computer science and programming',
          matchingTypes: [RIASECType.investigative, RIASECType.realistic],
          matchScore: 0.92,
        ),
        CourseRecommendation(
          id: '2',
          courseName: 'Engineering',
          courseCode: 'ENG101',
          description: 'Fundamentals of engineering principles',
          matchingTypes: [RIASECType.realistic, RIASECType.investigative],
          matchScore: 0.88,
        ),
        CourseRecommendation(
          id: '3',
          courseName: 'Data Science',
          courseCode: 'DS101',
          description: 'Data analysis and machine learning',
          matchingTypes: [RIASECType.investigative],
          matchScore: 0.85,
        ),
      ],
      archivedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ArchivedStudentRecord(
      id: 'arch002',
      studentDetails: StudentDetails(
        firstName: 'Jane',
        lastName: 'Smith',
        middleName: null,
        suffixes: null,
        age: 16,
        birthdate: DateTime(2008, 8, 22),
        gender: 'Female',
        strand: 'HUMSS',
        gradeLevel: 'Grade 11',
      ),
      assessmentResult: AssessmentResult(
        id: 'assess002',
        studentId: 'student002',
        completedAt: DateTime.now().subtract(const Duration(days: 3)),
        scores: [
          RIASECScore(type: RIASECType.social, score: 90, percentage: 90.0),
          RIASECScore(type: RIASECType.artistic, score: 82, percentage: 82.0),
          RIASECScore(type: RIASECType.enterprising, score: 70, percentage: 70.0),
        ],
        primaryType: RIASECType.social,
        secondaryType: RIASECType.artistic,
        recommendedCourses: ['Psychology', 'Education', 'Social Work'],
        status: 'approved',
      ),
      recommendedCourses: [
        CourseRecommendation(
          id: '4',
          courseName: 'Psychology',
          courseCode: 'PSY101',
          description: 'Introduction to psychological principles',
          matchingTypes: [RIASECType.social],
          matchScore: 0.95,
        ),
        CourseRecommendation(
          id: '5',
          courseName: 'Education',
          courseCode: 'EDU101',
          description: 'Teaching and educational methods',
          matchingTypes: [RIASECType.social, RIASECType.artistic],
          matchScore: 0.90,
        ),
        CourseRecommendation(
          id: '6',
          courseName: 'Social Work',
          courseCode: 'SW101',
          description: 'Social services and community work',
          matchingTypes: [RIASECType.social],
          matchScore: 0.88,
        ),
      ],
      archivedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CounselorSidebar(currentRoute: '/guidance-counselor/student-records'),
      appBar: AppBar(
        title: const Text('Student Records & Management'),
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
            onPressed: () => context.go('/guidance-counselor/dashboard'),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export to CSV',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting student records to CSV...'),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppTheme.backgroundWhite,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, ID, or email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _filterStatus,
                        decoration: const InputDecoration(
                          labelText: 'Filter by Status',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Students')),
                          DropdownMenuItem(value: 'assessed', child: Text('Has Assessment')),
                          DropdownMenuItem(value: 'pending', child: Text('Pending Assessment')),
                          DropdownMenuItem(value: 'no_course', child: Text('No Course Selected')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _filterStatus = value ?? 'all';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Icon(_showAdvancedFilters ? Icons.filter_list_off : Icons.filter_list),
                      tooltip: 'Advanced Filters',
                      onPressed: () {
                        setState(() {
                          _showAdvancedFilters = !_showAdvancedFilters;
                        });
                      },
                    ),
                  ],
                ),
                // Advanced Filters
                if (_showAdvancedFilters) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _filterCourse,
                          decoration: const InputDecoration(
                            labelText: 'Filter by Course',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          hint: const Text('All Courses'),
                          items: const [
                            DropdownMenuItem(value: 'Computer Science', child: Text('Computer Science')),
                            DropdownMenuItem(value: 'Psychology', child: Text('Psychology')),
                            DropdownMenuItem(value: 'Business Administration', child: Text('Business Administration')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _filterCourse = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _filterYearLevel,
                          decoration: const InputDecoration(
                            labelText: 'Filter by Year Level',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          hint: const Text('All Year Levels'),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('Year 1')),
                            DropdownMenuItem(value: 2, child: Text('Year 2')),
                            DropdownMenuItem(value: 3, child: Text('Year 3')),
                            DropdownMenuItem(value: 4, child: Text('Year 4')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _filterYearLevel = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
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
                _buildStatItem('Total Records', '${_archivedRecords.length}', AppTheme.primaryBlue),
                _buildStatItem('Assessed', '${_archivedRecords.length}', AppTheme.primaryGreen),
                _buildStatItem('Approved', '${_archivedRecords.where((r) => r.assessmentResult.status == 'approved').length}', AppTheme.primaryGreen),
                _buildStatItem('Pending', '${_archivedRecords.where((r) => r.assessmentResult.status == 'pending').length}', AppTheme.primaryOrange),
              ],
            ),
          ),

          // Students List
          Expanded(
            child: _buildStudentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsList() {
    final filteredRecords = _archivedRecords.where((record) {
      final searchTerm = _searchController.text.toLowerCase();
      if (searchTerm.isNotEmpty) {
        final matchesSearch = record.studentDetails.fullName.toLowerCase().contains(searchTerm) ||
            record.assessmentResult.studentId.toLowerCase().contains(searchTerm) ||
            record.studentDetails.strand.toLowerCase().contains(searchTerm);
        if (!matchesSearch) return false;
      }

      // Status filter
      switch (_filterStatus) {
        case 'assessed':
          // All archived records are assessed
          break;
        case 'pending':
          if (record.assessmentResult.status != 'pending') return false;
          break;
        case 'no_course':
          // This doesn't apply to archived records
          break;
        default:
          break;
      }

      // Advanced filters
      if (_filterCourse != null) {
        final hasMatchingCourse = record.recommendedCourses.any(
          (course) => course.courseName == _filterCourse,
        );
        if (!hasMatchingCourse) return false;
      }
      // Year level filter doesn't apply to archived records (they have grade level instead)
      if (_filterYearLevel != null) {
        // Could filter by grade level if needed
      }

      return true;
    }).toList();

    if (filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No records found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        final status = record.assessmentResult.status ?? 'pending';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: status == 'approved'
                  ? AppTheme.primaryGreen.withOpacity(0.1)
                  : AppTheme.primaryOrange.withOpacity(0.1),
              child: Icon(
                status == 'approved' ? Icons.check_circle : Icons.pending,
                color: status == 'approved' ? AppTheme.primaryGreen : AppTheme.primaryOrange,
              ),
            ),
            title: Text(
              record.studentDetails.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${record.assessmentResult.studentId}'),
                Text('${record.studentDetails.strand} • ${record.studentDetails.gradeLevel}'),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        '${record.assessmentResult.primaryType.code}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                      labelStyle: TextStyle(color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(width: 4),
                    Chip(
                      label: Text(
                        '${record.assessmentResult.secondaryType.code}',
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                      labelStyle: TextStyle(color: AppTheme.primaryGreen),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 20),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'assessment',
                  child: Row(
                    children: [
                      Icon(Icons.assessment, size: 20),
                      SizedBox(width: 8),
                      Text('View Assessment'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                _handleMenuAction(value, record);
              },
            ),
            onTap: () {
              _showStudentDetails(context, record);
            },
          ),
        );
      },
    );
  }

  void _handleMenuAction(String action, ArchivedStudentRecord record) {
    switch (action) {
      case 'view':
        _showStudentDetails(context, record);
        break;
      case 'assessment':
        _showAssessmentDetails(context, record);
        break;
    }
  }

  void _showStudentDetails(BuildContext context, ArchivedStudentRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.studentDetails.fullName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${record.studentDetails.strand} • ${record.studentDetails.gradeLevel}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Student Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Student ID', record.assessmentResult.studentId),
              _buildDetailRow('Full Name', record.studentDetails.fullName),
              _buildDetailRow('Age', '${record.studentDetails.age} years old'),
              _buildDetailRow('Birthdate', DateFormat('MMMM dd, yyyy').format(record.studentDetails.birthdate)),
              _buildDetailRow('Gender', record.studentDetails.gender),
              _buildDetailRow('Strand', record.studentDetails.strand),
              _buildDetailRow('Grade Level', record.studentDetails.gradeLevel),
              const SizedBox(height: 24),
              Text(
                'Assessment Overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Assessment Date', DateFormat('MMMM dd, yyyy • hh:mm a').format(record.assessmentResult.completedAt)),
              _buildDetailRow('Primary Type', '${record.assessmentResult.primaryType.code} - ${record.assessmentResult.primaryType.name}'),
              _buildDetailRow('Secondary Type', '${record.assessmentResult.secondaryType.code} - ${record.assessmentResult.secondaryType.name}'),
              _buildDetailRow('Status', (record.assessmentResult.status ?? 'pending').toUpperCase()),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAssessmentDetails(context, record);
                  },
                  icon: const Icon(Icons.assessment),
                  label: const Text('View Full Assessment Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssessmentDetails(BuildContext context, ArchivedStudentRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Assessment Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // RIASEC Scores
              Text(
                'RIASEC Scores',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...record.assessmentResult.scores.map((score) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                    child: Text(
                      score.type.code,
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(score.type.name),
                  trailing: Text(
                    '${score.score} (${score.percentage.toStringAsFixed(1)}%)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )),
              const SizedBox(height: 24),
              // Top 3 Recommended Courses
              Text(
                'Top 3 Recommended Courses',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...record.recommendedCourses.take(3).map((course) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  leading: Icon(Icons.school, color: AppTheme.primaryBlue),
                  title: Text(course.courseName),
                  subtitle: Text('${course.courseCode} • Match: ${(course.matchScore * 100).toStringAsFixed(0)}%'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(course.description),
                          const SizedBox(height: 12),
                          Text(
                            'Matching RIASEC Types:',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: course.matchingTypes.map((type) => Chip(
                              label: Text('${type.code} - ${type.name}'),
                              backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: AppTheme.primaryBlue,
                                fontSize: 11,
                              ),
                            )).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    // Note: Students are automatically archived when they complete assessments
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Student Records'),
        content: const Text('Student records are automatically archived when students complete their RIASEC assessments. No manual entry needed.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

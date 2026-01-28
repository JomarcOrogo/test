import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../models/riasec_models.dart';
import '../../widgets/student_sidebar.dart';

class StudentDetailsForm extends StatefulWidget {
  const StudentDetailsForm({super.key});

  @override
  State<StudentDetailsForm> createState() => _StudentDetailsFormState();
}

class _StudentDetailsFormState extends State<StudentDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _suffixesController = TextEditingController();
  final _ageController = TextEditingController();
  DateTime? _birthdate;
  String? _gender;
  String? _strand;
  String? _gradeLevel;

  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _strandOptions = [
    'STEM (Science, Technology, Engineering, Mathematics)',
    'ABM (Accountancy, Business, Management)',
    'HUMSS (Humanities and Social Sciences)',
    'GAS (General Academic Strand)',
    'TVL (Technical-Vocational-Livelihood)',
    'ICT (Information and Communications Technology)',
    'Arts and Design',
    'Not Applicable',
  ];
  final List<String> _gradeLevelOptions = [
    'Grade 11',
    'Grade 12',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _suffixesController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: 'Select Birthdate',
    );
    if (picked != null) {
      setState(() {
        _birthdate = picked;
        // Calculate age
        final age = DateTime.now().difference(picked).inDays ~/ 365;
        _ageController.text = age.toString();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_birthdate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your birthdate')),
        );
        return;
      }
      if (_gender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
        return;
      }
      if (_strand == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your strand')),
        );
        return;
      }
      if (_gradeLevel == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your grade level')),
        );
        return;
      }

      // Save student details and proceed to instructions
      final studentDetails = StudentDetails(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        middleName: _middleNameController.text.trim().isEmpty 
            ? null 
            : _middleNameController.text.trim(),
        suffixes: _suffixesController.text.trim().isEmpty 
            ? null 
            : _suffixesController.text.trim(),
        age: int.parse(_ageController.text),
        birthdate: _birthdate!,
        gender: _gender!,
        strand: _strand!,
        gradeLevel: _gradeLevel!,
      );

      // Navigate to instructions screen
      context.go('/student/assessment-instructions', extra: studentDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: StudentSidebar(currentRoute: '/student/assessment'),
      appBar: AppBar(
        title: const Text('Student Information'),
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryBlue,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information Required',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please fill in all fields to proceed with the assessment',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

              // Name Fields
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name *',
                  hintText: 'Enter your first name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name *',
                  hintText: 'Enter your last name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _middleNameController,
                decoration: const InputDecoration(
                  labelText: 'Middle Name (Optional)',
                  hintText: 'Enter your middle name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _suffixesController,
                decoration: const InputDecoration(
                  labelText: 'Suffixes (Optional)',
                  hintText: 'e.g., Jr., Sr., II, III',
                  prefixIcon: Icon(Icons.text_fields),
                ),
              ),
              const SizedBox(height: 16),

              // Birthdate Field
              InkWell(
                onTap: _selectBirthdate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Birthdate *',
                    prefixIcon: const Icon(Icons.calendar_today),
                    suffixIcon: _birthdate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _birthdate = null;
                                _ageController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  child: Text(
                    _birthdate != null
                        ? '${_birthdate!.day}/${_birthdate!.month}/${_birthdate!.year}'
                        : 'Select your birthdate',
                    style: TextStyle(
                      color: _birthdate != null
                          ? AppTheme.textPrimary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Age Field (auto-calculated but can be edited)
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age *',
                  hintText: 'Enter your age',
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 10 || age > 100) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender Field
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                hint: const Text('Select your gender'),
                items: _genderOptions.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Strand Field
              DropdownButtonFormField<String>(
                value: _strand,
                decoration: const InputDecoration(
                  labelText: 'Strand *',
                  prefixIcon: Icon(Icons.school),
                ),
                hint: const Text('Select your strand'),
                items: _strandOptions.map((strand) {
                  return DropdownMenuItem(
                    value: strand,
                    child: Text(strand),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _strand = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your strand';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Grade Level Field
              DropdownButtonFormField<String>(
                value: _gradeLevel,
                decoration: const InputDecoration(
                  labelText: 'Grade Level *',
                  prefixIcon: Icon(Icons.grade),
                ),
                hint: const Text('Select your grade level'),
                items: _gradeLevelOptions.map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _gradeLevel = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your grade level';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continue to Assessment'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/student/dashboard'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Return to Main Menu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

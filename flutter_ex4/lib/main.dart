import 'package:flutter/material.dart';

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      home: const StudentHomePage(),
    );
  }
}

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  final List<String> pageTitles = [
    'Student Application',
    'Student Profile',
    'App Settings',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLargeScreen = constraints.maxWidth >= 700;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              pageTitles[selectedIndex],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Row(
              children: [
                if (isLargeScreen) ...[
                  NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profile'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                ],
                Expanded(
                  child: StudentContent(
                    isLargeScreen: isLargeScreen,
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    courseController: _courseController,
                    onSubmit: _submitForm,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isLargeScreen
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final course = _courseController.text.trim();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Student Submitted'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $name'),
              Text('Email: $email'),
              Text('Course: $course'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nameController.clear();
                _emailController.clear();
                _courseController.clear();
                _formKey.currentState!.reset();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class StudentContent extends StatelessWidget {
  final bool isLargeScreen;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController courseController;
  final VoidCallback onSubmit;

  const StudentContent({
    required this.isLargeScreen,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.courseController,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double contentWidth = constraints.maxWidth >= 1000
            ? 900
            : constraints.maxWidth >= 700
                ? 700
                : double.infinity;

        final double imageHeight = isLargeScreen ? 300 : 220;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isLargeScreen ? 32 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: contentWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const WelcomeSection(),
                  const SizedBox(height: 24),
                  ResponsiveActionSection(isLargeScreen: isLargeScreen),
                  const SizedBox(height: 24),
                  StudentForm(
                    formKey: formKey,
                    nameController: nameController,
                    emailController: emailController,
                    courseController: courseController,
                    onSubmit: onSubmit,
                  ),
                  const SizedBox(height: 24),
                  const StudentImage(height: 220),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/icons/student_icon.png',
          width: 72,
          height: 72,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        const Text(
          'Welcome, User!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage your student information easily.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class ResponsiveActionSection extends StatelessWidget {
  final bool isLargeScreen;

  const ResponsiveActionSection({required this.isLargeScreen, super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      ActionCard(
        icon: Icons.call,
        label: 'Contact',
        color: Colors.green,
        onPressed: () => _showMessage(context, 'Contact selected'),
      ),
      ActionCard(
        icon: Icons.person,
        label: 'Profile',
        color: Colors.blue,
        onPressed: () => _showMessage(context, 'Profile selected'),
      ),
      ActionCard(
        icon: Icons.school,
        label: 'Courses',
        color: Colors.orange,
        onPressed: () => _showMessage(context, 'Courses selected'),
      ),
    ];

    if (isLargeScreen) {
      return Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 16),
          Expanded(child: cards[1]),
          const SizedBox(width: 16),
          Expanded(child: cards[2]),
        ],
      );
    }

    return Column(
      children: [
        cards[0],
        const SizedBox(height: 12),
        cards[1],
        const SizedBox(height: 12),
        cards[2],
      ],
    );
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController courseController;
  final VoidCallback onSubmit;

  const StudentForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.courseController,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Student Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Student Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: courseController,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  prefixIcon: Icon(Icons.book),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter course name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentImage extends StatelessWidget {
  final double height;

  const StudentImage({
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/student.jpg',
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 48),
                  SizedBox(height: 8),
                  Text('Unable to load image'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
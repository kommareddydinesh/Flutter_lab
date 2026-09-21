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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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

  final List<String> pageTitles = [
    'Student Application',
    'Student Profile',
    'App Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLargeScreen = constraints.maxWidth >= 700;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              pageTitles[selectedIndex],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Row(
              children: [
                if (isLargeScreen) ...[
                  NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: _selectPage,
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
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isLargeScreen
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: _selectPage,
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

  void _selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class StudentContent extends StatelessWidget {
  final bool isLargeScreen;

  const StudentContent({
    required this.isLargeScreen,
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
              constraints: BoxConstraints(
                maxWidth: contentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const WelcomeSection(),
                  const SizedBox(height: 24),

                  ResponsiveActionSection(
                    isLargeScreen: isLargeScreen,
                  ),

                  const SizedBox(height: 24),

                  const StudentSearchField(),

                  const SizedBox(height: 24),

                  const SubmitButton(),

                  const SizedBox(height: 24),

                  StudentImage(
                    height: imageHeight,
                  ),
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
    return const Column(
      children: [
        SizedBox(height: 8),
        Text(
          'Welcome, User!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
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

  const ResponsiveActionSection({
    required this.isLargeScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final actionWidgets = [
      Expanded(
        child: ActionCard(
          icon: Icons.call,
          label: 'Contact',
          color: Colors.green,
          onPressed: () {
            _showMessage(context, 'Contact selected');
          },
        ),
      ),
      Expanded(
        child: ActionCard(
          icon: Icons.person,
          label: 'Profile',
          color: Colors.blue,
          onPressed: () {
            _showMessage(context, 'Profile selected');
          },
        ),
      ),
      Expanded(
        child: ActionCard(
          icon: Icons.school,
          label: 'Courses',
          color: Colors.orange,
          onPressed: () {
            _showMessage(context, 'Courses selected');
          },
        ),
      ),
    ];

    if (isLargeScreen) {
      return Row(
        children: [
          actionWidgets[0],
          const SizedBox(width: 16),
          actionWidgets[1],
          const SizedBox(width: 16),
          actionWidgets[2],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        actionWidgets[0].child,
        const SizedBox(height: 12),
        actionWidgets[1].child,
        const SizedBox(height: 12),
        actionWidgets[2].child,
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
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
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentSearchField extends StatelessWidget {
  const StudentSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Search students',
        hintText: 'Enter a student name',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Submitted successfully'),
            ),
          );
        },
        icon: const Icon(Icons.send),
        label: const Text('Submit'),
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

  static const String imageUrl =
      'https://static.vecteezy.com/system/resources/previews/033/692/783/non_2x/motorcycle-rider-rides-on-a-race-track-at-sunset-motion-blur-motorcycle-rider-on-sport-bike-rides-fast-on-race-track-at-sunset-extreme-athlete-sport-motorcycles-racing-ai-generated-free-photo.jpg';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return SizedBox(
            height: height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return SizedBox(
            height: height,
            child: const Center(
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
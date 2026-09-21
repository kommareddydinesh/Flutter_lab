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

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  static const String imageUrl =
      'https://static.vecteezy.com/system/resources/previews/033/692/783/non_2x/motorcycle-rider-rides-on-a-race-track-at-sunset-motion-blur-motorcycle-rider-on-sport-bike-rides-fast-on-race-track-at-sunset-extreme-athlete-sport-motorcycles-racing-ai-generated-free-photo.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Application',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
                constraints.maxWidth > 700 ? 650.0 : double.infinity;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: contentWidth,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WelcomeSection(),
                      SizedBox(height: 24),
                      ActionIcons(),
                      SizedBox(height: 24),
                      StudentSearchField(),
                      SizedBox(height: 24),
                      SubmitButton(),
                      SizedBox(height: 24),
                      StudentImage(imageUrl: imageUrl),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
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

class ActionIcons extends StatelessWidget {
  const ActionIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionIcon(
          icon: Icons.call,
          label: 'Contact',
          onPressed: () {},
        ),
        _ActionIcon(
          icon: Icons.person,
          label: 'Profile',
          onPressed: () {},
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 36,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(label),
      ],
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
  final String imageUrl;

  const StudentImage({
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
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
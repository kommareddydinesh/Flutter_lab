import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const BudgetInputScreen(),
    );
  }
}

class BudgetInputScreen extends StatefulWidget {
  const BudgetInputScreen({super.key});

  @override
  State<BudgetInputScreen> createState() => _BudgetInputScreenState();
}

class _BudgetInputScreenState extends State<BudgetInputScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final income = double.parse(_incomeController.text.trim());
      final rent = double.parse(_rentController.text.trim());
      final food = double.parse(_foodController.text.trim());
      final transport = double.parse(_transportController.text.trim());
      final other = double.parse(_otherController.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BudgetResultScreen(
            income: income,
            rent: rent,
            food: food,
            transport: transport,
            other: other,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Budget'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter your monthly expenses',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _incomeController,
                label: 'Monthly Income',
                icon: Icons.account_balance_wallet,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter monthly income';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Income must be positive';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _rentController,
                label: 'Rent/EMI',
                icon: Icons.home,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter rent/EMI';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Value must be non-negative';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _foodController,
                label: 'Food Expenses',
                icon: Icons.fastfood,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter food expenses';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Value must be non-negative';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _transportController,
                label: 'Transport Expenses',
                icon: Icons.directions_car,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter transport expenses';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Value must be non-negative';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _otherController,
                label: 'Other Expenses',
                icon: Icons.receipt_long,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter other expenses';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Value must be non-negative';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Calculate Budget',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _rentController.dispose();
    _foodController.dispose();
    _transportController.dispose();
    _otherController.dispose();
    super.dispose();
  }
}

class BudgetResultScreen extends StatelessWidget {
  final double income;
  final double rent;
  final double food;
  final double transport;
  final double other;

  const BudgetResultScreen({
    super.key,
    required this.income,
    required this.rent,
    required this.food,
    required this.transport,
    required this.other,
  });

  double get remainingBalance =>
      income - (rent + food + transport + other);

  @override
  Widget build(BuildContext context) {
    final isPositive = remainingBalance >= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Summary'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Monthly Budget Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _buildResultRow('Monthly Income', income),
            _buildResultRow('Rent/EMI', rent),
            _buildResultRow('Food Expenses', food),
            _buildResultRow('Transport Expenses', transport),
            _buildResultRow('Other Expenses', other),

            const Divider(height: 30),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPositive ? Colors.green : Colors.red,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Remaining Balance',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${remainingBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isPositive ? 'You are managing well!' : 'You are overspending!',
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
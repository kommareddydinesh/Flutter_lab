import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const EMIPage(),
    );
  }
}

class EMIPage extends StatefulWidget {
  const EMIPage({super.key});

  @override
  State<EMIPage> createState() => _EMIPageState();
}

class _EMIPageState extends State<EMIPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _loanTenureController = TextEditingController();

  String? _loanAmount;
  String? _emi;
  String? _totalInterest;

  void _calculateEMI() {
    if (_formKey.currentState!.validate()) {
      final double principal = double.parse(_loanAmountController.text.trim());
      final double annualRate = double.parse(_interestRateController.text.trim());
      final int months = int.parse(_loanTenureController.text.trim());

      final double monthlyRate = annualRate / 12 / 100;
      final double powerValue = pow(1 + monthlyRate, months).toDouble();

      final double emi = (principal * monthlyRate * powerValue) / (powerValue - 1);
      final double totalInterest = (emi * months) - principal;

      setState(() {
        _loanAmount = principal.toStringAsFixed(2);
        _emi = emi.toStringAsFixed(2);
        _totalInterest = totalInterest.toStringAsFixed(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              TextFormField(
                controller: _loanAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Loan Amount',
                  hintText: 'Enter loan amount',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter loan amount';
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return 'Loan amount must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _interestRateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Annual Interest Rate (%)',
                  hintText: 'Enter interest rate',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter annual interest rate';
                  }
                  final rate = double.tryParse(value.trim());
                  if (rate == null || rate <= 0) {
                    return 'Interest rate must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _loanTenureController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Loan Tenure (in months)',
                  hintText: 'Enter tenure in months',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter loan tenure';
                  }
                  final months = int.tryParse(value.trim());
                  if (months == null || months <= 0) {
                    return 'Tenure must be a positive integer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: _calculateEMI,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Calculate EMI',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),

              if (_emi != null && _totalInterest != null && _loanAmount != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Loan Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Loan Amount: ₹$_loanAmount'),
                      const SizedBox(height: 8),
                      Text('EMI: ₹$_emi'),
                      const SizedBox(height: 8),
                      Text('Total Interest: ₹$_totalInterest'),
                    ],
                  ),
                )
              else
                const Center(
                  child: Text(
                    'Enter valid values to calculate EMI',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _loanTenureController.dispose();
    super.dispose();
  }
}

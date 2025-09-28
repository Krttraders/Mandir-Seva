import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for input formatters

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  final List<double> _presetAmounts = [101, 251, 501, 1001, 2100];
  double _selectedAmount = 0;
  final TextEditingController _customAmountController = TextEditingController();
  final FocusNode _customAmountFocusNode = FocusNode();
  String _selectedPurpose = 'General Donation';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _customAmountFocusNode.addListener(_handleCustomAmountFocus);
    _customAmountController.addListener(_handleCustomAmountChange);
  }

  void _handleCustomAmountFocus() {
    if (_customAmountFocusNode.hasFocus && _selectedAmount != 0) {
      setState(() {
        _selectedAmount = 0;
      });
    }
  }

  void _handleCustomAmountChange() {
    if (_customAmountController.text.isNotEmpty && _selectedAmount != 0) {
      setState(() {
        _selectedAmount = 0;
      });
    }
  }

  @override
  void dispose() {
    _customAmountController.removeListener(_handleCustomAmountChange);
    _customAmountController.dispose();
    _customAmountFocusNode.removeListener(_handleCustomAmountFocus);
    _customAmountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const MaterialColor primaryColor = Colors.deepOrange;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Donation'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.currency_rupee, color: primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Support Shree Mandir',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              'Your support ensures smooth temple operations & maintenance.',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Donation Purpose ---
              _buildSectionTitle('Select Donation Purpose'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                items: [
                  'General Donation',
                  'Annadanam (Food)',
                  'Flower Decoration',
                  'Renovation',
                  'Education Fund',
                  'Medical Fund',
                ].map((String purpose) {
                  return DropdownMenuItem<String>(
                    value: purpose,
                    child: Text(purpose),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPurpose = value!;
                  });
                },
                decoration: _getOutlineInputDecoration(),
              ),
              const SizedBox(height: 24),

              // --- Donation Amount ---
              _buildSectionTitle('Enter Amount (₹)'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _presetAmounts.map((amount) {
                  return ActionChip(
                    label: Text('₹${amount.toInt()}'),
                    onPressed: () {
                      setState(() {
                        // Determine the new selected amount
                        final bool isCurrentlySelected = _selectedAmount == amount;
                        _selectedAmount = isCurrentlySelected ? 0 : amount;

                        // FIX: Fill the custom amount field when a chip is selected
                        if (!isCurrentlySelected) {
                          _customAmountController.text = amount.toInt().toString();
                        } else {
                          _customAmountController.clear();
                        }

                        _customAmountFocusNode.unfocus();
                      });
                    },
                    backgroundColor: _selectedAmount == amount ? primaryColor.shade100 : Colors.grey.shade100,
                    side: BorderSide(
                      color: _selectedAmount == amount ? primaryColor : Colors.grey.shade300,
                    ),
                    labelStyle: TextStyle(
                      color: _selectedAmount == amount ? primaryColor : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Custom Amount
              TextFormField(
                controller: _customAmountController,
                focusNode: _customAmountFocusNode,
                decoration: _getOutlineInputDecoration(
                  labelText: 'Enter Custom Amount (Optional)',
                  prefixIcon: const Icon(Icons.currency_rupee),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  final amount = double.tryParse(value ?? '0') ?? 0;
                  if (_selectedAmount == 0 && amount <= 0) {
                    return 'Please enter a valid amount or select a preset.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tax Exemption Note
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Donations above ₹500 may be eligible for 80G tax exemption. Please ensure your name and email are correct.',
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              // --- Donor Information ---
              _buildSectionTitle('Donor Information (Required)'),
              const SizedBox(height: 12),
              TextFormField(
                decoration: _getOutlineInputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: _getOutlineInputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: _getOutlineInputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Phone number is required' : null,
              ),
              const SizedBox(height: 32),

              // Donate Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'PROCEED TO DONATE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets and Functions ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _getOutlineInputDecoration({String? labelText, Icon? prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
    );
  }

  void _proceedToPayment() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
      return;
    }

    final customAmount = double.tryParse(_customAmountController.text) ?? 0;
    final amount = _selectedAmount > 0 ? _selectedAmount : customAmount;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an amount to donate.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Donation'),
        content: Text(
          'You are donating ₹${amount.toStringAsFixed(2)} for $_selectedPurpose. Proceed to payment gateway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPaymentSuccess(amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm & Pay'),
          ),
        ],
      ),
    );
  }

  void _showPaymentSuccess(double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Donation Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'A generous amount of ₹${amount.toStringAsFixed(2)} has been donated for $_selectedPurpose.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            const Text(
              'Thank you for your noble contribution. A receipt will be sent to your email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
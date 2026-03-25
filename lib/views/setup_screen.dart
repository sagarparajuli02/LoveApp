import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_days/views/widgets/bottom_navigation.dart';
import 'package:love_days/utils/app_colors.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  static const _defaultPadding = 16.0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _partnerController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  DateTime? _startDate;
  bool _isCreating = true;
  bool _isLoading = false;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _partnerController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _startDate = date);
  }

  // CREATE COUPLE
  Future<void> _createCouple() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = _auth.currentUser!;

    try {
      // Generate a random 6-digit code
      final inviteCode = (Random().nextInt(900000) + 100000).toString();

      await _firestore.collection('users').doc(user.uid).set({
        'inviteCode': inviteCode,
        'partner1Name': _nameController.text.trim(),
        'partner2Name': _partnerController.text.trim(),
        'startDate': Timestamp.fromDate(_startDate!),
        'userRole': 'user1', // Assign creator role
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigation()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating couple: $e')),
      );
    }
  }

  // JOIN COUPLE
  Future<void> _joinCouple() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = _auth.currentUser!;
    final code = _inviteCodeController.text.trim();

    try {
      final query = await _firestore
          .collection('users')
          .where('inviteCode', isEqualTo: code)
          .get();

      if (query.docs.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid invite code')));
        setState(() => _isLoading = false);
        return;
      }

      final coupleDoc = query.docs.first;
      final coupleData = coupleDoc.data();

      // Update partner2Name if empty
      if ((coupleData['partner2Name'] ?? '').isEmpty) {
        await coupleDoc.reference.update({
          'partner2Name': _nameController.text.trim(),
        });
      }

      // link user to couple and copy necessary data
      await _firestore.collection('users').doc(user.uid).set({
        'inviteCode': code,
        'partner1Name': _nameController.text.trim(),
        // The inviter (partner1 in their doc) becomes partner2 for the joiner
        'partner2Name': coupleData['partner1Name'],
        'startDate': coupleData['startDate'],
        'userRole': 'user2', // Assign joiner role
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigation()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error joining: $e')));
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String errorMsg) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (v) => v == null || v.isEmpty ? errorMsg : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBlack,
      appBar: AppBar(
        backgroundColor: AppColors.accentOrange,
        title: const Text('Set Up Your Love Story'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(_defaultPadding),
                child: Column(
                  children: [
                    ToggleButtons(
                      isSelected: [_isCreating, !_isCreating],
                      onPressed: (i) => setState(() => _isCreating = i == 0),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Create Couple'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('Join Couple'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                              _nameController, 'Your Name', 'Enter your name'),
                          const SizedBox(height: 12),
                          if (_isCreating)
                            Column(
                              children: [
                                _buildTextField(_partnerController,
                                    'Partner Name', 'Enter partner name'),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Text(_startDate == null
                                        ? 'Select Start Date'
                                        : 'Start: ${_startDate!.toLocal()}'
                                            .split(' ')[0]),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _selectStartDate,
                                      child: const Text('Pick Date'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (!_isCreating)
                            _buildTextField(_inviteCodeController,
                                'Invite Code', 'Enter invite code'),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                            ),
                            onPressed:
                                _isCreating ? _createCouple : _joinCouple,
                            child: Text(
                              _isCreating ? 'Create Couple' : 'Join Couple',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

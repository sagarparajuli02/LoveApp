import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_days/widgets/botton_navigation.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
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
    if (!_formKey.currentState!.validate() || _startDate == null) return;

    setState(() => _isLoading = true);

    final user = _auth.currentUser!;

    // simple 6 digit invite code
    final inviteCode = DateTime.now().millisecondsSinceEpoch
        .toString()
        .substring(7, 13);

    await _firestore.collection('users').doc(user.uid).set({
      'inviteCode': inviteCode,
      'partner1Name': _nameController.text.trim(),
      'partner2Name': _partnerController.text.trim(),
      'startDate': Timestamp.fromDate(_startDate!),
    });

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNavigation()),
    );
  }

  // JOIN COUPLE
  Future<void> _joinCouple() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = _auth.currentUser!;
    final code = _inviteCodeController.text.trim();

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

    // Update partner2Name if empty
    if ((coupleDoc.data()['partner2Name'] ?? '').isEmpty) {
      await coupleDoc.reference.update({
        'partner2Name': _nameController.text.trim(),
      });
    }

    // link user to couple
    await _firestore.collection('users').doc(user.uid).set({
      'inviteCode': code,
    });

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const BottomNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Set Up Your Love Story'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
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
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Your Name',
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 12),
                        if (_isCreating)
                          Column(
                            children: [
                              TextFormField(
                                controller: _partnerController,
                                decoration: const InputDecoration(
                                  labelText: 'Partner Name',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Enter partner name'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    _startDate == null
                                        ? 'Select Start Date'
                                        : 'Start: ${_startDate!.toLocal()}'
                                              .split(' ')[0],
                                  ),
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
                          TextFormField(
                            controller: _inviteCodeController,
                            decoration: const InputDecoration(
                              labelText: 'Invite Code',
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter invite code'
                                : null,
                          ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                          ),
                          onPressed: _isCreating ? _createCouple : _joinCouple,
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
    );
  }
}

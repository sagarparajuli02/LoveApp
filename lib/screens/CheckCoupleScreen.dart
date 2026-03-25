import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_days/screens/set_up_screen.dart';
import 'package:love_days/widgets/botton_navigation.dart';

class CheckCoupleScreen extends StatefulWidget {
  const CheckCoupleScreen({super.key});

  @override
  State<CheckCoupleScreen> createState() => _CheckCoupleScreenState();
}

class _CheckCoupleScreenState extends State<CheckCoupleScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkCouple();
  }

  Future<void> _checkCouple() async {
    final user = _auth.currentUser!;
    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists && (userDoc.data()?['inviteCode'] ?? '').isNotEmpty) {
      // Go to HomeScreen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavigation()),
      );
    } else {
      // Go to SetupScreen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SetupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

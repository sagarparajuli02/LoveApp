import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:love_days/views/setup_screen.dart';
import 'package:love_days/views/widgets/bottom_navigation.dart';

class CheckCoupleScreen extends StatefulWidget {
  const CheckCoupleScreen({super.key});

  @override
  State<CheckCoupleScreen> createState() => _CheckCoupleScreenState();
}

class _CheckCoupleScreenState extends State<CheckCoupleScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure navigation happens after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCouple();
    });
  }

  Future<void> _checkCouple() async {
    final user = _auth.currentUser;

    if (user == null || !mounted) return;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      final String coupleId = _resolveCoupleId(userData);

      if (!mounted) return;

      if (userDoc.exists && coupleId.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BottomNavigation(initialCoupleId: coupleId),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SetupScreen()),
        );
      }
    } catch (e) {
      debugPrint("Error checking couple status: $e");
      if (!mounted) return;
      if (e is FirebaseException && e.code == 'permission-denied') {
        setState(() {
          _errorMessage =
              'Firestore denied access to your user record. Update your Firestore rules to allow signed-in users to read users/{uid}.';
        });
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SetupScreen()),
      );
    }
  }

  String _resolveCoupleId(Map<String, dynamic>? userData) {
    if (userData == null) return '';

    final inviteCode = userData['inviteCode'];
    if (inviteCode is String && inviteCode.isNotEmpty) {
      return inviteCode;
    }

    final coupleId = userData['coupleId'];
    if (coupleId is String && coupleId.isNotEmpty) {
      return coupleId;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  color: Colors.white70,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkCouple,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFec5b13),
        ),
      ),
    );
  }
}

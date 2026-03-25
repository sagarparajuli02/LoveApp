import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodSelectorSheet extends StatefulWidget {
  final String inviteCode;
  final String myRole;

  const MoodSelectorSheet({
    super.key,
    required this.inviteCode,
    required this.myRole,
  });

  @override
  State<MoodSelectorSheet> createState() => _MoodSelectorSheetState();
}

class _MoodSelectorSheetState extends State<MoodSelectorSheet> {
  String? selectedMoodLabel;
  String? selectedEmoji;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Happy'},
    {'emoji': '😔', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '🥰', 'label': 'Missing you'},
    {'emoji': '😫', 'label': 'Stressed'},
    {'emoji': '😴', 'label': 'Tired'},
  ];

  Future<void> _handleUpdate() async {
    if (selectedMoodLabel == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('couples')
          .doc(widget.inviteCode)
          .collection('moodstatus')
          .doc(widget.myRole)
          .set({
        'status': "$selectedEmoji $selectedMoodLabel",
        'emoji': selectedEmoji,
        'label': selectedMoodLabel,
        'note': _noteController.text.trim(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the height of the keyboard
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
      child: Container(
        // Allow the container to grow, but max out at 90% of screen
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + keyboardHeight),
        decoration: BoxDecoration(
          color: const Color(0xFF120C12).withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: SingleChildScrollView(
          // ✅ FIX: Added scroll view for keyboard space
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content tightly
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("How are you feeling?",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Let your partner know your vibe right now",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 16)),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  bool isSelected = selectedMoodLabel == mood['label'];
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedMoodLabel = mood['label'];
                      selectedEmoji = mood['emoji'];
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2D1B15)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                            color: isSelected
                                ? const Color(0xFFec5b13)
                                : Colors.transparent,
                            width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mood['emoji'],
                              style: const TextStyle(fontSize: 44)),
                          const SizedBox(height: 8),
                          Text(mood['label'],
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _noteController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit_note,
                        color: Colors.orange.withOpacity(0.6)),
                    hintText: "Add a note... (optional)",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: selectedMoodLabel != null ? _handleUpdate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFec5b13),
                    disabledBackgroundColor: Colors.white.withOpacity(0.05),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text("Share with partner ❤",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

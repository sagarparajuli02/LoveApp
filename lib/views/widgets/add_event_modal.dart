import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:love_days/theme/app_text.dart';
import 'package:love_days/utils/app_colors.dart';
// Internal imports - adjusted to your project structure
import 'package:love_days/controllers/event_controller.dart';
import 'package:love_days/models/event_model.dart';

class AddEventModal extends StatefulWidget {
  final EventController controller;

  const AddEventModal({super.key, required this.controller});

  @override
  State<AddEventModal> createState() => _AddEventModalState();
}

class _AddEventModalState extends State<AddEventModal> {
  // --- Controllers & State ---
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedIconName = 'ring'; // Matches the 'name' in _customIcons
  bool _notify = true;

  // --- Theme Constants ---
  final Color primaryColor = AppColors.accentOrange;
  final Color glassBorder = AppColors.whiteA(0.15);
  final Color glassBackground = AppColors.whiteA(0.08);

  // --- Asset Icon Configuration ---
  final List<Map<String, String>> _customIcons = [
    {'name': 'ring', 'path': 'assets/icons/ring.png'},
    {'name': 'birthday', 'path': 'assets/icons/birthday.png'},
    {'name': 'gift', 'path': 'assets/icons/gift.png'},
    {'name': 'plane', 'path': 'assets/icons/plane.png'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Handles keyboard overlap
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: glassBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border(top: BorderSide(color: glassBorder)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDragHandle(),
                  _buildHeader(),
                  const SizedBox(height: 25),
                  _buildSectionTitle("EVENT DETAILS"),
                  _buildTitleInput(),
                  const SizedBox(height: 25),
                  _buildSectionTitle("SELECT DATE"),
                  _buildDatePickerCard(),
                  const SizedBox(height: 25),
                  _buildSectionTitle("CHOOSE AN ICON"),
                  _buildIconHorizontalList(),
                  const SizedBox(height: 25),
                  _buildNotificationToggle(),
                  const SizedBox(height: 30),
                  _buildSubmitButton(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- UI Build Methods ---

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(backgroundColor: Colors.white10),
        ),
        Text(
          "Add New Event",
          style: context.appText.subheading,
        ),
        TextButton(
          onPressed: _handleSave,
          child: Text(
            "Save",
            style: context.appText.body.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        text,
        style: context.appText.statLabel.copyWith(
          color: Colors.white54,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return TextField(
      controller: _titleController,
      style: context.appText.body,
      decoration: InputDecoration(
        hintText: "What are we celebrating?",
        hintStyle: context.appText.caption.copyWith(color: Colors.white24),
        filled: true,
        fillColor: AppColors.whiteA(0.05),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.whiteA(0.05)),
        ),
      ),
    );
  }

  Widget _buildDatePickerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteA(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: primaryColor, size: 20),
              const SizedBox(width: 12),
              Text(
                DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                style: context.appText.body,
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(primary: primaryColor),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Text(
              "Change",
              style: context.appText.navLabel.copyWith(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconHorizontalList() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _customIcons.length,
        itemBuilder: (context, index) {
          final item = _customIcons[index];
          final isSelected = _selectedIconName == item['name'];

          return GestureDetector(
            onTap: () => setState(() => _selectedIconName = item['name']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor.withValues(alpha: 0.2)
                    : AppColors.whiteA(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.white10,
                  width: 2,
                ),
              ),
              child: Image.asset(
                item['path']!,
                // Tint logic: If icon is silhouette, use primaryColor.
                // If icons are full-color, remove the 'color' property.
                // color: isSelected ? primaryColor : Colors.white60,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteA(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(Icons.notifications_active, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Remind me",
              style: context.appText.body,
            ),
          ),
          Switch(
            value: _notify,
            onChanged: (val) => setState(() => _notify = val),
            activeThumbColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: Text(
          "Create Special Event",
          style: context.appText.body.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // --- Logic ---

  void _handleSave() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an event name")),
      );
      return;
    }

    widget.controller.addEvent(EventModel(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      date: _selectedDate,
      icon: _selectedIconName, // Stores just the name (e.g., 'ring')
      notify: _notify,
    ));

    Navigator.pop(context);
  }
}

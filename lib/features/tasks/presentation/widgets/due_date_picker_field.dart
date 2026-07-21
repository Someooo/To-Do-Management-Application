import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DueDatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = (selectedDate == null || selectedDate!.isBefore(today))
        ? today
        : selectedDate!;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: DateTime(today.year + 100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0060A9),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A1C1F),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF404752);
    const inputBgColor = Color(0xFFF3F3F7);
    const textColor = Color(0xFF1A1C1F);

    final controller = TextEditingController(
      text: selectedDate != null
          ? DateFormat('MMM dd, yyyy').format(selectedDate!)
          : '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'Due Date',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: labelColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _pickDate(context),
          validator: (value) {
            if (selectedDate == null || (value == null || value.isEmpty)) {
              return 'Please select a due date';
            }
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final compareDate = DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day,
            );
            if (compareDate.isBefore(today)) {
              return 'Due date cannot be in the past.';
            }
            return null;
          },
          style: const TextStyle(
            fontSize: 15,
            color: textColor,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            hintText: 'Select due date',
            hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
            ),
            prefixIcon: const Icon(
              Icons.calendar_today_rounded,
              color: labelColor,
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

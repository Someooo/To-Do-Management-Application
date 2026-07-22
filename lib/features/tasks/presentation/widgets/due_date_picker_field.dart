import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDatePickerField extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DueDatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DueDatePickerField> createState() => _DueDatePickerFieldState();
}

class _DueDatePickerFieldState extends State<DueDatePickerField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedDate != null
          ? DateFormat('MMM dd, yyyy').format(widget.selectedDate!)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant DueDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _controller.text = widget.selectedDate != null
          ? DateFormat('MMM dd, yyyy').format(widget.selectedDate!)
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = (widget.selectedDate == null || widget.selectedDate!.isBefore(today))
        ? today
        : widget.selectedDate!;

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
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? Colors.grey.shade400 : const Color(0xFF404752);
    final inputBgColor = isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F3F7);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
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
          controller: _controller,
          readOnly: true,
          onTap: () => _pickDate(context),
          validator: (value) {
            if (widget.selectedDate == null || (value == null || value.isEmpty)) {
              return 'Please select a due date';
            }
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final compareDate = DateTime(
              widget.selectedDate!.year,
              widget.selectedDate!.month,
              widget.selectedDate!.day,
            );
            if (compareDate.isBefore(today)) {
              return 'Due date cannot be in the past.';
            }
            return null;
          },
          style: TextStyle(
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
            prefixIcon: Icon(
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

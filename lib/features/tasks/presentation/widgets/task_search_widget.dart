import 'package:flutter/material.dart';
import 'package:my_template/core/utils/debouncer.dart';

class TaskSearchWidget extends StatefulWidget {
  final String initialQuery;
  final ValueChanged<String> onChanged;

  const TaskSearchWidget({
    super.key,
    this.initialQuery = '',
    required this.onChanged,
  });

  @override
  State<TaskSearchWidget> createState() => _TaskSearchWidgetState();
}

class _TaskSearchWidgetState extends State<TaskSearchWidget> {
  late final TextEditingController _controller;
  final Debouncer _debouncer = Debouncer(milliseconds: 350);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void didUpdateWidget(covariant TaskSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialQuery.isEmpty && _controller.text.isNotEmpty) {
      _controller.text = '';
    }
  }

  @override
  void dispose() {
    _debouncer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _debouncer.cancel();
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  void _onTextTyped(String val) {
    setState(() {});
    _debouncer.run(() {
      widget.onChanged(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    const inputBgColor = Colors.white;
    const labelColor = Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onTextTyped,
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF111827),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: const TextStyle(
            fontSize: 15,
            color: labelColor,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: labelColor,
            size: 22,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: labelColor,
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF3B82F6),
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}

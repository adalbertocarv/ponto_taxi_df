import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/themes/tema_provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.isDarkMode
                ? Colors.white
                : const Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: themeProvider.isDarkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
            prefixIcon: Icon(
              icon,
              color: themeProvider.primaryColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.grey.shade700
                    : const Color(0xFFE9ECEF),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeProvider.primaryColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.grey.shade700
                    : const Color(0xFFE9ECEF),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.red.shade400
                    : Colors.red.shade600,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: themeProvider.isDarkMode
                    ? Colors.red.shade400
                    : Colors.red.shade600,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: themeProvider.isDarkMode
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
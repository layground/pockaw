import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';

class CustomNumericField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final Color? hintColor;
  final Color? background;
  final IconData? icon;
  final IconData? suffixIcon;

  const CustomNumericField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.hintColor,
    this.background,
    this.icon,
    this.suffixIcon,
  });

  @override
  State<CustomNumericField> createState() => _CustomNumericFieldState();
}

class _CustomNumericFieldState extends State<CustomNumericField> {
  final String currencyPrefix = '\$';
  String _lastFormattedValue = "";

  void onChanged(String value) {
    if (value == _lastFormattedValue) return;

    // Remove the currency prefix and sanitize input
    String sanitizedValue =
        value.replaceAll(currencyPrefix, '').replaceAll(' ', '').trim();

    // Replace commas (thousand separator) with empty for parsing
    sanitizedValue = sanitizedValue.replaceAll(',', '');

    // Split into integer and decimal parts
    List<String> parts = sanitizedValue.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length == 2 ? parts[1] : '';

    // Ensure the decimal part is no more than 2 digits
    if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    // Format the integer part with thousand separator
    final formatter = NumberFormat("#,##0", "en_US");
    String formattedInteger =
        integerPart.isNotEmpty ? formatter.format(int.parse(integerPart)) : '';

    // Combine integer and decimal parts
    String formattedValue = (decimalPart.isNotEmpty || parts.length == 2)
        ? "$currencyPrefix $formattedInteger.$decimalPart"
        : "$currencyPrefix $formattedInteger";

    if (formattedInteger.isEmpty) {
      formattedValue = '';
    }

    // Avoid infinite loop
    if (formattedValue != _lastFormattedValue) {
      _lastFormattedValue = formattedValue;

      // Update the controller with the formatted value
      widget.controller?.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );

      // Notify parent widget with the raw numeric value
      onChanged(sanitizedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      background: Colors.white,
      icon: widget.icon,
      hint: widget.hint,
      hintColor: widget.hintColor,
      inputAction: TextInputAction.done,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
        SingleDotInputFormatter(),
        DecimalInputFormatter(),
      ],
      onChanged: onChanged,
      // hintColor: AppColors.dark,
    );
  }
}

class SingleDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new input contains more than one dot
    if (newValue.text.split('.').length > 2) {
      return oldValue; // Reject the new input
    }
    return newValue;
  }
}

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow only numbers, a single dot, and two digits after the dot
    final regex = RegExp(r'^\d*\.?\d{0,2}$');

    if (!regex.hasMatch(text)) {
      return oldValue; // Reject invalid input
    }

    return newValue;
  }
}

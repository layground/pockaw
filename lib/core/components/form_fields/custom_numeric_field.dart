import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pockaw/core/components/form_fields/custom_text_field.dart';
import 'package:pockaw/features/currency_picker/data/models/currency.dart';
import 'package:pockaw/features/currency_picker/data/sources/currency_local_source.dart';
import 'package:pockaw/features/currency_picker/presentation/riverpod/currency_picker_provider.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/riverpod/wallet_providers.dart';

class CustomNumericField extends ConsumerWidget {
  final String label;
  final String? defaultCurrency;
  final TextEditingController? controller;
  final String? hint;
  final Color? hintColor;
  final Color? background;
  final List<List<dynamic>>? icon;
  final List<List<dynamic>>? suffixIcon;
  final bool useSelectedCurrency;
  final bool appendCurrencySymbolToHint;
  final bool isRequired;
  final bool autofocus;

  const CustomNumericField({
    super.key,
    required this.label,
    this.defaultCurrency,
    this.controller,
    this.hint,
    this.hintColor,
    this.background,
    this.icon,
    this.suffixIcon,
    this.useSelectedCurrency = false,
    this.appendCurrencySymbolToHint = false,
    this.isRequired = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    Currency currency = ref.watch(currencyProvider);
    String defaultCurrency =
        this.defaultCurrency ??
        ref.read(activeWalletProvider).value?.currencyByIsoCode(ref).symbol ??
        CurrencyLocalDataSource.dummy.symbol;

    if (useSelectedCurrency) {
      defaultCurrency = currency.symbol;
    }

    String hint =
        '${appendCurrencySymbolToHint ? defaultCurrency : ''} ${this.hint ?? ''}'
            .trim();

    var lastFormattedValue = '';

    void onChanged(String value) {
      if (value == lastFormattedValue) return;

      // Remove the currency prefix and sanitize input
      String sanitizedValue = value
          .replaceAll(defaultCurrency, '')
          .replaceAll(' ', '')
          .trim();

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
      final formatter = NumberFormat('#,##0', 'en_US');
      String formattedInteger = integerPart.isNotEmpty
          ? formatter.format(int.parse(integerPart))
          : '';

      // Combine integer and decimal parts
      String formattedValue = (decimalPart.isNotEmpty || parts.length == 2)
          ? '$defaultCurrency $formattedInteger.$decimalPart'
          : '$defaultCurrency $formattedInteger';

      if (formattedInteger.isEmpty) {
        formattedValue = '';
      }

      // Avoid infinite loop
      if (formattedValue != lastFormattedValue) {
        lastFormattedValue = formattedValue;

        // Update the controller with the formatted value
        controller?.value = TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );

        // Notify parent widget with the raw numeric value
        onChanged(sanitizedValue);
      }
    }

    return CustomTextField(
      controller: controller,
      label: label,
      prefixIcon: icon,
      hint: hint,
      textInputAction: TextInputAction.done,
      suffixIcon: suffixIcon,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
        SingleDotInputFormatter(),
        DecimalInputFormatter(),
        LengthLimitingTextInputFormatter(12),
      ],
      onChanged: onChanged,
      isRequired: isRequired,
      autofocus: autofocus,
    );
  }
}

class SingleDotInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow only numbers, a single dot, and two digits after the dot
    final regex = RegExp(r'^\d*\.?\d{0,2}$');

    if (!regex.hasMatch(text)) {
      return oldValue; // Reject invalid input
    }

    return newValue;
  }
}

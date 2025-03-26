// This file defines a main function and a widget class `InBankForm`.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:inbank_frontend/colors.dart';
import 'package:inbank_frontend/fonts.dart';
import 'package:inbank_frontend/slider_style.dart';
import 'package:inbank_frontend/widgets/loan_form.dart';

void main() {
  runApp(const MaterialApp(home: InBankForm()));
}

class InBankForm extends StatefulWidget {
  const InBankForm({Key? key}) : super(key: key);

  @override
  State<InBankForm> createState() => _InBankFormState();
}

class _InBankFormState extends State<InBankForm> {
  String _selectedCountry = 'ESTONIA';

  void _updateCountry(String country) {
    setState(() {
      _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const minHeight = 600.0; // Increased height for safety

    return MaterialApp(
      title: 'Loan Application',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryColor,
        textTheme: TextTheme(
          displayLarge: displayLarge,
          bodyMedium: bodyMedium,
        ),
        sliderTheme: sliderThemeData,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: AppColors.primaryColor)
            .copyWith(secondary: AppColors.secondaryColor)
            .copyWith(error: AppColors.errorColor),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColors.textColor.withOpacity(0.3),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              height: max(minHeight, screenHeight * 0.85),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Act. Apply for a loan.',
                    style: displayLarge,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFlagButton('ESTONIA', '🇪🇪'),
                      const SizedBox(width: 12),
                      _buildFlagButton('LATVIA', '🇱🇻'),
                      const SizedBox(width: 12),
                      _buildFlagButton('LITHUANIA', '🇱🇹'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: LoanForm(selectedCountry: _selectedCountry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlagButton(String country, String emoji) {
    final isSelected = _selectedCountry == country;

    return GestureDetector(
      onTap: () => _updateCountry(country),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondaryColor : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

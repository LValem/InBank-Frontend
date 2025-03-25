// This file defines a `LoanForm` widget which is a stateful widget
// that displays a loan application form.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:inbank_frontend/fonts.dart';
import 'package:inbank_frontend/widgets/national_id_field.dart';

import '../api_service.dart';
import '../colors.dart';

// LoanForm is a StatefulWidget that displays a loan application form.
class LoanForm extends StatefulWidget {
  const LoanForm({Key? key}) : super(key: key);

  @override
  _LoanFormState createState() => _LoanFormState();
}

class _LoanFormState extends State<LoanForm> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  String _nationalId = '';
  int _loanAmount = 2500;
  int _loanPeriod = 36;
  int _loanAmountResult = 0;
  int _loanPeriodResult = 0;
  int _originalLoanAmount = 2500;
  int _originalLoanPeriod = 36;
  String _errorMessage = '';

  // Submit the form and update the state with the loan decision results.
  // Only submits if the form inputs are validated.
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _originalLoanAmount = _loanAmount;
      _originalLoanPeriod = _loanPeriod;

      final result = await _apiService.requestLoanDecision(
        _nationalId,
        _loanAmount,
        _loanPeriod,
      );

      setState(() {
        if (result['errorMessage'] != null && result['errorMessage']
            .toString()
            .isNotEmpty) {
          _errorMessage = result['errorMessage'].toString();
          _loanAmountResult = 0;
          _loanPeriodResult = 0;
        } else {
          _loanAmountResult = int.parse(result['loanAmount'].toString());
          _loanPeriodResult = int.parse(result['loanPeriod'].toString());
          _errorMessage = '';

          // ✅ Update slider positions to reflect approved values
          _loanAmount = _loanAmountResult;
          _loanPeriod = _loanPeriodResult;
        }
      });
    } else {
      setState(() {
        _loanAmountResult = 0;
        _loanPeriodResult = 0;
        _errorMessage = 'Please check your input values.';
      });
    }
  }

  // Builds the application form widget.
  // The widget automatically queries the endpoint for the latest data
  // when a field is changed.
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final formWidth = screenWidth / 3;
    const minWidth = 500.0;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: max(minWidth, formWidth),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FormField<String>(
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NationalIdTextFormField(
                            onChanged: (value) {
                              setState(() {
                                _nationalId = value ?? '';
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 60.0),
                  Text('Loan Amount: $_loanAmount €'),
                  const SizedBox(height: 8),
                  Slider.adaptive(
                    value: _loanAmount.toDouble(),
                    min: 2000,
                    max: 10000,
                    divisions: 80,
                    label: '$_loanAmount €',
                    activeColor: AppColors.secondaryColor,
                    onChanged: (double newValue) {
                      setState(() {
                        _loanAmount = ((newValue.floor() / 100).round() * 100);
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('2000€')),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('10000€'),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Text('Loan Period: $_loanPeriod months'),
                  const SizedBox(height: 8),
                  Slider.adaptive(
                    value: _loanPeriod.toDouble(),
                    min: 12,
                    max: 48,
                    divisions: 40,
                    label: '$_loanPeriod months',
                    activeColor: AppColors.secondaryColor,
                    onChanged: (double newValue) {
                      setState(() {
                        _loanPeriod = ((newValue.floor() / 6).round() * 6);
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('12 months')),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('48 months'),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              padding: const EdgeInsets.symmetric(
                  horizontal: 32.0, vertical: 12.0),
            ),
            child: const Text('Submit Application'),
          ),
          const SizedBox(height: 16.0),

          Column(
            children: [
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: errorMedium)
              else
                if (_loanAmountResult != 0)
                  Column(
                    children: [
                      Text('✅ Approved Loan Amount: $_loanAmountResult €'),
                      const SizedBox(height: 8.0),
                      Text('🕒 Approved Loan Period: $_loanPeriodResult months'),
                      if (_loanAmountResult != _originalLoanAmount ||
                          _loanPeriodResult != _originalLoanPeriod)
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            'Note: Your request was adjusted for approval.',
                            style: TextStyle(
                                fontSize: 12, color: Colors.orange),
                          ),
                        ),
                    ],
                  )
                else
                  const Text('Awaiting input...'),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';

import 'global.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? errortext;

  const CustomDatePicker({
    super.key,
    required this.controller,
    this.labelText = '',
    this.hintText = '',
    this.errortext = '',
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.textColor,
              onPrimary: Colors.white,
              surface: AppColors.mainColor,
              onSurface: AppColors.textColor,
            ),
            dialogBackgroundColor: Colors.blue[500],
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (newSelectedDate != null && newSelectedDate != _selectedDate) {
      setState(() {
        _selectedDate = newSelectedDate;
        widget.controller.text = DateFormat.yMMMd().format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: AlwaysDisabledFocusNode(),
      controller: widget.controller,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errortext,
        suffix: const Icon(
          TablerIcons.caret_down,
          color: Colors.black,
        ),
        border: const OutlineInputBorder(),
      ),
      onTap: () => _selectDate(context),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:task_manager/components/custom_date_picker.dart';
import 'package:task_manager/components/custom_time_picker.dart';
import 'package:task_manager/components/global.dart';

class AddTaskPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSave;

  const AddTaskPage({super.key, required this.onSave});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _datepicker = TextEditingController();
  final TextEditingController _timepicker = TextEditingController();

  String _repeatOption = "Once"; // Default selected option
  bool _showCustomDays = false;
  final Map<String, bool> _weekdays = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };

  String? _titleError;
  String? _datepickerError;
  String? _timepickerError;

  void _validateAndSave() {
    setState(() {
      // Validate Title
      _titleError = _title.text.trim().isEmpty ? 'required.' : null;

      // Validate Datepicker
      _datepickerError = _datepicker.text.trim().isEmpty ? 'required.' : null;

      // Validate Timepicker
      _timepickerError = _timepicker.text.trim().isEmpty ? 'required.' : null;
    });

    if (_titleError == null &&
        _datepickerError == null &&
        _timepickerError == null) {
      // Gather selected days for weekly repeat
      final selectedDays = _weekdays.entries
          .where((entry) => entry.value) // Get only selected days
          .map((entry) => entry.key) // Extract day names
          .toList();

      widget.onSave({
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'dueDate': _datepicker.text.trim(),
        'time': _timepicker.text.trim(),
        'repeat': _repeatOption,
        'selectedDays': _repeatOption == 'Weekly'
            ? selectedDays
            : null, // Add days for weekly
        'completed': false,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.black),
                const SizedBox(height: 8),
                const Text('Title'),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter title',
                    errorText: _titleError,
                  ),
                  controller: _title,
                ),
                const SizedBox(height: 8),
                const Text('Description'),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter description',
                  ),
                  controller: _description,
                  maxLines: 7,
                ),
                const SizedBox(height: 8),
                const Text('Repeat'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: ['Once', 'Daily', 'Weekly', 'Monthly']
                      .map(
                        (option) => ChoiceChip(
                          label: Text(
                            option,
                          ),
                          selected: _repeatOption == option,
                          checkmarkColor: AppColors.secondaryColor,
                          selectedColor: AppColors.mainColor,
                          onSelected: (selected) {
                            setState(() {
                              _repeatOption = option;
                              _showCustomDays = option == 'Weekly';
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                if (_showCustomDays) const SizedBox(height: 8),
                if (_showCustomDays)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Days'),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _weekdays.keys.map((day) {
                          return FilterChip(
                            label: Text(day),
                            selected: _weekdays[day]!,
                            onSelected: (selected) {
                              setState(() {
                                _weekdays[day] = selected;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomDatePicker(
                        controller: _datepicker,
                        labelText: 'Select due date',
                        errortext: _datepickerError,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTimePicker(
                        controller: _timepicker,
                        labelText: 'Time',
                        errortext: _timepickerError,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(TablerIcons.x),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: _validateAndSave, // Trigger validation
                      icon: const Icon(
                        TablerIcons.check,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

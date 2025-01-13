import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:task_manager/add_task.dart';
import 'package:task_manager/components/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];

  // Function to add a task
  void _addTask(Map<String, dynamic> task) {
    setState(() {
      tasks.add(task);
    });
  }

  // Function to remove a task
  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Function to mark a task as complete or remove it if already completed
  void _completeTask(int index) {
    final task = tasks[index];
    task['completed'] == true;
    {
      // Show dialog to confirm removal of already completed task
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        borderSide: const BorderSide(
          color: AppColors.mainColor,
          width: 2,
        ),
        buttonsBorderRadius: const BorderRadius.all(
          Radius.circular(2),
        ),
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: false,
        headerAnimationLoop: true,
        animType: AnimType.bottomSlide,
        title: 'Task Completed',
        desc: 'This task is already completed and will now be removed.',
        btnOkColor: AppColors.secondaryColor,
        btnOkOnPress: () {
          _removeTask(index);
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks added yet.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      task['title'],
                      style: const TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task['description'] ?? 'No description'),
                        const SizedBox(height: 8),
                        if (task['repeat'] == 'Weekly' &&
                            task['selectedDays'] != null)
                          Wrap(
                            spacing: 8.0, // Space between chips
                            children: List<Widget>.from(
                              task['selectedDays'].map<Widget>((day) {
                                return Chip(
                                  label: Text(
                                    day,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.secondaryColor,
                                );
                              }),
                            ),
                          )
                        else
                          Text('Repeat: ${task['repeat']}'),
                        Row(
                          spacing: 16,
                          children: [
                            Text('${task['dueDate']}'),
                            Text('${task['time']}'),
                          ],
                        )
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: AppColors.secondaryColor),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              borderSide: const BorderSide(
                                color: AppColors.mainColor,
                                width: 2,
                              ),
                              buttonsBorderRadius: const BorderRadius.all(
                                Radius.circular(2),
                              ),
                              dismissOnTouchOutside: true,
                              dismissOnBackKeyPress: false,
                              headerAnimationLoop: false,
                              animType: AnimType.bottomSlide,
                              title: 'Warning',
                              desc:
                                  'Are you sure you want to delete this task? This action cannot be undone.',
                              btnCancelColor: Colors.grey,
                              btnCancelOnPress: () {},
                              btnOkColor: AppColors.secondaryColor,
                              btnOkOnPress: () {
                                _removeTask(index);
                              },
                            ).show();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            task['completed'] == true
                                ? Icons.check_circle
                                : Icons.check,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            _completeTask(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 32),
        child: SizedBox(
          height: 70.0,
          width: 70.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddTaskPage(
                    onSave: (task) => _addTask(task),
                  ),
                );
              },
              child: const Icon(TablerIcons.plus),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

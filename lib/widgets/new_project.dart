import 'package:expense_tracker/fireStore_Services/category_service.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/firestore_services.dart';
import 'package:expense_tracker/models/project.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:expense_tracker/theme/sizes.dart';
import 'package:expense_tracker/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class NewProject extends StatefulWidget {
  final void Function(Project project) onAddProject;
  final String projectType;

  const NewProject({
    super.key,
    required this.onAddProject,
    required this.projectType,
  });

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  List<String> contributors = [];

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchContributors();
  }

  void _fetchContributors() async {
    final List<String> contributorsFromDb =
        await CategoryService(fireStoreService).getSenders();
    setState(() {
      contributors = contributorsFromDb;
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitProjectData() {
    if (_titleController.text.trim().isEmpty || _selectedDate == null) {
      UtilityFunctions().showInValidInputDialog(context);
      return;
    }
    final project = Project(
      id: uuid.v4(),
      title: _titleController.text,
      date: _selectedDate!,
      description: _descriptionController.text,
      projectType: widget.projectType,
    );

    widget.onAddProject(project);
    Navigator.pop(context);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          Text(
            'Create ${widget.projectType} Project',
            style: const TextStyle(
              fontSize: TSizes.fontSizeLg,
              color: TColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Selected'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            controller: _descriptionController,
            maxLength: 250,
            decoration: const InputDecoration(
              label: Text('Description'),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                        fontSize: TSizes.fontSizeLg,
                        color: TColors.black,
                      ))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: _submitProjectData,
                  child: const Text('Save Project',
                      style: TextStyle(
                        fontSize: TSizes.fontSizeSm,
                        color: TColors.white,
                      ))),
            ],
          )
        ],
      ),
    );
  }
}

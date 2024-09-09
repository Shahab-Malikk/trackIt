import 'package:expense_tracker/utils/validate_inputs.dart';
import 'package:flutter/material.dart';

Widget buildFormField(
    BuildContext context,
    Map<String, dynamic> field,
    Map<String, dynamic> formValues,
    void Function(String, dynamic) onValueChanged) {
  switch (field['type']) {
    case 'number':
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: field['label'],
            hintText: field['placeholder'],
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => onValueChanged(field['id'], value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      );
    case 'text':
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: field['label'],
            hintText: field['placeholder'],
          ),
          onChanged: (value) => onValueChanged(field['id'], value),
          keyboardType: field['type'] == 'email'
              ? TextInputType.emailAddress
              : TextInputType.text,
          validator: (value) =>
              validateField(field['id'], value, field['validator']),
        ),
      );
    case 'password':
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: field['label'],
            hintText: field['placeholder'],
          ),
          obscureText: true, // Explicitly set for password fields
          onChanged: (value) => onValueChanged(field['id'], value),
          validator: (value) =>
              validateField(field['id'], value, field['validator']),
        ),
      );
    case 'date':
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: field['label'],
            hintText: field['placeholder'],
          ),
          keyboardType: TextInputType.datetime,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            final pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );
            if (pickedDate != null) {
              onValueChanged(
                  field['id'], pickedDate.toLocal().toString().split(' ')[0]);
            }
          },
          readOnly: true,
        ),
      );

    case 'dropdown':
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: field['label'],
          ),
          value: formValues[field['id']],
          items: (field['options'] as List<dynamic>)
              .map<DropdownMenuItem<String>>(
                (dynamic option) => DropdownMenuItem(
                  value: option as String,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: (value) => onValueChanged(field['id'], value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
        ),
      );
    default:
      return SizedBox.shrink();
  }
}

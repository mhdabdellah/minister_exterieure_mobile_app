import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Step 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StepOneForm(),
    );
  }
}

class StepOneForm extends StatefulWidget {
  const StepOneForm({super.key});

  @override
  _StepOneFormState createState() => _StepOneFormState();
}

class _StepOneFormState extends State<StepOneForm> {
  final _formKey = GlobalKey<FormState>();

  // Create a text controller for each field
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _numberOfChildrenController =
      TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _birthCityController = TextEditingController();
  final TextEditingController _birthCountryController = TextEditingController();
  final TextEditingController _passportNumberController =
      TextEditingController();
  final TextEditingController _passportPlaceOfIssueController =
      TextEditingController();
  final TextEditingController _passportIssueDateController =
      TextEditingController();
  final TextEditingController _nationalIdNumberController =
      TextEditingController();
  final TextEditingController _nationalIdIssueDateController =
      TextEditingController();

  String _gender = 'M';
  final String _maritalStatus = 'Single';

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the
    // widget tree to free up resources.
    _lastNameController.dispose();
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _numberOfChildrenController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    _birthCityController.dispose();
    _birthCountryController.dispose();
    _passportNumberController.dispose();
    _passportPlaceOfIssueController.dispose();
    _passportIssueDateController.dispose();
    _nationalIdNumberController.dispose();
    _nationalIdIssueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1: Identity and Filiation'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _lastNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nom (Last Name)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                // ... More TextFormField widgets for each field
                // Gender Radio Buttons
                ListTile(
                  title: const Text('Male'),
                  leading: Radio<String>(
                    value: 'M',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Female'),
                  leading: Radio<String>(
                    value: 'F',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
                // ... Marital Status Radio Buttons or Dropdown
                // ... Other fields for the form
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a Snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        // Code to process the data input
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StepThreeForm extends StatefulWidget {
  const StepThreeForm({super.key});

  @override
  _StepThreeFormState createState() => _StepThreeFormState();
}

class _StepThreeFormState extends State<StepThreeForm> {
  final _formKey = GlobalKey<FormState>();

  // Define TextEditingControllers for each field
  final TextEditingController _spouseFullNameController =
      TextEditingController();
  final TextEditingController _spouseBirthDateController =
      TextEditingController();
  final TextEditingController _spouseBirthPlaceController =
      TextEditingController();
  final TextEditingController _spouseCityController = TextEditingController();
  final TextEditingController _spouseCountryController =
      TextEditingController();
  final TextEditingController _spouseNationalityController =
      TextEditingController();
  final TextEditingController _spouseIDNumberController =
      TextEditingController();
  final TextEditingController _spouseIDIssueDateController =
      TextEditingController();
  final TextEditingController _spousePhoneController = TextEditingController();
  final TextEditingController _currentOccupationController =
      TextEditingController();
  final TextEditingController _employerController = TextEditingController();
  final TextEditingController _studyPlaceController = TextEditingController();
  final TextEditingController _studyFieldController = TextEditingController();

  final String _educationLevel = 'Primary';
  final String _studentCycle = 'First Cycle';

  @override
  void dispose() {
    // Dispose controllers
    _spouseFullNameController.dispose();
    _spouseBirthDateController.dispose();
    _spouseBirthPlaceController.dispose();
    _spouseCityController.dispose();
    _spouseCountryController.dispose();
    _spouseNationalityController.dispose();
    _spouseIDNumberController.dispose();
    _spouseIDIssueDateController.dispose();
    _spousePhoneController.dispose();
    _currentOccupationController.dispose();
    _employerController.dispose();
    _studyPlaceController.dispose();
    _studyFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 3: Additional Details'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Spouse information fields
                TextFormField(
                  controller: _spouseFullNameController,
                  decoration: const InputDecoration(
                      labelText: 'Nom et prénom (Full name)'),
                  // Add other properties like keyboardType, validator, etc.
                ),
                // ... Other TextFormField widgets for each field
                // Education Level Radio Buttons
                // ... Implement radio buttons or dropdowns for education level
                // Current Occupation field
                TextFormField(
                  controller: _currentOccupationController,
                  decoration: const InputDecoration(
                      labelText: 'Profession Actuelle (Current Occupation)'),
                  // Add other properties like keyboardType, validator, etc.
                ),
                // ... More TextFormField widgets for Employer and Student Status
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate and process the form data
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

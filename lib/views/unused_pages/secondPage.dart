import 'package:flutter/material.dart';

class StepTwoForm extends StatefulWidget {
  const StepTwoForm({super.key});

  @override
  _StepTwoFormState createState() => _StepTwoFormState();
}

class _StepTwoFormState extends State<StepTwoForm> {
  final _formKey = GlobalKey<FormState>();

  // Define TextEditingControllers for each field
  final TextEditingController _entryDateController = TextEditingController();
  final TextEditingController _stayPermitExpiryController =
      TextEditingController();
  final TextEditingController _stayPermitNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _moroccoAddressController =
      TextEditingController();

  // This can be expanded to accommodate more statuses
  final List<String> _statusTypes = [
    'Etudes',
    'Salarie',
    'Profession liberale',
    'Enseignement',
    'Commerce',
    'Affaires',
    'Regroupement familial',
    'Autre'
  ];
  String _selectedStatus = 'Etudes';

  @override
  void dispose() {
    // Dispose controllers
    _entryDateController.dispose();
    _stayPermitExpiryController.dispose();
    _stayPermitNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _moroccoAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2: Status and Coordinates'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _entryDateController,
                  decoration: const InputDecoration(
                      labelText: 'Date d\'entrée au pays (Date of entry)'),
                  // Add other properties like keyboardType, validator, etc.
                ),
                // ... Other TextFormField widgets for each field
                DropdownButtonFormField(
                  value: _selectedStatus,
                  items: _statusTypes.map((String status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue.toString();
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Statut (Status)'),
                ),
                // ... More TextFormField widgets for COORDONNEES section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate and process the form data
                    },
                    child: const Text('Go to Step 3'),
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

import 'package:flutter/material.dart';
import '../models/location_data.dart';
import '../utils/app_theme.dart';
import '../widgets/location_picker.dart';

class FarmerRegistrationScreen extends StatefulWidget {
  const FarmerRegistrationScreen({super.key});

  @override
  State<FarmerRegistrationScreen> createState() =>
      _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  LocationData _location = const LocationData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: AgriColors.mintGreen.withValues(alpha: 0.2),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    'Location powers weather advisory, crop health alerts, '
                    'and buyer search by region.',
                    style: TextStyle(fontSize: 13, color: AgriColors.soilBrown),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 24),
              LocationPicker(
                title: 'Farmer Location',
                onChanged: (loc) => setState(() => _location = loc),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  final locError = validateLocation(_location);
                  if (!_formKey.currentState!.validate() || locError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(locError ?? 'Please complete the form'),
                        backgroundColor: AgriColors.dangerRed,
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Farmer registered in ${_location.town}, '
                        '${_location.region}',
                      ),
                      backgroundColor: AgriColors.forestGreen,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Register Farmer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

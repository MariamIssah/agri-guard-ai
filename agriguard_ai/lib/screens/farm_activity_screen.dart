import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FarmActivityScreen extends StatefulWidget {
  const FarmActivityScreen({super.key});

  @override
  State<FarmActivityScreen> createState() => _FarmActivityScreenState();
}

class _FarmActivityScreenState extends State<FarmActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _currentStage;
  DateTime? _plantingDate;
  DateTime? _harvestDate;

  static const _stages = [
    'Land Preparation',
    'Planting',
    'Vegetative Growth',
    'Flowering',
    'Harvest Ready',
  ];

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _pickDate(bool isPlanting) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AgriColors.forestGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AgriColors.soilBrown,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isPlanting) {
          _plantingDate = picked;
        } else {
          _harvestDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Activity Tracking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _dateField(
                label: 'Planting Date',
                value: _formatDate(_plantingDate),
                onTap: () => _pickDate(true),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _currentStage,
                decoration: const InputDecoration(
                  labelText: 'Crop Stage',
                  prefixIcon: Icon(Icons.timeline_rounded),
                ),
                items: _stages
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _currentStage = v),
                validator: (v) => v == null ? 'Select crop stage' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Fertilizer Applied',
                  prefixIcon: Icon(Icons.science_outlined),
                  hintText: 'e.g. NPK 15-15-15',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter fertilizer applied' : null,
              ),
              const SizedBox(height: 14),
              _dateField(
                label: 'Expected Harvest Date',
                value: _formatDate(_harvestDate),
                onTap: () => _pickDate(false),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_plantingDate == null || _harvestDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select both dates'),
                          backgroundColor: AgriColors.dangerRed,
                        ),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Activity recorded successfully!'),
                        backgroundColor: AgriColors.forestGreen,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: value == 'Select date'
                ? AgriColors.soilBrown.withValues(alpha: 0.5)
                : AgriColors.soilBrown,
          ),
        ),
      ),
    );
  }
}

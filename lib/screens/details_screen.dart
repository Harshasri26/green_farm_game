import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../services/local_storage.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _cropController = TextEditingController();
  final _farmSizeController = TextEditingController();
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, String>) {
        _nameController.text = args['name'] ?? '';
        _locationController.text = args['location'] ?? '';
        _cropController.text = args['crop'] ?? '';
        _farmSizeController.text = args['farmSize'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _cropController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();
    final crop = _cropController.text.trim();
    final farmSize = _farmSizeController.text.trim();

    setState(() => _error = '');
    if (name.isEmpty) {
      setState(() => _error = l.get('name_required'));
      return;
    }
    if (location.isEmpty) {
      setState(() => _error = l.get('location_required'));
      return;
    }
    if (crop.isEmpty) {
      setState(() => _error = l.get('crop_required'));
      return;
    }

    setState(() {
      _error = '';
      _loading = true;
    });

    await LocalStorage.saveProfile({
      'name': name,
      'location': location,
      'crop': crop,
      'farmSize': farmSize,
    });

    if (!mounted) return;
    setState(() => _loading = false);
    final isEditing = ModalRoute.of(context)?.settings.arguments != null;
    if (isEditing) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(l.get('your_details')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.get('complete_before_dashboard'),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l.get('name'),
                hintText: l.get('name_hint'),
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: l.get('location'),
                hintText: l.get('location_hint'),
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cropController,
              decoration: InputDecoration(
                labelText: l.get('crop'),
                hintText: l.get('crop_hint'),
                prefixIcon: const Icon(Icons.agriculture),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _farmSizeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l.get('farm_size'),
                hintText: l.get('farm_size_hint'),
                prefixIcon: const Icon(Icons.landscape),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l.get('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

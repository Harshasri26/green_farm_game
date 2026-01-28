import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../services/local_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> _profile = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAndLoad();
  }

  Future<void> _checkAndLoad() async {
    setState(() => _loading = true);
    final complete = await LocalStorage.isProfileComplete();
    if (!mounted) return;
    if (!complete) {
      Navigator.pushReplacementNamed(context, '/details');
      return;
    }
    final p = await LocalStorage.getProfile();
    if (!mounted) return;
    setState(() {
      _profile = p;
      _loading = false;
    });
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBox(String title, String message, IconData icon) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(l.get('profile')),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(l.get('profile')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.person,
                  size: 45,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _profile['name'] ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _infoChip(
                    Icons.location_on,
                    _profile['location'] ?? '',
                  ),
                  _infoChip(
                    Icons.agriculture,
                    _profile['crop'] ?? '',
                  ),
                  if ((_profile['farmSize'] ?? '').isNotEmpty)
                    _infoChip(
                      Icons.landscape,
                      '${_profile['farmSize']} ${l.get('acres')}',
                    ),
                ],
              ),
              const SizedBox(height: 25),
              _messageBox(
                l.get('today_mission'),
                l.get('today_mission_msg'),
                Icons.task_alt,
              ),
              _messageBox(
                l.get('reward'),
                l.get('reward_msg'),
                Icons.stars,
              ),
              _messageBox(
                l.get('reminder'),
                l.get('reminder_msg'),
                Icons.notifications,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  icon: const Icon(Icons.agriculture),
                  label: Text(l.get('go_to_farm')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.pushNamed<void>(
                    context,
                    '/details',
                    arguments: _profile,
                  );
                  if (!mounted) return;
                  _checkAndLoad();
                },
                child: Text(l.get('edit_profile')),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../localization/app_localizations.dart';
import '../services/local_storage.dart';
import '../services/task_service.dart';
import '../services/xp_streak_service.dart';
import '../services/sustainability_service.dart';
import '../services/notification_service.dart';
import '../models/task.dart';
import '../models/user_progress.dart';
import '../widgets/xp_streak_widget.dart';
import '../widgets/streak_widget.dart';
import '../widgets/sustainability_score_widget.dart';
import '../widgets/task_card.dart';
import 'task_submission_screen.dart';
import 'leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  final TaskService _taskService = TaskService();
  final XpStreakService _xpStreakService = XpStreakService();
  final SustainabilityService _sustainabilityService = SustainabilityService();
  final NotificationService _notificationService = NotificationService();

  List<Task> _tasks = [];
  UserProgress _userProgress = UserProgress(userId: '');
  bool _showStreakBreakAlert = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _checkProfile();
    await _notificationService.initialize();
    await _notificationService.scheduleDailyTaskReminder();
    await _notificationService.scheduleStreakBreakAlert();
    await _loadData();
    _checkStreakBreak();
  }

  Future<void> _checkProfile() async {
    final complete = await LocalStorage.isProfileComplete();
    if (!mounted) return;
    if (!complete) {
      Navigator.pushReplacementNamed(context, '/details');
      return;
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    final tasks = await _taskService.getDailyTasks();
    final progress = await _xpStreakService.getUserProgress();

    // Check which tasks are completed
    for (var task in tasks) {
      final isCompleted = await _taskService.isTaskCompleted(task.id);
      if (isCompleted) {
        task = Task(
          id: task.id,
          title: task.title,
          description: task.description,
          xpReward: task.xpReward,
          sustainabilityPoints: task.sustainabilityPoints,
          createdAt: task.createdAt,
          isCompleted: true,
        );
      }
    }

    if (mounted) {
      setState(() {
        _tasks = tasks;
        _userProgress = progress;
        _loading = false;
      });
    }
  }

  Future<void> _checkStreakBreak() async {
    final hasNotification = await _xpStreakService.hasStreakBreakNotification();
    if (hasNotification && mounted) {
      setState(() => _showStreakBreakAlert = true);
      _showStreakBreakDialog();
    }
  }

  void _showStreakBreakDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Streak Broken! 🔥'),
        content: const Text('Your streak has been broken. Start a new one today!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _showStreakBreakAlert = false);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTaskSubmission(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskSubmissionScreen(task: task),
      ),
    );

    if (result == true) {
      await _loadData();
      _checkAchievements();
    }
  }

  Future<void> _checkAchievements() async {
    final progress = await _xpStreakService.getUserProgress();
    final achievements = <String>[];

    if (progress.currentStreak >= 7 && !progress.achievements.contains('week_streak')) {
      achievements.add('7 Day Streak!');
      await _notificationService.showAchievementNotification('7 Day Streak!');
    }
    if (progress.totalXP >= 1000 && !progress.achievements.contains('xp_1000')) {
      achievements.add('1000 XP Master!');
      await _notificationService.showAchievementNotification('1000 XP Master!');
    }
    if (progress.sustainabilityScore >= 500 && !progress.achievements.contains('sustainability_500')) {
      achievements.add('Sustainability Champion!');
      await _notificationService.showAchievementNotification('Sustainability Champion!');
    }

    if (achievements.isNotEmpty) {
      _showAchievementDialog(achievements);
    }
  }

  void _showAchievementDialog(List<String> achievements) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber),
            SizedBox(width: 8),
            Text('Achievement Unlocked!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: achievements
              .map((achievement) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(achievement),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Awesome!'),
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
        appBar: AppBar(
          title: Text(l.get('green_farm')),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.get('green_farm')),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LeaderboardScreen(),
              ),
            ),
            tooltip: l.get('leaderboard'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: l.get('profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              XpStreakWidget(
                xp: _userProgress.totalXP,
                streak: _userProgress.currentStreak,
                sustainabilityScore: _userProgress.sustainabilityScore,
              ),
              StreakWidget(
                currentStreak: _userProgress.currentStreak,
                longestStreak: _userProgress.longestStreak,
              ),
              SustainabilityScoreWidget(
                score: _userProgress.sustainabilityScore,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l.get('today_mission'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              ..._tasks.map((task) => TaskCard(
                    task: task,
                    isCompleted: task.isCompleted,
                    onCameraSubmit: task.isCompleted
                        ? null
                        : () => _handleTaskSubmission(task),
                    onVoiceSubmit: task.isCompleted
                        ? null
                        : () => _handleTaskSubmission(task),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

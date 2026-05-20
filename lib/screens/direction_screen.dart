import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../utils/learning_direction.dart';
import 'home_screen.dart';

class DirectionScreen extends StatelessWidget {
  const DirectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('K-Viet Talk')),
      body: SafeArea(
        child: appState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Học tiếng Hàn',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Ứng dụng hiện mở thẳng vào chế độ học tiếng Hàn cho người Việt.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _DirectionButton(
                      icon: Icons.translate,
                      title: 'Bắt đầu học tiếng Hàn',
                      onTap: () => _openHome(
                        context,
                        LearningDirection.vietnameseToKorean,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _openHome(BuildContext context, LearningDirection direction) {
    context.read<AppState>().selectDirection(direction);

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }
}

class _DirectionButton extends StatelessWidget {
  const _DirectionButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: Icon(icon),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(title),
      ),
      onPressed: onTap,
    );
  }
}

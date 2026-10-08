import 'package:flutter/material.dart';
import '../app/app_theme.dart';

class HistoryState extends StatelessWidget {
  const HistoryState({
    super.key,
    this.loading = false,
    this.error = '',
    this.filtered = false,
    required this.onRetry,
  });
  final bool loading;
  final bool filtered;
  final String error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: loading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_florist_outlined,
                  size: 48,
                  color: AppColors.leaf,
                ),
                const SizedBox(height: 12),
                Text(
                  error.isNotEmpty
                      ? error
                      : filtered
                      ? 'No matching plants.'
                      : 'No plants yet. Scan your first photo!',
                  textAlign: TextAlign.center,
                ),
                if (error.isNotEmpty)
                  TextButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ),
    ),
  );
}

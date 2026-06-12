import 'package:flutter/material.dart';

class IllustrationPlaceholder extends StatelessWidget {
  const IllustrationPlaceholder({
    super.key,
    required this.icon,
    this.assetPath,
    this.size = 56,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String? assetPath;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: assetPath == null
            ? _IconFallback(
                icon: icon,
                backgroundColor:
                    backgroundColor ?? colorScheme.secondaryContainer,
                foregroundColor:
                    foregroundColor ?? colorScheme.onSecondaryContainer,
              )
            : Image.asset(
                assetPath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _IconFallback(
                  icon: icon,
                  backgroundColor:
                      backgroundColor ?? colorScheme.secondaryContainer,
                  foregroundColor:
                      foregroundColor ?? colorScheme.onSecondaryContainer,
                ),
              ),
      ),
    );
  }
}

class _IconFallback extends StatelessWidget {
  const _IconFallback({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Icon(icon, color: foregroundColor),
    );
  }
}

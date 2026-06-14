import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/word.dart';

class WordImageWidget extends StatelessWidget {
  const WordImageWidget({
    super.key,
    required this.word,
    this.height,
    this.width,
    this.size,
    this.icon = Icons.image_outlined,
  });

  final Word word;
  final double? height;
  final double? width;
  final double? size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveHeight = size ?? height ?? 160;
    final effectiveWidth = size ?? width ?? double.infinity;

    return FutureBuilder<String?>(
      future: _WordImageAssetResolver.resolve(word),
      builder: (context, snapshot) {
        final assetPath = snapshot.data;
        final image = assetPath == null
            ? null
            : Image.asset(
                assetPath,
                height: effectiveHeight,
                width: effectiveWidth,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _Placeholder(
                  height: effectiveHeight,
                  width: effectiveWidth,
                  icon: icon,
                ),
              );

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              image ??
              _Placeholder(
                height: effectiveHeight,
                width: effectiveWidth,
                icon: icon,
                backgroundColor: colorScheme.surfaceContainerHighest,
                foregroundColor: colorScheme.onSurfaceVariant,
              ),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({
    required this.height,
    required this.width,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final double height;
  final double width;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      color: backgroundColor ?? colorScheme.surfaceContainerHighest,
      child: Icon(
        icon,
        size: (height * 0.36).clamp(22, 54).toDouble(),
        color: foregroundColor ?? colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _WordImageAssetResolver {
  static Future<Set<String>>? _assetPathsFuture;

  static Future<String?> resolve(Word word) async {
    final assetPaths = await _assetPaths();

    for (final candidate in _imageCandidates(word)) {
      if (assetPaths.contains(candidate)) {
        return candidate;
      }
    }

    return null;
  }

  static Future<Set<String>> _assetPaths() {
    return _assetPathsFuture ??= rootBundle
        .loadString('AssetManifest.json')
        .then(
          (value) => (jsonDecode(value) as Map<String, dynamic>).keys.toSet(),
        );
  }

  static Iterable<String> _imageCandidates(Word word) sync* {
    final explicitPath = word.resolvedImagePath;
    if (explicitPath != null && explicitPath.isNotEmpty) {
      yield explicitPath;
    }

    final folder = _categoryFolder(word.category);
    final fileName = _safeFileName(word.korean);
    yield 'assets/images/words/$folder/$fileName.png';
    yield 'assets/images/words/$folder/$fileName.jpg';
    yield 'assets/images/words/$folder/$fileName.webp';
  }

  static String _categoryFolder(String category) {
    switch (category) {
      case '음식':
      case '식당':
      case 'food':
      case 'restaurant':
        return 'food';
      case '음료':
        return 'drink';
      case '집':
        return 'home';
      case '학교':
      case 'school':
        return 'school';
      case '병원':
      case '약국':
      case 'hospital':
        return 'hospital';
      case '쇼핑':
      case 'shopping':
        return 'shopping';
      case '여행':
      case 'travel':
        return 'travel';
      case '공항':
        return 'airport';
      case '호텔':
        return 'hotel';
      case '회사':
      case '일':
      case 'work':
        return 'company';
      case '한국생활':
        return 'korea_life';
      default:
        return 'common';
    }
  }

  static String _safeFileName(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
  }
}

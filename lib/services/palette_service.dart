import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteService {
  /// Creates a smaller, square Unsplash variant for faster palette extraction.
  String _thumbUrl(String url) {
    final hasQuery = Uri.tryParse(url)?.hasQuery ?? false;
    final sep = hasQuery ? '&' : '?';
    return '$url${sep}w=512&h=512&fit=crop';
  }

  Future<Color?> extractDominant(String url) async {
    try {
      final provider = NetworkImage(_thumbUrl(url)); // NetworkImage is best for palette_generator
      final palette = await PaletteGenerator.fromImageProvider(
        provider,
        maximumColorCount: 20,
        timeout: const Duration(seconds: 10),
      );
      return palette.dominantColor?.color ??
          palette.vibrantColor?.color ??
          palette.darkVibrantColor?.color ??
          palette.lightMutedColor?.color;
    } catch (_) {
      return null; // Upstream will fall back to theme-aware color
    }
  }
}

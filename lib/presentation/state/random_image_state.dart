import 'package:flutter/material.dart';
import '../../domain/entities/remote_image.dart';

sealed class RandomImageState {
  const RandomImageState();
}

class RandomImageInitial extends RandomImageState {
  const RandomImageInitial();
}

class RandomImageLoading extends RandomImageState {
  const RandomImageLoading({this.previousImage, this.background});
  final RemoteImage? previousImage;
  final Color? background;
}

class RandomImageReady extends RandomImageState {
  const RandomImageReady({required this.image, required this.background});
  final RemoteImage image;
  final Color background;
}

class RandomImageError extends RandomImageState {
  const RandomImageError({required this.message, this.background});
  final String message;
  final Color? background;
}

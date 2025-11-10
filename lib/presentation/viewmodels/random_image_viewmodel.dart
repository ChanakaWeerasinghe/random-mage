import 'package:flutter/material.dart';
import '../../core/result.dart';
import '../../data/image_repository.dart';
import '../../domain/entities/remote_image.dart';
import '../../services/palette_service.dart';
import '../state/random_image_state.dart';

class RandomImageViewModel extends ChangeNotifier {
  final ImageRepository _repo;
  final PaletteService _palette;

  RandomImageState _state = const RandomImageInitial();
  RandomImageState get state => _state;

  RandomImageViewModel(this._repo, this._palette);

  Future<void> loadInitial(BuildContext context) async {
    if (_state is! RandomImageInitial) return;
    await fetchAnother(context);
  }

  Future<void> fetchAnother(BuildContext context) async {
    final previous = _state is RandomImageReady
        ? (_state as RandomImageReady).image
        : null;
    final bg = _currentBgOrThemeFallback(context);

    _state = RandomImageLoading(previousImage: previous, background: bg);
    notifyListeners();

    final result = await _repo.fetchRandomImage();
    await result.when(
      ok: (image) async {
        final color = await _palette.extractDominant(image.url) ?? _themeFallback(context);
        _state = RandomImageReady(image: image, background: color);
        notifyListeners();
      },
      err: (error, _) async {
        final message = _friendlyMessage(error);
        _state = RandomImageError(message: message, background: bg);
        notifyListeners();
      },
    );
  }

  Color _currentBgOrThemeFallback(BuildContext context) {
    if (_state is RandomImageReady) return (_state as RandomImageReady).background;
    if (_state is RandomImageLoading) {
      return (_state as RandomImageLoading).background ?? _themeFallback(context);
    }
    if (_state is RandomImageError) {
      return (_state as RandomImageError).background ?? _themeFallback(context);
    }
    return _themeFallback(context);
  }

  Color _themeFallback(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark ? Colors.grey[900]! : Colors.grey[200]!;
  }

  String _friendlyMessage(Object error) {
    final raw = error.toString();
    if (raw.contains('Network error')) return 'Network error — please check your connection.';
    if (raw.contains('timed out')) return 'Request timed out. Try again.';
    if (raw.contains('Server error')) return 'Server error. Please try again shortly.';
    if (raw.contains('format')) return 'Unexpected response from the server.';
    return 'Something went wrong. Please try again.';
  }
}

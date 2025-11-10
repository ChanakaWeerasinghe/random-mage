import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/remote_image.dart';
import '../state/random_image_state.dart';
import '../viewmodels/random_image_viewmodel.dart';

class RandomImagePage extends StatefulWidget {
  final RandomImageViewModel viewModel;
  const RandomImagePage({super.key, required this.viewModel});

  @override
  State<RandomImagePage> createState() => _RandomImagePageState();
}

class _RandomImagePageState extends State<RandomImagePage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onVm);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadInitial(context);
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onVm);
    super.dispose();
  }

  void _onVm() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final bg = switch (state) {
      RandomImageReady s => s.background,
      RandomImageLoading s => s.background ?? _fallback(context),
      RandomImageError s => s.background ?? _fallback(context),
      _ => _fallback(context),
    };

    return Semantics(
      label: 'Random image viewer screen',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        color: bg,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SquareImageArea(state: state),
                      const SizedBox(height: 16),
                      Semantics(
                        button: true,
                        label: 'Load another image',
                        child: FilledButton.icon(
                          onPressed: state is RandomImageLoading
                              ? null
                              : () => widget.viewModel.fetchAnother(context),
                          icon: state is RandomImageLoading
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Icon(Icons.refresh),
                          label: const Text('Another'),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      if (state is RandomImageError) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => widget.viewModel.fetchAnother(context),
                          icon: const Icon(Icons.replay),
                          label: const Text('Retry'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _fallback(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark ? Colors.grey[900]! : Colors.grey[200]!;
  }
}

class _SquareImageArea extends StatelessWidget {
  final RandomImageState state;
  const _SquareImageArea({required this.state});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Keep it square, avoid vertical overflow on short screens
      final screen = MediaQuery.of(context).size;
      final maxSquareSide = screen.height * 0.6;
      final side = constraints.maxWidth.clamp(0, maxSquareSide).toDouble();

      final image = switch (state) {
        RandomImageReady s => s.image,
        RandomImageLoading s => s.previousImage,
        _ => null,
      };

      return Semantics(
        image: true,
        label: 'Random image from Unsplash',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: SizedBox(
              key: ValueKey(image?.url),
              width: side,
              height: side,
              child: _buildContent(image),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContent(RemoteImage? image) {
    if (image == null && state is RandomImageLoading) {
      return const _SkeletonSquare();
    }
    if (image == null) {
      return const _SkeletonSquare();
    }
    return CachedNetworkImage(
      imageUrl: image.url,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 350),
      placeholderFadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => const _SkeletonSquare(),
      errorWidget: (context, url, error) => Container(
        color: Colors.black12,
        child: const Center(child: Icon(Icons.broken_image, size: 48)),
      ),
    );
  }
}

class _SkeletonSquare extends StatelessWidget {
  const _SkeletonSquare();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .3, end: .6),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, _) => DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(value),
        ),
      ),
    );
  }
}

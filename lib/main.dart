import 'package:flutter/material.dart';

import 'data/image_api.dart';
import 'data/image_repository.dart';
import 'presentation/pages/random_image_page.dart';
import 'presentation/viewmodels/random_image_viewmodel.dart';
import 'services/palette_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Very light DI for this tiny app
  final imageApi = ImageApi();
  final repo = ImageRepository(imageApi);
  final palette = PaletteService();
  final viewModel = RandomImageViewModel(repo, palette);

  runApp(RandomImageApp(viewModel: viewModel));
}

class RandomImageApp extends StatelessWidget {
  final RandomImageViewModel viewModel;
  const RandomImageApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Image',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: RandomImagePage(viewModel: viewModel),
    );
  }
}

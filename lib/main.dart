import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation.dart' as nav;
import 'providers.dart';
import 'theme.dart';
import 'ui/main_screen.dart';
import 'util/keyboard.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();
  final riverpodRootContainer = ProviderContainer();
  final assembledContainer = riverpodRootContainer;
  await riverpodRootContainer.read(basketProvider.notifier).reloadBasket();

  //release splash
  binding.allowFirstFrame();
  runApp(
    ProviderScope(
      parent: assembledContainer,
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      title: 'Блюда',
      onGenerateTitle: (context) => 'Блюда',
      scrollBehavior: const AppScrollBehavior(),
      themeMode: ThemeMode.light,
      theme: AppThemes.light,
      scaffoldMessengerKey: nav.scaffoldMessengerKey,
      builder: (context, child) => _Unfocus(child: child!),
      home: const MainScreen(),
    );
  }
}

/// A widget that unfocus everything when tapped.
///
/// This implements the "Unfocus when tapping in empty space" behavior for the
/// entire application.
class _Unfocus extends StatelessWidget {
  final Widget child;

  const _Unfocus({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: Keyboard.hide,
      child: child,
    );
  }
}

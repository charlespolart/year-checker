import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cells_provider.dart';
import 'providers/language_provider.dart';
import 'providers/legends_provider.dart';
import 'providers/pages_provider.dart';
import 'screens/login_screen.dart';
import 'screens/page_list_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/dotted_background.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DianDianApp());
}

class DianDianApp extends StatelessWidget {
  const DianDianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => PagesProvider()),
        ChangeNotifierProvider(create: (_) => CellsProvider()),
        ChangeNotifierProvider(create: (_) => LegendsProvider()),
      ],
      child: MaterialApp(
        title: 'Dian Dian',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        home: const _AppShell(),
      ),
    );
  }
}

/// Root shell that draws the dotted background and switches between
/// loading, login, and home screens based on authentication state.
class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return DottedBackground(
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const _LoadingScreen();
          }
          if (!auth.isAuthenticated) {
            return const LoginScreen();
          }
          return const PageListScreen();
        },
      ),
    );
  }
}

/// Simple loading state shown while restoring a session.
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '\u70B9\u70B9',
              style: AppFonts.pixel(fontSize: 36, color: AppColors.title),
            ),
            const SizedBox(height: 8),
            Text(
              'Dian Dian',
              style: AppFonts.pixel(fontSize: 14, color: AppColors.subtitle),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

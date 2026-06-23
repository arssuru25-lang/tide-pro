import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/notification_service.dart';
import 'firebase_options.dart';
import 'theme/tide_colors.dart';
import 'theme/theme_provider.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

await NotificationService.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const TideApp(),
    ),
  );
}

class TideApp extends StatelessWidget {
  const TideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            brightness: Brightness.light,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor:
                TideColors.darkSurface,
            textTheme: GoogleFonts.poppinsTextTheme(
              ThemeData.dark().textTheme,
            ),
          ),

          themeMode: themeProvider.isDark
              ? ThemeMode.dark
              : ThemeMode.light,

          home: const WelcomeScreen(),
        );
      },
    );
  }
}
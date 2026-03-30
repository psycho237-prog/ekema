import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/procedure_provider.dart';
import 'presentation/providers/voice_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/dialogue_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/document_generator_screen.dart';

import 'presentation/providers/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProcedureProvider()..init()),
        ChangeNotifierProvider(create: (_) => VoiceProvider()..init()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const EkemaApp(),
    ),
  );
}

class EkemaApp extends StatelessWidget {
  const EkemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return MaterialApp(
      title: 'EKEMA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/dialogue': (context) => const DialogueScreen(),
        '/result': (context) => const ResultScreen(),
        '/document-generator': (context) => const DocumentGeneratorScreen(),
      },
    );
  }
}

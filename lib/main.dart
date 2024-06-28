import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'injection_container.dart' as di;
import 'features/welcome/presentation/pages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart'; // Ensure this is imported
import 'firebase_options.dart'; // Ensure this is imported
import 'features/settings/data/services/notification_service.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/settings/domain/entities/settings.dart';
import 'features/notes/domain/entities/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteTypeAdapter());
  await Hive.openBox<Settings>('settingsBox');
  await Hive.openBox<Note>('notesBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();

  await di.init();
  runApp(ProviderScope(child: ChemApp()));
}

class ChemApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'ChemBuddy',
      theme: settings.theme == 'Light' ? ThemeData.light() : ThemeData.dark(),
      locale: locale,
      supportedLocales: [
        Locale('en'),
        Locale('pl'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: WelcomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/settings_provider.dart';
import '../../data/services/notification_service.dart';
import 'package:chem_buddy/l10n/app_localizations.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as custom_date_picker;

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final localizations = AppLocalizations.of(context);

    // Define the available languages
    final languages = [
      DropdownMenuItem(value: 'en', child: Text('English')),
      DropdownMenuItem(value: 'pl', child: Text('Polish')),
    ];

    // Define the available themes
    final themes = [
      DropdownMenuItem(value: 'Light', child: Text('Light')),
      DropdownMenuItem(value: 'Dark', child: Text('Dark')),
    ];

    print('Current language setting: ${settings.language}');
    print('Available languages: ${languages.map((e) => e.value).toList()}');

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(localizations.translate('language')),
              trailing: DropdownButton<String>(
                value: settings.language,
                onChanged: (value) {
                  if (value != null) {
                    print('Language selected: $value');
                    ref.read(settingsProvider.notifier).updateLanguage(value);
                  }
                },
                items: languages,
              ),
            ),
            ListTile(
              title: Text(localizations.translate('theme')),
              trailing: DropdownButton<String>(
                value: settings.theme,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsProvider.notifier).updateTheme(value);
                  }
                },
                items: themes,
              ),
            ),

            ElevatedButton(
              onPressed: () {
                custom_date_picker.DatePicker.showDateTimePicker(context, showTitleActions: true, onConfirm: (date) {
                  NotificationService.scheduleNotification(
                    title: localizations.translate('reminder_title'),
                    body: localizations.translate('reminder_body')
                  );
                }, currentTime: DateTime.now(), locale: custom_date_picker.LocaleType.en);
              },
              child: Text(localizations.translate('set_reminder')),
            ),
          ],
        ),
      ),
    );
  }
}

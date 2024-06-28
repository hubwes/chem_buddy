import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/settings.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<Settings> {
  final Box<Settings> settingsBox;

  SettingsNotifier()
      : settingsBox = Hive.box<Settings>('settingsBox'),
        super(Hive.box<Settings>('settingsBox').get('settings') ??
          Settings(
              language: 'en',
              theme: 'Light',
              notificationsEnabled: true)
        );

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
    settingsBox.put('settings', state);
  }

  void updateTheme(String theme) {
    state = state.copyWith(theme: theme);
    settingsBox.put('settings', state);
  }

  void toggleNotifications(bool isEnabled) {
    state = state.copyWith(notificationsEnabled: isEnabled);
    settingsBox.put('settings', state);
  }
}

final localeProvider = Provider<Locale>((ref) {
  final languageCode = ref.watch(settingsProvider).language;
  return Locale(languageCode);
});
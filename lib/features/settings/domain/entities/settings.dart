import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings {
  @HiveField(0)
  final String language;
  @HiveField(1)
  final String theme;
  @HiveField(2)
  final bool notificationsEnabled;

  Settings({
    required this.language,
    required this.theme,
    required this.notificationsEnabled,
  });

  Settings copyWith({
    String? language,
    String? theme,
    bool? notificationsEnabled,
  }) {
    return Settings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

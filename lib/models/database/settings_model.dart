import 'dart:convert';

class Settings {
  Settings({
    this.lastUpdatedAt,
    this.enableNotifications = false,
    this.focusMinutes = 25,
    this.shortPauseMinutes = 5,
    this.longPauseMinutes = 15,
    this.preventDisplayFromGoingToSleep = false,
  });

  factory Settings.fromMap(Map<String, dynamic> json) {
    return Settings(
      lastUpdatedAt: DateTime.tryParse(json['lastUpdatedAt'] as String? ?? ''),
      enableNotifications: json['enableNotifications'] as bool,
      focusMinutes: json['focusMinutes'] as int,
      longPauseMinutes: json['longPauseMinutes'] as int,
      preventDisplayFromGoingToSleep:
          json['preventDisplayFromGoingToSleep'] as bool,
      shortPauseMinutes: json['shortPauseMinutes'] as int,
    );
  }

  factory Settings.fromString(String? value) {
    if (value != null) {
      return Settings.fromMap(jsonDecode(value) as Map<String, dynamic>);
    }
    return Settings();
  }

  DateTime? lastUpdatedAt;
  bool enableNotifications;
  int focusMinutes;
  int shortPauseMinutes;
  int longPauseMinutes;
  bool preventDisplayFromGoingToSleep;

  Map<String, dynamic> toMap() {
    return {
      'lastUpdatedAt': lastUpdatedAt.toString(),
      'enableNotifications': enableNotifications,
      'focusMinutes': focusMinutes,
      'shortPauseMinutes': shortPauseMinutes,
      'longPauseMinutes': longPauseMinutes,
      'preventDisplayFromGoingToSleep': preventDisplayFromGoingToSleep
    };
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

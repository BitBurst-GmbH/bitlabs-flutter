enum WidgetType {
  simple,
  compact,
  fullWidth,
  leaderboard,
}

extension WidgetTypeExtension on WidgetType {
  String get name {
    switch (this) {
      case WidgetType.simple:
        return 'simple';
      case WidgetType.compact:
        return 'compact';
      case WidgetType.fullWidth:
        return 'full-width';
      case WidgetType.leaderboard:
        return 'leaderboard';
    }
  }
}

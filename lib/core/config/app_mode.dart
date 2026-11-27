/// Controls whether the app talks to real services or uses bundled demo data.
enum AppMode {
  demo,
  live;

  bool get isDemo => this == AppMode.demo;
  bool get isLive => this == AppMode.live;
}

extension AppModeLabel on AppMode {
  String get label => isDemo ? 'DEMO' : 'LIVE';

  String get description => isDemo
      ? 'Simulated data and local flows. No live orders are placed.'
      : 'Connected to approved production services.';
}

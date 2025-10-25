class AppConstants {
  static final AppConstants _instance = AppConstants._internal();
  factory AppConstants() => _instance;
  AppConstants._internal();

  final String appName = "Social Media";
  final String usersCollection = "appUsers";
  final String postsCollection = "posts";
}

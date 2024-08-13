class FirebasePackHandler {
  static FirebasePackHandler ?_instance;

  FirebasePackHandler._internal();

  static FirebasePackHandler getInstance() {
    _instance ??= FirebasePackHandler._internal();
    return _instance!;
  }
}
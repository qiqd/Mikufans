class AAFunData {
  final String encryptedUrl;
  final String sessionKey;

  AAFunData({required this.encryptedUrl, required this.sessionKey});

  @override
  String toString() {
    return 'AAFunData{encryptedUrl: $encryptedUrl, sessionKey: $sessionKey}';
  }
}

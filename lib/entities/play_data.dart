class PlayerData {
  final String? url;
  final String? urlNext;
  final String? currentUrl;

  PlayerData({this.url, this.urlNext, this.currentUrl});

  @override
  String toString() {
    return 'PlayerData{url: $url, urlNext: $urlNext}';
  }
}

class DetailItem {
  String? title;
  String? url;

  DetailItem({this.title, this.url});

  @override
  String toString() {
    return 'DetailItem{title: $title, url: $url}';
  }
}

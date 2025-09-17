class SearchItem {
  String? title;
  String? url;

  SearchItem({this.title, this.url});

  @override
  String toString() {
    return 'SearchItem{title: $title, url: $url}';
  }
}

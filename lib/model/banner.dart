class WingooBanner {
  final String id;
  final String imageUrl;
  final String linkUrl;
  final bool internalLink;

  const WingooBanner(this.id, this.imageUrl, this.linkUrl, this.internalLink);

  WingooBanner.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageUrl = json['imageUrl'],
        linkUrl = json['linkUrl'],
        internalLink = json['internalLink'];
}

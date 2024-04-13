class TiktokVid {
  String? version;
  String? type;
  String? title;
  String? authorUrl;
  String? authorName;
  String? width;
  String? height;
  String? html;
  int? thumbnailWidth;
  int? thumbnailHeight;
  String? thumbnailUrl;
  String? providerUrl;
  String? providerName;

  TiktokVid(
      {this.version,
        this.type,
        this.title,
        this.authorUrl,
        this.authorName,
        this.width,
        this.height,
        this.html,
        this.thumbnailWidth,
        this.thumbnailHeight,
        this.thumbnailUrl,
        this.providerUrl,
        this.providerName});

  TiktokVid.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    type = json['type'];
    title = json['title'];
    authorUrl = json['author_url'];
    authorName = json['author_name'];
    width = json['width'];
    height = json['height'];
    html = json['html'];
    thumbnailWidth = json['thumbnail_width'];
    thumbnailHeight = json['thumbnail_height'];
    thumbnailUrl = json['thumbnail_url'];
    providerUrl = json['provider_url'];
    providerName = json['provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['type'] = this.type;
    data['title'] = this.title;
    data['author_url'] = this.authorUrl;
    data['author_name'] = this.authorName;
    data['width'] = this.width;
    data['height'] = this.height;
    data['html'] = this.html;
    data['thumbnail_width'] = this.thumbnailWidth;
    data['thumbnail_height'] = this.thumbnailHeight;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['provider_url'] = this.providerUrl;
    data['provider_name'] = this.providerName;
    return data;
  }

  @override
  String toString() {
    return 'TiktokVid{version: $version, type: $type, title: $title, authorUrl: $authorUrl, authorName: $authorName, width: $width, height: $height, html: $html, thumbnailWidth: $thumbnailWidth, thumbnailHeight: $thumbnailHeight, thumbnailUrl: $thumbnailUrl, providerUrl: $providerUrl, providerName: $providerName}';
  }
}
import 'package:norway_flutter_app/features/news/data/models/web_pairs.dart';

class NorwayNew {
  String title;
  String by;
  String votes;
  String readDuration;
  String date;
  int likes = 0;
  String image;
  String publisher = "";
  String content = "";
  List<WebPair> articleContent = [];
  String link = "";
  List<WebPair> cats;
  List<WebPair>? tags;
  List<WebPair> socialShare = [];

  NorwayNew(
    this.title,
    this.by,
    this.votes,
    this.readDuration,
    this.date,
    this.publisher,
    this.image,
    this.content,
    this.cats,
    this.link,
  );

  NorwayNew.withDetails(
    this.title,
    this.by,
    this.votes,
    this.readDuration,
    this.date,
    this.likes,
    this.publisher,
    this.image,
    this.articleContent,
    this.socialShare,
    this.cats,
    this.tags,
  );

  @override
  String toString() {
    return 'NorwayNew{title: $title, by: $by, votes: $votes, readDuration: $readDuration, date: $date, likes: $likes, image: $image, publisher: $publisher, content: $content, articleContent: $articleContent, link: $link, cats: $cats, tags: $tags, socialShare: $socialShare}';
  }
}

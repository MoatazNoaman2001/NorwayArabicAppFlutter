import 'package:fpdart/fpdart.dart';
import 'package:fpdart/src/either.dart';
import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'news_parser.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'models/web_pairs.dart';

class NewsParserImpl implements NorwaySiteParser{

  @override
  Future<NorwayNew> getNewDetails(String url) async {
    final body = await fetchUrl(url);
    BeautifulSoup soup = BeautifulSoup(body);
    var image =
    soup.find('div', class_: 'post-main-content')?.img?.getAttrValue('src');
    var title = soup.find('h1', class_: 'entry-title')?.text;
    var post_on = soup.find('span', class_: 'posted-on')?.a?.find('time')?.text;
    var by = soup.find('span', class_: 'byline')?.text;
    var views = soup.find('span', class_: 'post-views')?.text.trim();
    var readDuration = soup.find('span', class_: 'reading_duration')?.text;
    var publisher = soup.find('span' , class_: 'author vcard')?.text;
    var likes = soup.find('div', class_: 'count-thumbsup')?.text;
    var articles = soup.find('div', class_: 'entry-content')?.findAll('p')
        .toList().map((e) {
      if (e.img != null) {
        var lnk = e.img!.getAttrValue('src');
        return WebPair('img', lnk!);
      }else if(e.find('strong')?.a != null){
        var a = e.find('strong')?.a;
        return WebPair(a!.text, a.getAttrValue('href')!);
      } else {
        if (e.text.isNotEmpty) return WebPair('txt', e.text);
        return WebPair('', '');
      }
    }).filter((t) {
      if(t.right.trim().isEmpty) {
        return false;
      }
      return true;
    });
    var cats = soup.find('span' , class_: 'cat-links')?.findAll('a').toList().map((e) {
      return WebPair(e.text, e.getAttrValue('href')!);
    });

    var socialShare = soup.find('div' , class_: 'magmax-social-share')?.findAll('a').toList().map((e){
      return WebPair(e.getAttrValue('class')!, e.getAttrValue('href')!);
    });
    var nowayNew = NorwayNew.withDetails(title.toString(), by!, views!, readDuration!, post_on!,int.parse(likes!),publisher!, image!,articles!.toList(),socialShare!.toList(), cats!.toList(), [] );
    return nowayNew;
  }

  @override
  Future<List<NorwayNew>> banarNews() async{
    List<NorwayNew> norways = [];
    var body = await fetchUrl('https://norwayvoice.no/');
    var soup = BeautifulSoup(body);
    var banarBody = soup.find('div', class_: 'swiper-wrapper');
    var children = banarBody?.children.first;
    var titleList = children?.findAll('div' , class_: 'anwp-pg-post-teaser__title anwp-font-heading mt-2').toList().map((e) {
      return e.text.trim();
    }).join('\n');
    var dateList = children?.findAll('div' , class_: 'anwp-pg-post-teaser__bottom-meta d-flex flex-wrap').toList().map((e) {
      return e.text.trim();
    }).join('\n');
    var subTitleList = children?.findAll('div' , class_: 'anwp-pg-post-teaser__excerpt mb-2').toList().map((e) {
      return e.text.trim();
    }).join('\n');
    var linkList = children?.findAll('div' , class_: 'w-100 anwp-pg-read-more mt-auto').toList().map((e) {
      return e.a?.getAttrValue('href');
    }).join('\n');
    var imageList = children?.findAll('img' , class_: 'anwp-pg-post-teaser__thumbnail-img d-block anwp-pg-height-180 anwp-object-cover m-0 w-100').toList().map((e) {
      return e.getAttrValue('src');
    }).join('\n');
    int? size = titleList?.length;
    for (int i = 0; i < size!; i++) {
      norways.add(NorwayNew(titleList![i], "", "", "", dateList![i],"", imageList![i], subTitleList![i], [], linkList![i]));
    }

    return norways;
  }

  Future<String> fetchUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      return response.body;
    }else{
      throw Failure('cant parse html');
    }
  }

  @override
  Future<List<NorwayNew>> getNewsList(String url) async {
    final List<NorwayNew> news = [];
    final body = await fetchUrl(url);
    BeautifulSoup soup = BeautifulSoup(body);
    var res = soup.find('div', class_: 'col-md-8 blog-content');
    for (var t in res!.children) {
      String? title =
          t.find('header', class_: 'entry-header')?.children.first.a?.text;
      String? date = t.find('time', class_: "entry-date published")?.text;
      String? by = t.find('span', class_: "byline")?.text;
      String? views = t.find('span', class_: "post-views")?.text;
      var publisher = soup.find('span' , class_: 'author vcard')?.text;
      String? duration = t.find('span', class_: "reading_duration")?.text;
      String? content = t.find('div', class_: "post-excerpt")?.p?.text;
      String? image = t
          .find('div', class_: "post-featured-image")
          ?.img
          ?.getAttrValue("src");
      String? link = t
          .find('div', class_: "post-full-article-link")
          ?.a
          ?.getAttrValue("href");
      List<WebPair>? cats =
      t.find('span', class_: "cat-links")?.children.map((e) {
        return WebPair(
            e.getAttrValue('href') != null ? e.getAttrValue('href')! : "",
            e.text);
      }).toList();
      print(link);
      if (title != null &&
          by != null &&
          views != null &&
          duration != null &&
          date != null &&
          image != null &&
          cats != null) {
        news.add(NorwayNew(title, by, views.trim(), duration, date,publisher!, image,
            content!, cats, link!));
      }
    }

    return news;
  }


  Future<List<WebPair>> platforms() async{
    var body = await fetchUrl('https://norwayvoice.no/');
    var soup = BeautifulSoup(body);
    var platformsBody = soup.find('div' , class_: 'elementor-social-icons-wrapper elementor-grid')
        ?.children.map((e) => e.findAll('a')).map((e) => WebPair(e.first.text.trim(), e.first.getAttrValue('href')!)).toList();

    return platformsBody!;
  }

}

import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

import 'package:norway_flutter_app/core/error/Failure.dart';
import 'package:norway_flutter_app/features/news/data/models/norway_new.dart';
import 'package:norway_flutter_app/features/news/data/models/tiktok.dart';
import 'news_parser.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'models/web_pairs.dart';

class NewsParserImpl implements NorwaySiteParser {
  var dio = Dio();

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
    var publisher = soup.find('span', class_: 'author vcard')?.text;
    var likes = soup.find('div', class_: 'count-thumbsup')?.text;
    var articles = soup
        .find('article')
        ?.find('div', class_: 'entry-content')
        ?.children
        .map((e) {
      if (e.name == 'p') {
        if (e.img != null) {
          var lnk = e.img!.getAttrValue('src');
          return WebPair('img', lnk!);
        } else if (e.find('strong')?.a != null) {
          var a = e.find('strong')?.a;
          return WebPair(a!.text, a.getAttrValue('href')!);
        } else {
          if (e.text.isNotEmpty) return WebPair('txt', e.text);
          return WebPair('', '');
        }
      } else if (e.name == 'blockquote') {
        return WebPair('blockquote', e.getAttrValue('cite')!);
      } else if (e.name == 'figure') {
        return WebPair('figure', [e.find('img')!.getAttrValue('src')!, e.text]);
      } else if (e.name == 'div') {
        var imgs = e
            .findAll('figure')
            .map((e) => e.find('img')?.getAttrValue('src'))
            .toList();
        return WebPair('gallery', imgs);
      } else {
        return WebPair('', '');
      }
    }).filter((t) {
      if (t.left is String) if (t.left.trim().isEmpty) {
        return false;
      }
      return true;
    });
    var cats =
        soup.find('span', class_: 'cat-links')?.findAll('a').toList().map((e) {
      return WebPair(e.text, e.getAttrValue('href')!);
    });

    var socialShare = soup
        .find('div', class_: 'magmax-social-share')
        ?.findAll('a')
        .toList()
        .map((e) {
      return WebPair(e.getAttrValue('class')!, e.getAttrValue('href')!);
    });
    var post_nav = soup.find('div', class_: 'single-post-navigation')?.children.first.findAll('a').map((e){
      return WebPair(e.getAttrValue('rel')!, [e.getAttrValue('href'), e.text.trim()]);
    }).toList();
    var nowayNew = NorwayNew.withDetails(
        title.toString(),
        by!,
        views!,
        readDuration!,
        post_on!,
        int.parse(likes!),
        publisher!,
        image!,
        url,
        articles!.toList(),
        socialShare!.toList(),
        cats!.toList(), [], next: post_nav?.first, prev: post_nav?.last);


    return nowayNew;
  }

  @override
  Future<List<NorwayNew>> banarNews() async {
    List<NorwayNew> norways = [];
    var body = await fetchUrl('https://norwayvoice.no/');
    var soup = BeautifulSoup(body);
    var banarBody = soup.find('div', class_: 'swiper-wrapper');
    var children = banarBody?.children.first;
    var titleList = children
        ?.findAll('div',
            class_: 'anwp-pg-post-teaser__title anwp-font-heading mt-2')
        .toList()
        .map((e) {
      return e.text.trim();
    }).toList();
    var dateList = children
        ?.findAll('div',
            class_: 'anwp-pg-post-teaser__bottom-meta d-flex flex-wrap')
        .toList()
        .map((e) {
      return e.text.trim();
    }).toList();
    var subTitleList = children
        ?.findAll('div', class_: 'anwp-pg-post-teaser__excerpt mb-2')
        .toList()
        .map((e) {
      return e.text.trim();
    }).toList();
    var linkList = children
        ?.findAll('div', class_: 'w-100 anwp-pg-read-more mt-auto')
        .toList()
        .map((e) {
      return e.a?.getAttrValue('href');
    }).toList();
    var imageList = children
        ?.findAll('img',
            class_:
                'anwp-pg-post-teaser__thumbnail-img d-block anwp-pg-height-180 anwp-object-cover m-0 w-100')
        .toList()
        .map((e) {
      return e.getAttrValue('src');
    }).toList();

    int? size = titleList?.length;
    for (int i = 0; i < size!; i++) {
      norways.add(NorwayNew(titleList![i], "", "", "", dateList![i],
          imageList![i]!, subTitleList![i], [], linkList![i]!));
    }

    return norways;
  }

  Future<String> fetchUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Failure('cant parse html');
    }
  }

  @override
  Future<List<NorwayNew>> getNewsList(String url) async {
    final List<NorwayNew> news = [];
    String body;
    BeautifulSoup soup;
    try {
      body = await fetchUrl(url);
      soup = BeautifulSoup(body);
    } catch (e) {
      return [];
    }

    var res = soup.find('div', class_: 'col-md-8 blog-content');
    for (var t in res!.children) {
      String? title =
          t.find('header', class_: 'entry-header')?.children.first.a?.text;
      String? date = t.find('time', class_: "entry-date published")?.text;
      String? by = t.find('span', class_: "byline")?.text;
      String? views = t.find('span', class_: "post-views")?.text;
      var publisher = soup.find('span', class_: 'author vcard')?.text;
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
      // List<int> PageList = soup.find('div' , class_: "magmax_pagination")?.ul!.children.map((e) {
      //   int.parse(e.a!.text);
      // }).toList();

      // var maxPage = 0;
      // for (int i = 0 ; i < PageList!.length ; i++){
      //   if (maxPage > PageList[i]) {
      //     maxPage = PageList[i];
      //   }
      // }

      if (title != null &&
          by != null &&
          views != null &&
          duration != null &&
          date != null &&
          image != null &&
          cats != null) {
        news.add(NorwayNew(title, by, views.trim(), duration, date, image,
            content!, cats, link!));
      }
    }

    return news;
  }

  Future<List<WebPair>> platforms() async {
    var body = await fetchUrl('https://norwayvoice.no/');
    var soup = BeautifulSoup(body);
    var platformsBody = soup
        .find('div', class_: 'elementor-social-icons-wrapper elementor-grid')
        ?.children
        .map((e) => e.findAll('a'))
        .map((e) => WebPair(e.first.text.trim(), e.first.getAttrValue('href')!))
        .toList();

    return platformsBody!;
  }

  @override
  Future<List<WebPair>> aboutUs() async {
    var body = await fetchUrl(
        'https://norwayvoice.no/%d9%85%d9%86-%d9%86%d8%ad%d9%86/');
    var soup = BeautifulSoup(body);
    var content = soup.find('div', class_: "entry-content")?.children.map((e) {
      return WebPair(e.name!, e.text.trim());
    }).toList();

    return content!;
  }

  Future<List<WebPair>> contactUs() async {
    var body = await fetchUrl(
        'https://norwayvoice.no/%d9%84%d9%84%d8%a7%d8%aa%d8%b5%d8%a7%d9%84-%d8%a8%d9%86%d8%a7/?fbclid=IwAR35_9aWz78tKvGj8GrZc2DM_dt6S8rpCZnaoPN8TWQ7xJUQK6HHfP7d_zo');
    var soup = BeautifulSoup(body);
    var contactBody =
        soup.find('div', class_: 'entry-content')?.children.map((e) {
      print(e.children);
      if (e.find('img') != null) {
        return WebPair(e.find('img')!.getAttrValue('src')!.trim(),
            e.find('strong')!.text.trim());
      } else {
        if (e
                .find('strong')!
                .text
                .substring(0, e.find('strong')!.text.indexOf(':'))
                .trim() ==
            'الايميل') {
          List<int> decoded = hexToBytes(
              e.find('strong')!.find('a')!.getAttrValue('data-cfemail')!);
          int firstByte = decoded[0];
          List<int> newBytes = List<int>.filled(decoded.length - 1, 0);

          for (int i = 0; i < decoded.length; i++) {
            int result = (decoded[i] ^ firstByte) & 0xFF;

            if (i == 0) {
              continue;
            }

            newBytes[i - 1] = result;
          }
          // var encoded = String.fromCharCodes(hex.decode(e.find('strong')!.find('a')!.getAttrValue('data-cfemail')!));
          // Uint8List bytes= Uint8List(encoded.length -1);
          // var email = '';
          // for(int i = 1; i < encoded.length ; i++){
          //   bytes[i-1] = pow(encoded[i].toIntOption.getOrElse(() =>0), encoded[0].toIntOption.getOrElse(() => 0)).toInt();
          // }
          // email = String.fromCharCodes(bytes);
          // print('encoded: $email');
          return WebPair(
              e
                  .find('strong')!
                  .text
                  .substring(0, e.find('strong')!.text.indexOf(':'))
                  .trim(),
              utf8.decode(newBytes));
        }

        return WebPair(
            e
                .find('strong')!
                .text
                .substring(0, e.find('strong')!.text.indexOf(':'))
                .trim(),
            e
                .find('strong')!
                .text
                .substring(e.find('strong')!.text.indexOf(':') + 1)
                .trim());
      }
    }).toList();
    print(contactBody?.join('\n'));

    return contactBody!;
  }

  List<int> hexToBytes(String hex) {
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  @override
  Future<List<TiktokVid>> getTiktokVideos() {
    // TODO: implement getTiktokVideos
    throw UnimplementedError();
  }

  @override
  Future<TiktokVid> getTiktokEmbed(String url) async {
    var response = await dio.get('https://www.tiktok.com/oembed?url=${url}');
    var tiktokVid = TiktokVid.fromJson(response.data);
    return tiktokVid;
  }

  @override
  Future<List<WebPair>> appPage(String url) async {
    var body = await fetchUrl(url);
    var soup = BeautifulSoup(body);

    // print(soup.body);
    var plt_body = soup.find('div', class_: 'elementor elementor-27346');
    var texts = plt_body?.children
        .map((e) => e.findAll('h2').map((e) => e.text).toList())
        .toList()
        .flatten
        .toList();
    var imgs = plt_body?.children
        .map((e) => e.findAll('img').map((e) => e.getAttrValue('src')).toList())
        .toList()
        .flatten
        .toList();
    var links = plt_body?.children
        .map((e) => e.findAll('a').map((e) => e.getAttrValue('href')).toList())
        .toList()
        .flatten
        .toList();

    List<WebPair> plts = [];

    int i = 0;
    while (i < texts!.length) {
      plts.add(WebPair(
          texts[i], WebPair(imgs![i]!, links!.length > i ? links[i]! : '')));
      i++;
    }

    var footer_urls = soup
        .find('div', class_: 'footer-social-wrapper')
        ?.children
        .first
        .findAll('a')
        .map((e) => e.getAttrValue('href'))
        .toList();
    var footer_text = soup.find('div', class_: 'textwidget')?.text;
    var footer_logo = soup
        .find('div', class_: 'logo-wrapper')
        ?.children
        .first
        .getAttrValue('src');
    var footer_banners = soup
        .find('div', class_: 'footer-menu-2-wrapper')
        ?.children
        .map((e) => e.find('img')?.getAttrValue('src'))
        .toList();

    plts.add(WebPair('footer_logo', footer_logo.toString()));
    plts.add(WebPair('footer_urls', footer_urls.toString()));
    plts.add(WebPair('footer_text', footer_text!));
    plts.add(WebPair('footer_banners', footer_banners));

    return plts;
  }
}

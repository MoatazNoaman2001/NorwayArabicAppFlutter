import 'dart:io';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:norway_flutter_app/features/streams/data/youtube_parser.dart';

import '../../../../core/error/Failure.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class YoutubeParserImpl implements YoutubeParser{
  @override
  Future<String> get LiveStreamLink async{
    final String channelUrl = "https://www.youtube.com/channel/UCqp7cmIDlbA6DieWeJQS-EA/live";
    final response = await http.get(Uri.parse(channelUrl), headers: {'Cookie': 'CONSENT=YES+42'});

    if (response.statusCode == 200) {
      print(response.body);
      final document = parser.parse(response.body);
      final liveLink = document.querySelector("link[rel='canonical']");
      return liveLink == null? "" : liveLink.attributes['href']!;
    } else {
      print(response.body);
      throw Exception('Failed to load live video URL');
    }
  }

  Future<String> fetchUrl(String url) async {
    final cookie = Cookie('CONSENT', "YES+42");
    final response = await http.get(Uri.parse(url) , headers: {'Cookie': 'CONSENT=YES+42'});
    if(response.statusCode == 200){
      return response.body;
    }else{
      throw Failure('cant parse html');
    }
  }

}
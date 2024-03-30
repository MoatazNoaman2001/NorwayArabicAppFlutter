import 'dart:io';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:norway_flutter_app/features/streams/data/audio_parser.dart';
import 'package:norway_flutter_app/features/streams/data/youtube_parser.dart';

import '../../../../core/error/Failure.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class AudioParserImpl implements AudioParser{
  @override
  Future<bool> get LiveStreamAvailable async{
    final String channelUrl = "http://63.141.232.90:9302/stream?type=http&nocache=26";
    final response = await fetchUrl(channelUrl);
    final soup = BeautifulSoup(response);
    final document = soup.find('video');
    if (document != null){
      return true;
    }else{
      return false;
    }
  }

  Future<String> fetchUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      return response.body;
    }else{
      throw Failure('cant parse html');
    }
  }

}
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:norway_flutter_app/features/streams/data/youtube_parser.dart';

import '../../../../core/error/Failure.dart';
import 'package:http/http.dart' as http;

class YoutubeParserImpl implements YoutubeParser{
  @override
  Future<String> get LiveStreamLink async{
    var body = await fetchUrl('https://www.youtube.com/channel/UCqp7cmIDlbA6DieWeJQS-EA/live');
    var soup = BeautifulSoup(body);
    print('youtube lnk: $body');
    var res = soup.find('link' , class_: 'canonical');
    print('youtube lnk: $res');
    return res.toString()!;
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
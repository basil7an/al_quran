import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  Map? body;
  Future fetchData(
      {required int tafsser_number,
      required int surah_number,
      required int ayah_number}) async {
    try {
      http.Response response = await http.get(Uri.parse(
          'http://api.quran-tafseer.com/tafseer/$tafsser_number/$surah_number/$ayah_number'));
      var ss = utf8.decode(response.bodyBytes);
      body = await jsonDecode(ss);
      // print(ss);
    } catch (e) {
      Future.error('error');
    }
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/quran.dart';

class Asset {
  List<List<Ayah>> ayahPage = [];
  List<Ayah> temp = [];
  String first = '';
  late List<dynamic> ayahs;
  Future<List<List<Ayah>>> fetchData() async {
    ayahPage = [];
    first = await rootBundle.loadString('lib/assets/json/hafsData_v2-0.json');
    if (first.isNotEmpty) {
      ayahs = await jsonDecode(first);
      for (int i = 1; i < 605; i++) {
        temp = [];
        ayahs.forEach((element) {
          if (element['page'] == i) {
            temp.add(Ayah.fromJson(element));
          }
        });
        ayahPage.add(temp);
      }
      return ayahPage;
    }
    return Future.error('error');
  }
}

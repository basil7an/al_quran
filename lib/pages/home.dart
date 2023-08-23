import 'package:al_quran/pages/settings.dart';
import 'package:al_quran/pages/share.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../api/asset.dart';
import '../api/network.dart';
import '../drawerItems.dart';
import '../models/quran.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Network networkk = Network();

  Map? tafseer;
  @override
  void initState() {
    getdata();
    super.initState();
  }

  PageController pagecontroller = PageController();
  Size? size;
  WidgetSpan surahName(surahname) {
    return WidgetSpan(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: size!.height / 19,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('lib/assets/images/surah_frame.png'))),
        child: Text('$surahname'),
      ),
    ));
  }

  Radius radius = Radius.circular(30);
  Radius radius1 = Radius.circular(20);
  gettafseer(int index2, Ayah ayah) async {
    await networkk.fetchData(
        tafsser_number: (index2 + 1),
        surah_number: ayah.suraNo!,
        ayah_number: ayah.ayaNo!);
    tafseer = networkk.body!;
    setState(() {});
  }

  bool isBassmala = false;
  String basmala = 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيم';
  Set<String?> surah = {};
  Set<int?> jozz = {};
  List<List<Ayah>>? ayahs;
  Asset asset = Asset();
  Future getdata() async {
    ayahs = await asset.fetchData();
    setState(() {});
  }

  double slidervalue = 0;
  double scale = 1;
  Widget ayahnumber(index) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/assets/images/ayah.png'))),
          child: Center(
              child: Text(
            (index + 1).toString(),
            style: const TextStyle(fontSize: 14),
          ))),
    );
  }

  Widget row2() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('${surah.first}'), Text('الجزء ${jozz.first}')],
      ),
    );
  }

  bool con = false;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    List<InlineSpan> v = [];
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView.builder(
          itemCount: 114,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 5),
              height: 100,
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onTap: () {
                  pagecontroller.jumpToPage((drawerItems[index]['page'] - 1));
                  Navigator.pop(context);
                  setState(() {
                    slidervalue = (drawerItems[index]['page'] - 1) / 603;
                  });
                },
                tileColor: Color(0xfff5ece3),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [Text('${drawerItems[index]['name']}')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('صفحة  ${drawerItems[index]['page']}'),
                        SizedBox(),
                        drawerItems[index]['revelationType'] == 'Meccan'
                            ? Text('سورة مكية')
                            : Text('سورة مدنية'),
                        const SizedBox()
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: ayahs == null
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Stack(children: [
                GestureDetector(
                  onScaleUpdate: (details) {
                    setState(() {
                      scale = details.scale;
                    });
                  },
                  onTap: () {
                    setState(() {
                      con = true;
                    });
                  },
                  child: PageView.builder(
                    controller: pagecontroller,
                    itemCount: 604,
                    itemBuilder: (context, index) {
                      List<InlineSpan> listtextspan = [];
                      isBassmala = false;
                      surah = {};
                      jozz = {};
                      for (Ayah ayah in ayahs![index]) {
                        surah.add(ayah.suraNameAr);
                        jozz.add(ayah.jozz);
                        if (ayah.ayaNo == 1) {
                          listtextspan.add(surahName(ayah.suraNameAr));
                        }
                        if (ayah.suraNameAr != 'الفَاتِحة' &&
                            ayah.suraNameAr != 'التوبَة' &&
                            ayah.ayaNo == 1) {
                          listtextspan.add(WidgetSpan(
                              child: Center(
                            child: Text(
                              basmala,
                              style: const TextStyle(
                                  fontSize: 22, fontFamily: 'uthmanic'),
                            ),
                          )));
                        }
                        listtextspan.add(TextSpan(
                          text: '${ayah.ayaText} ',
                          style: const TextStyle(
                              textBaseline: TextBaseline.ideographic,
                              overflow: TextOverflow.visible,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'uthmanic',
                              fontSize: 21),
                          recognizer:
                              LongPressGestureRecognizer(
                                  duration: const Duration(milliseconds: 300))
                                ..onLongPress = () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15))),
                                    builder: (context) {
                                      return Container(
                                        padding: const EdgeInsets.only(
                                            top: 16, left: 16, right: 16),
                                        height: 400,
                                        child: PageView.builder(
                                          reverse: true,
                                          itemCount: 8,
                                          itemBuilder: (context, index2) {
                                            return FutureBuilder(
                                              future: gettafseer(index2, ayah),
                                              builder: (context, snapshot) =>
                                                  tafseer?['text'] == null
                                                      ? const Center(
                                                          child: Text(
                                                              'يرجى الالتصال بالنترنت'),
                                                        )
                                                      : SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    '${tafseer?['tafseer_name']}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            28,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  )
                                                                ],
                                                              ),
                                                              Text(
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                                '${tafseer?['text']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            18),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                        ));
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: (index + 1) % 2 == 0
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 1,
                            color: Colors.grey,
                          ),
                          Expanded(
                              child: Container(
                            decoration:
                                const BoxDecoration(color: Color(0xfffff0f1)),
                            child: Column(
                              children: [
                                row2(),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text.rich(
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    TextSpan(children: listtextspan),
                                    textAlign: TextAlign.justify,
                                    textDirection: TextDirection.rtl,
                                    textWidthBasis: TextWidthBasis.longestLine,
                                  ),
                                ),
                                const Spacer(),
                                ayahnumber(index)
                              ],
                            ),
                          ))
                        ],
                      );
                    },
                  ),
                ),
                if (con)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        con = false;
                      });
                    },
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xfff5ece3),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: radius1, bottomRight: radius1)),
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(
                                  builder: (c) => IconButton(
                                      onPressed: () {
                                        setState(() {
                                          con = false;
                                          Scaffold.of(c).openDrawer();
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.menu,
                                        size: 37,
                                      )),
                                ),
                                PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.black,
                                  ),
                                  color: Colors.white,
                                  iconSize: 40,
                                  onSelected: (value) {
                                    switch (value) {
                                      case 1:
                                        {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Settings();
                                            },
                                          ));
                                        }
                                        ;
                                      case 1:
                                        {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Share();
                                            },
                                          ));
                                        }
                                        ;
                                      case 2:
                                        {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Share();
                                            },
                                          ));
                                        }
                                        ;
                                    }
                                  },
                                  shape: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0)),
                                      borderRadius: BorderRadius.circular(20)),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Container(
                                            width: 90, child: Text('Settings')),
                                        onTap: () {
                                          // Navigator.pop(context);
                                        },
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text('Share'),
                                        onTap: () {},
                                      ),
                                    ];
                                  },
                                ),
                                // IconButton(
                                //     onPressed: () {},
                                //     icon: const Icon(Icons.settings_outlined))
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xfff5ece3),
                                borderRadius: BorderRadius.only(
                                    topRight: radius, topLeft: radius)),
                            height: 80,
                            child: Slider(
                                thumbColor: const Color(0xff007330),
                                inactiveColor: const Color(0xffe4d8ca),
                                activeColor: const Color(0xffe4d8ca),
                                label: '${((slidervalue * 603 + 1).toInt())}',
                                divisions: 604,
                                value: slidervalue,
                                onChanged: (nv) {
                                  setState(() {
                                    pagecontroller
                                        .jumpToPage(((nv * 603).toInt()));
                                    slidervalue = nv;
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  )
              ]),
            ),
    );
  }
}

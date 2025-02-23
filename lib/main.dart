import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Dio dio = Dio();
  int _item_count = 0;
  List<dynamic> headlines = [];
  List<dynamic> dateAndTime = [];
  List<String> resources = [];
  List<String> published_hour = [];
  List<String> published_minute = [];
  List<String> published_date = [];
  List<String> published_month = [];
  Map<String, String> toMap() {
    return {
      'www.ft.com': 'Financial Times',
      'qz.com': 'QZ',
      'www.cnbc.com': 'CNBC',
      'www.inoreader.com': 'Inorder',
      };
  }
  Map<String,String> digit_to_string = {
      '1':"January",
      '2':"February",
      '3':"March",
      '4':"April",
      '5':"May",
      '6':"June",
      '7':"July",
      '8':"August",
      '9':"September",
      '10':"October",
      '11':"November",
      '12':"December",
  };

  Color mycolor_1 = Color.fromRGBO(79, 6, 162, 0.75);
  Color mycolor_2 = Color.fromRGBO(71, 7, 143, 0.75);
  Color mycolor_3 = Color.fromRGBO(24, 13, 33, 0.75);
  Color mycolor_4 = Color.fromRGBO(15, 14, 13, 0.75);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      Map<String, String> mappings = toMap();
      Response response = await dio.get(
          "https://www.inoreader.com/stream/user/1006597956/tag/Finance/view/json");
      var output = response.data['items'];

      for (int i = 0; i < output.length; i++) {
        var datetime = DateTime.parse(output[i]['date_published']);
        published_hour.add(datetime.hour.toString());
        published_minute.add(datetime.minute.toString());
        published_date.add(datetime.day.toString());
        published_month.add((digit_to_string[datetime.month.toString()]).toString());
        // 15.00 | 17 May
        Uri uri = Uri.parse(output[i]['url']);
        var host = uri.host;
        if (mappings.containsKey(host)) {
          resources.add(mappings[host]!);
        } else {
          resources.add("Other");
        }
      }

      setState(() {
        _item_count = output.length;
        headlines = output.map((item) => item['title']).toList();
        dateAndTime = output.map((item) => item['date_published']).toList();
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _item_count,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: double.infinity,
            height: 200, // Adjust height as per your design
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  "assets/industry.jpg",
                  fit: BoxFit.cover,
                ),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [mycolor_1, mycolor_2, mycolor_3, mycolor_4],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headlines[index],
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'semplicita',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Text(
                            resources[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontFamily: 'P22_FLLW_Exhibition',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Spacer(),
                          Text(
                            // dateAndTime[index],
                            // published_minute[index].length == 2 ? '${published_minute[index]}': '0${published_minute[index]}';
                            '${published_hour[index].length == 2 ? '${published_hour[index]}': '0${published_hour[index]}'}.${published_minute[index].length == 2 ? '${published_minute[index]}': '0${published_minute[index]}'} | ${published_date[index]} ${published_month[index]}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontFamily: 'Bd_colonius',
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

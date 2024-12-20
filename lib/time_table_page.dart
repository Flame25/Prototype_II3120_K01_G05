import 'package:flutter/material.dart';
import 'package:app2/search_app_bar.dart';
import 'dart:convert';
import 'package:app2/utils.dart';
import 'package:http/http.dart' as http;

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key, required this.time, required this.route_id});
  final dynamic time;
  final String route_id;

  @override
  State<StatefulWidget> createState() => _TimeTablePage();
}

class _TimeTablePage extends State<TimeTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: CustomScrollView(
        slivers: [
          const SliverPersistentHeader(
              delegate: SliverSearchAppBar(), pinned: true),
          // ListView content as SliverList
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TimeTableWidget(
                    time: widget.time,
                    route_id: widget.route_id,
                  ),
                );
              },
              childCount: 1, // Number of items in the list
            ),
          ),
        ],
      ),
    );
  }
}

class TimeTableWidget extends StatefulWidget {
  const TimeTableWidget(
      {super.key, required this.time, required this.route_id});
  final dynamic time;
  final String route_id;

  @override
  State<StatefulWidget> createState() => _AnotherTest();
}

class _TimeTableWidget extends State<TimeTableWidget> {
  TextStyle mediumBlack =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 11);
  TextStyle mediumGray =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11);
  TextStyle mediumBlue =
      TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Aurora Point", style: mediumBlack),
                      Text("Fusion Heights", style: mediumBlack),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("08:00", style: mediumBlue),
                      SizedBox(width: 15),
                      SizedBox(
                        width: 8,
                        height: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 24,
                                child: LayoutBuilder(
                                  builder: (context, constraint) {
                                    return Flex(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      direction: Axis.horizontal,
                                      children: List.generate(
                                        (constraint.constrainWidth() / 3)
                                            .floor(),
                                        (index) => SizedBox(
                                            width: 3,
                                            height: 3,
                                            child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color:
                                                        Colors.grey.shade300))),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Center(
                                child: Icon(Icons.train, color: Colors.indigo),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                        height: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text("08:00", style: mediumBlue),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.indigo),
                    ),
                    Container(
                      height: 3,
                      width: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Colors.indigo),
                    ),
                    Icon(
                      Icons.location_on_sharp,
                      color: Colors.indigo,
                    ),
                    Text("Atlas Square", style: mediumBlack),
                    Expanded(child: SizedBox()), // As spacing
                    Text("08.00", style: mediumGray)
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Colors.indigo),
                    ),
                    Container(
                      height: 3,
                      width: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Colors.indigo),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(color: Colors.indigo, width: 1)),
                      child: Center(
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Atlas Square", style: mediumBlack),
                    Expanded(child: SizedBox()), // As spacing
                    Text("08.00", style: mediumGray)
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnotherTest extends State<TimeTableWidget> {
  Map<String, dynamic>? apiData;

  TextStyle mediumBlack =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 11);
  TextStyle mediumGray =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11);
  TextStyle mediumBlue =
      TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold);

  final headers = {"Content-Type": "application/json"};
  dynamic body;

  Future<Map<String, dynamic>> getData() async {
    try {
      final response = await http.post(
          Uri.parse('http://167.205.67.254:5555/timetable'),
          headers: headers,
          body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("OKAY");
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print("Error : ${e}");
      return {}; // Return an empty list on error
    }
  }

  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    final data = await getData();
    setState(() {
      apiData = data; // Save the fetched data
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    body = json.encode({'route_id': widget.route_id, 'time': widget.time});
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        bool isLoading = false;
        List<String> route_data = [];
        List<DateTime> timetable_data = [];
        Map<String, String> stationMapping = {
          "cimahi": "Cimahi",
          "padalarang": "Padalarang",
          "padalarang_whoosh": "Padalarang",
          "bandung": "Bandung",
          "halim_whoosh": "Halim",
        };

        if (snapshot.connectionState == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Snapshot Error: ${snapshot.error}"));
        }

        if (apiData == null) {
          isLoading = true;
        } else {
          route_data = (apiData?['route'] as List<dynamic>?)
                  ?.map((item) => item.toString())
                  .toList() ??
              [];

          timetable_data = (apiData?['timetable'] as List<dynamic>?)
                  ?.map((item) =>
                      DateTime.tryParse(item.toString()) ?? DateTime.now())
                  .toList() ??
              [];
        }

        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${stationMapping[route_data[0]]}",
                                    style: mediumBlack),
                                Text("${stationMapping[route_data[1]]}",
                                    style: mediumBlack),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${Utils.formatTime(timetable_data[0].toString())}",
                                    style: mediumBlue),
                                SizedBox(width: 15),
                                SizedBox(
                                  width: 8,
                                  height: 8,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 8, bottom: 8),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          child: LayoutBuilder(
                                            builder: (context, constraint) {
                                              return Flex(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                direction: Axis.horizontal,
                                                children: List.generate(
                                                  (constraint.constrainWidth() /
                                                          3)
                                                      .floor(),
                                                  (index) => SizedBox(
                                                      width: 3,
                                                      height: 3,
                                                      child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300))),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Center(
                                          child: Icon(Icons.train,
                                              color: Colors.indigo),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                  height: 8,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Text(
                                    "${Utils.formatTime(timetable_data[1].toString())}",
                                    style: mediumBlue),
                              ],
                            )
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 500,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: route_data.length,
                          itemBuilder: (context, index) {
                            final isWhoosh =
                                route_data[index]?.contains('_whoosh') ??
                                    false; // Check for '_whoosh'
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    if (index == 0)
                                      Container(
                                        width: 7,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.indigo,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                    if (index == route_data.length - 1)
                                      Container(
                                        width: 7,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.indigo,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20)),
                                        ),
                                      ),
                                    if (index > 0 &&
                                        index < route_data.length - 1)
                                      Container(
                                        width: 7,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.indigo,
                                        ),
                                      ),

                                    Container(
                                      height: 3,
                                      width: 10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),
                                          color: Colors.indigo),
                                    ),

                                    if (isWhoosh)
                                      Icon(
                                        Icons.location_on_sharp,
                                        color: Colors.indigo,
                                      ),

                                    if (!isWhoosh)
                                      Container(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  border: Border.all(
                                                      color: Colors.indigo,
                                                      width: 1)),
                                              child: Center(
                                                child: Container(
                                                  width: 7,
                                                  height: 7,
                                                  decoration: BoxDecoration(
                                                    color: Colors.indigo,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),

                                    Text("${stationMapping[route_data[index]]}",
                                        style: mediumBlack),
                                    Expanded(child: SizedBox()), // As spacing
                                    Text(
                                        "${Utils.formatTime(timetable_data[index].toString())}",
                                        style: mediumGray)
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeTableWidgetTest extends State<TimeTableWidget> {
  TextStyle mediumBlack =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 11);
  TextStyle mediumGray =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11);
  TextStyle mediumBlue =
      TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold);

  final String jsonString = '''
  {
    "stations": [
      {
        "name": "Aurora",
        "time": "08:00",
        "nextStation": "Fusion Heights",
        "nextTime": "08:20"
      },
      {
        "name": "Atlas Square",
        "time": "08:40"
      }
    ]
  }
  ''';

  final List<Map<String, String>> stations = [
    {"name": "Auro_whoosh", "time": "08:00"},
    {"name": "Fusion Heights", "time": "08:15"},
    {"name": "Atlas Square", "time": "08:30"},
    {"name": "Destination", "time": "08:45"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final isLast = index == stations.length - 1;
          final isWhoosh = stations[index]["name"]?.contains('_whoosh') ??
              false; // Check for '_whoosh'
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Indicator
              Column(
                children: [
                  // Top bar (if not the first element)
                  if (index != 0)
                    Container(
                      height: 30,
                      width: 2,
                      color: Colors.indigo,
                    ),
                  // Circle
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.indigo, width: 2),
                    ),
                    child: Center(
                      child: isWhoosh
                          ? Icon(Icons.location_on_sharp)
                          : Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(3.5),
                              ),
                            ),
                    ),
                  ),
                  // Bottom bar (if not the last element)
                  if (!isLast)
                    Container(
                      height: 30,
                      width: 2,
                      color: Colors.indigo,
                    ),
                ],
              ),
              SizedBox(width: 10), // Space between timeline and content
              // Station Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stations[index]["name"]!,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    stations[index]["time"]!,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

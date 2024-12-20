import 'package:flutter/material.dart';
import 'package:app2/search_app_bar.dart';
import 'package:app2/main.dart';
import 'package:app2/utils.dart';
import 'package:app2/time_table_page.dart';

class BoardingPage extends StatefulWidget {
  const BoardingPage({super.key, required this.title, required this.id});
  final String title;
  final int id;
  @override
  State<BoardingPage> createState() => _BoardingPage();
}

class _BoardingPage extends State<BoardingPage> {
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
                  child: BoardingView(id: widget.id),
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

class BoardingView extends StatefulWidget {
  const BoardingView({super.key, required this.id});
  final int id;

  @override
  State<StatefulWidget> createState() => _BoardingView();
}

class _BoardingView extends State<BoardingView> {
  final stream = supabase.from('ticket').stream(primaryKey: ['id']);
  Map<String, dynamic>? TicketData;

  Future<Map<String, dynamic>?> getTicketData(int id) async {
    final response = await supabase
        .from('ticket') // The name of the table
        .select()
        .eq('id', id) // Filter: where 'id' equals the given id
        .single(); // Ensures one record is fetched (if exists)

    if (response != null) {
      return response; // Returns the ticket data as a map
    } else {
      return null; // Returns null if no data is found
    }
  }

  Future<void> fetchTicketData() async {
    final data = await getTicketData(widget.id);
    setState(() {
      TicketData = data; // Save the fetched data
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTicketData();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle smallGrayText = TextStyle(
        fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500);
    TextStyle mediumBlackText = TextStyle(
        fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500);
    TextStyle tinyGrayText =
        TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w500);
    TextStyle mediumBlueText = TextStyle(
        fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold);

    return FutureBuilder(
        future: fetchTicketData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == null) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text("Error : ${snapshot.error}");
          }

          if (TicketData == null || TicketData!.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Column(
              children: [
                Ink(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 8, right: 8),
                      child: Column(children: [
                        Row(
                          children: [
                            Text("${TicketData?['from']}",
                                style: smallGrayText),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "${Utils.extractCityName(TicketData?['from'])} → ${Utils.extractCityName(TicketData?['to'])}",
                                style: mediumBlackText)
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "${Utils.getDayDate(TicketData?['from_time'])}",
                                style: tinyGrayText)
                          ],
                        ),
                        SizedBox(height: 15),
                        // TODO: Fix This make sure based on the corret train station
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pasar Senen (PSE)", style: smallGrayText),
                            Text("Purwosari (PWS)", style: smallGrayText)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${Utils.formatTime(TicketData?['from_time'])}",
                                style: mediumBlueText),
                            SizedBox(width: 15),
                            SizedBox(
                              width: 8,
                              height: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.indigo.shade400),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return Flex(
                                            direction: Axis.horizontal,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: List.generate(
                                              (constraints.constrainWidth() / 3)
                                                  .floor(),
                                              (index) => SizedBox(
                                                  height: 3,
                                                  width: 3,
                                                  child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300))),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Center(
                                      child: Icon(Icons.train,
                                          color: Colors.indigo),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                              height: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.indigo.shade400),
                              ),
                            ),
                            SizedBox(width: 15),
                            Text("${Utils.formatTime(TicketData?['to_time'])}",
                                style: mediumBlueText),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${Utils.formatDate(TicketData?['from_time'])}",
                                style: smallGrayText),
                            Text(
                                "Duration ${Utils.formatDuration(TicketData?['from_time'], TicketData?['to_time'])}",
                                style: smallGrayText),
                            Text("${Utils.formatDate(TicketData?['to_time'])}",
                                style: smallGrayText),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          return Flex(
                                            direction: Axis.horizontal,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: List.generate(
                                              (constraints.constrainWidth() /
                                                      10)
                                                  .floor(),
                                              (index) => SizedBox(
                                                  height: 2,
                                                  width: 5,
                                                  child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300))),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Name", style: smallGrayText),
                            Text("Ticket Number", style: smallGrayText),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tristan", style: mediumBlackText),
                            Text("VG1231", style: mediumBlackText),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Passenger", style: smallGrayText),
                            Text("Seat", style: smallGrayText),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("1 Adult", style: mediumBlackText),
                            Text("12-F", style: mediumBlackText),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Class", style: smallGrayText),
                            Text("Baggage", style: smallGrayText),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Economy-A", style: mediumBlackText),
                            Text("10kg", style: mediumBlackText),
                          ],
                        ),
                      ]),
                    ),
                    Ink(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: Colors.grey.shade200),
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Flex(
                                    direction: Axis.horizontal,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                        (constraints.constrainWidth() / 10)
                                            .floor(),
                                        (index) => SizedBox(
                                            width: 3,
                                            height: 3,
                                            child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .grey.shade300)))));
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            width: 10,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20)),
                                  color: Colors.grey.shade200),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Ink(
                      padding: EdgeInsets.only(
                          top: 8, bottom: 8, left: 16, right: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Center(
                              child: Image(
                            image: AssetImage("assets/barcode.png"),
                            width: 300,
                            height: 100,
                          )),
                        ],
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 20),
                Row(children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo),
                          side: MaterialStateProperty.all(BorderSide(color: Colors.indigo, width: 2.0)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              TimeTablePage(time: TicketData?['from_time'], route_id: TicketData?['route_id'])),
                          );
                        },
                        child: Text(
                          "Timetable & Routes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                ])
              ],
            ),
          );
        });
  }
}

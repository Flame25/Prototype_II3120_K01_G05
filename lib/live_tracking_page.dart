import 'package:flutter/material.dart';
import 'package:app2/search_app_bar.dart';

class TimeTablePage extends StatefulWidget {
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
                  child: TimeTableWidget(),
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
  @override
  State<StatefulWidget> createState() => _TimeTableWidget();
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
                          child:Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child:Stack(
                              children: [
                                SizedBox(
                                  height: 24,
                                  child:LayoutBuilder(builder: (context, constraint) {
                                      return Flex(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        direction: Axis.horizontal,
                                        children: List.generate(
                                          (constraint.constrainWidth()/3).floor(),
                                          (index) => SizedBox(
                                            width: 3,
                                            height: 3,
                                            child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey.shade300))),
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
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(30)),
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
              ),
            ),
          ],
        ),
    );
  }
}

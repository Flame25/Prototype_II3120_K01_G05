import 'package:flutter/material.dart';
import 'package:app2/search_app_bar.dart';
import 'package:app2/boarding_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app2/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://zstlvfrubmxryjbpaxdd.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzdGx2ZnJ1Ym14cnlqYnBheGRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzOTcyNTEsImV4cCI6MjA0OTk3MzI1MX0.FYsDnVLeBO2vIFkNZs5D2psyrt2gpjw-yNz8LDu_sv8",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final supabase = Supabase.instance.client;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stream = supabase.from('ticket').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error : ${snapshot.error}'));
          }

          // Check if there is data
          final tickets = snapshot.data ?? [];
          print(tickets.length);

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
                      final ticket = tickets[index];
                      final id = ticket['id'] as int;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TicketView(id: id),
                      );
                    },
                    childCount: tickets.length, // Number of items in the list
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class TicketView extends StatefulWidget {
  const TicketView({super.key, required this.id});
  final int id;

  @override
  State<TicketView> createState() => _TicketView();
}

class _TicketView extends State<TicketView> {
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

  @override
  void initState() {
    super.initState();
    fetchTicketData();
  }

  Future<void> fetchTicketData() async {
    final data = await getTicketData(widget.id);
    setState(() {
      TicketData = data; // Save the fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    if (TicketData == null || TicketData!.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Ink(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BoardingPage(title: "Boarding", id: widget.id)),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${TicketData?['from']}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.indigo),
                      ),
                      Text("${Utils.formatPrice(TicketData?['price'])}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo))
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${TicketData?['level']}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)),
                      Text("Paid",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            Ink(
              color: Colors.white,
              child: Row(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Flex(
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              (constraints.constrainWidth() / 10).floor(),
                              (index) => SizedBox(
                                height: 2,
                                width: 5,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade400),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${TicketData?['from']}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)),
                      Text("${TicketData?['to']}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${Utils.formatTime(TicketData?['from_time'])}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo)),
                      SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Text("${Utils.formatTime(TicketData?['to_time'])}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${Utils.formatDate(TicketData?['from_time'])}",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)),
                      Text(
                          "Duration ${Utils.formatDuration(TicketData?['from_time'], TicketData?['to_time'])}",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)),
                      Text("${Utils.formatDate(TicketData?['to_time'])}",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // Handle your onTap
      child: Ink(
        width: 200,
        height: 200,
        color: Colors.blue,
      ),
    );
  }
}

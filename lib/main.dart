import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectmanager/home.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Manager',
      theme: ThemeData.dark(),
      home: const MainPage(title: 'Project List'),
    );
  }
}

//will change to homepage later on - could add todo list to homepage??
class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  //making the default page0 so it doesnt crash off of startup
  Widget subPage = const Home();
  int index = 0;

  //Text style for all text on this page
  TextStyle txtStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 255, 255, 255)
  );

  void updateState(index){
    switchIndex(index);
    Navigator.pop(context); //note for self - dont call this unless you are **SURE** a drawer is open - app goes black otherwise
  }

  //function to switch page using index from the list tile
  void switchIndex(index){
    setState(() {
      switch(index){
        case "edittimeline":
        subPage = const TimelineEditPage();
        break;
        case 0:
        subPage = const Home();
        break;
        case 1:
        subPage = ProjectPage(
          onTimelineEdit: switchIndex
        );
        break;
        default:
        subPage = const Home();
        break;
      }
    });
  }

  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project List"),
        backgroundColor: const Color.fromARGB(255, 228, 93, 83),
        //adding drawer icon to appbar
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }
            );
          }
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          //list projects here - maybe automate list when implementing files - like read the number of projects, what they are, etc and list them here
          child: NavigationRail(
            extended: true,
            selectedIndex: index,
            onDestinationSelected: updateState,
            destinations: const [
              NavigationRailDestination(
                label: Text("Home", style: TextStyle(color: Colors.white,)),
                icon: Icon(Icons.abc),
              ),
              NavigationRailDestination(
                label: Text("Project Test Page", style: TextStyle(color: Colors.white,)),
                icon: Icon(Icons.access_alarm),
              ),
            ],
          )
        ),
      ),
      body: subPage
    );
  }
}

//test pages to make sure initial page swapping actually works - it does :D
class ProjectPage extends StatefulWidget{
  const ProjectPage({super.key, required this.onTimelineEdit});

  final Function onTimelineEdit;

  @override
  State<ProjectPage> createState() => ProjectTestState();
}

class ProjectTestState extends State<ProjectPage>{
  String testData = "";

  Future<void> loadDesc(path) async {
    String str = await rootBundle.loadString(path);
    setState(() {
      testData = str;
    });
  }

  @override
  void initState(){
    super.initState();
    loadDesc("lib/testDescription.txt");
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text("Test Project A or smth"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 43, 43, 43),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Description:"),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 2),
                            child: Text(testData),
                          )
                        ]
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 43, 43, 43),
                borderRadius: BorderRadius.circular(25)
              ),
              child: SizedBox(
                height: 175,
                width: 600,
                child: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("h"),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton.filled(
                          iconSize: 22.5,
                          color: const Color.fromARGB(255, 187, 187, 187),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color.fromARGB(126, 22, 22, 22),
                          ),
                          onPressed: () {
                            widget.onTimelineEdit("edittimeline");
                          },
                          icon: const Icon(Icons.fullscreen)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TimelinePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint();
    paint.color = Colors.white;
    paint.strokeWidth = 5;
    canvas.drawLine(Offset(size.width*0.05, size.height*(1/6)), Offset(size.width*0.05, size.height*(5/6)), paint);
    canvas.drawLine(Offset(size.width*0.95, size.height*(1/6)), Offset(size.width*0.95, size.height*(5/6)), paint);
    paint.strokeWidth = 2;
    canvas.drawLine(Offset(size.width*0.05, size.height*0.5), Offset(size.width*0.95, size.height*0.5), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}


class TimelineEditPage extends StatefulWidget{
  const TimelineEditPage({super.key});

  @override
  State<TimelineEditPage> createState() => TimelineEditState();
}

class TimelineEditState extends State<TimelineEditPage>{
  Map<String, List> timelineData = Map();

  Future<void> readJson(path) async{
    String str = await rootBundle.loadString(path);
    final data = await jsonDecode(str);
    timelineData["stEnDates"] = [data["startdate"], data["enddate"]];
    timelineData["eventDates"] = [];
    timelineData["events"] = [];
    for (var x=0; x < data["eventdates"].length; x++){
      timelineData["eventDates"]?.add(data["eventdates"][x]);
      timelineData["events"]?.add(data["events"][data["eventdates"][x]]);
    }
    print(timelineData);
  }

  @override
  void initState(){
    super.initState();
    readJson("lib/testtimeline.json");
    //drawTimeline(canvas, MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: CustomPaint(
        painter: TimelinePainter(),
        child: const Stack(
          children: [
            Center(
              child: Text("t"),
            )
          ],
        ),
      )
    );
  }
}
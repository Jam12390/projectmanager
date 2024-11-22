import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projectmanager/home.dart';
import 'package:flutter/services.dart';
import 'package:projectmanager/timeline.dart';

import 'package:timelines/timelines.dart';

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
        subPage = const timelinePage();
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
                        padding: EdgeInsets.all(12),
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
    paint.color = const Color.fromARGB(255, 126, 126, 126);
    paint.strokeWidth = 4;
    canvas.drawLine(Offset(size.width*0.05, size.height*(1/5)), Offset(size.width*0.05, size.height*(4/5)), paint);
    canvas.drawLine(Offset(size.width*0.95, size.height*(1/5)), Offset(size.width*0.95, size.height*(4/5)), paint);
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
  int daysLength = 0;
  DateTime endDate = DateTime(9999,12,31);
  DateTime startDate = DateTime(0000,00,00);
  List<String> timelineDates = [];
  bool isLoading = true;

  //int timelineSt = Point(MediaQuery.of(context).size.width, y)

  Future<void> readJson(path) async{
    String str = await rootBundle.loadString(path);
    final data = await jsonDecode(str);
    setState(() {
      timelineData["stEnDates"] = [data["startdate"], data["enddate"]];
      timelineData["eventDates"] = [timelineData["stEnDates"]?[1]];
      timelineData["events"] = [" "];
      for (var x=0; x <= data["eventdates"].length-1; x++){
        print("readjson ran good");
        timelineData["eventDates"]?.insert(timelineData["eventDates"]!.length-1,data["eventdates"][x]);
        timelineData["events"]?.insert(timelineData["events"]!.length-1, data["events"][data["eventdates"][x]]);
      }
      startDate = DateTime(int.parse(timelineData["stEnDates"]?[0].substring(6,10)), int.parse(timelineData["stEnDates"]?[0].substring(3,5)), int.parse(timelineData["stEnDates"]?[0].substring(0,2)));
      endDate = DateTime(int.parse(timelineData["stEnDates"]?[1].substring(6,10)), int.parse(timelineData["stEnDates"]?[1].substring(3,5)), int.parse(timelineData["stEnDates"]?[1].substring(0,2)));
      timelineDates = [timelineData["stEnDates"]?[0],timelineData["stEnDates"]?[1]];
      print(endDate);
      daysLength = endDate.difference(startDate).inDays;
      isLoading = false;
      print("oh no");
    });
  }

  int getEventPos(String date, DateTime endDate){
    DateTime evDate = DateTime(int.parse(date.substring(6,10)), int.parse(date.substring(3,5)), int.parse(date.substring(0,2))); //fix all of this please just fix it  all just use the fuicking timeline packagfe pleaseplaesepleasdeplaeas
    print(evDate);
    print(endDate);
    return endDate.difference(evDate).inDays;
  }

  @override
  void initState() {
    super.initState();
    readJson("lib/testtimeline.json");
    //getTlLength(timelineData["stEnDates"]?[0], timelineData["stEnDates"]?[1]);
  }

  void testButton(){
    print("this has been pressed");
  }

  int getDateTime(String date, DateTime stDate){
    DateTime dt = DateTime(int.parse(date.substring(6,10)), int.parse(date.substring(3,5)), int.parse(date.substring(0,2)));
    return dt.difference(stDate).inDays;
  }
  DateTime dtConv(String dt){
    DateTime conv = DateTime(int.parse(dt.substring(6,10)), int.parse(dt.substring(3,5)), int.parse(dt.substring(0,2)));
    return conv;
  }

  @override
  Widget build(BuildContext context){
    Point timelineSt = Point(MediaQuery.of(context).size.width*0.05, MediaQuery.of(context).size.height*0.5);
    Point timelineEnd = Point(MediaQuery.of(context).size.width*0.95, MediaQuery.of(context).size.height*0.5);
    double pixelTlLength = timelineEnd.x-timelineSt.x as double;
    List<String> timelineDates = [];
    //Map<String, List> timelineData = Map();

    print(timelineData["stEnDates"]?[0]);
    //List<String> timelineDates = [timelineData["stEnDates"]?[0],timelineData["stEnDates"]?[1]];
    List<String> timelinePointInfo = [" "];
    List<int> daysBetween = [0, daysLength];
    List<double> spacing = [];
    List<Widget> timelinePoints = [];
    if (!isLoading){
      if(timelineData["eventDates"]?.length != null || timelineData["eventDates"]!.length > 1){
        daysBetween = [0];
        for (int x=0; x <= timelineData["eventDates"]!.length-1; x++){
          if(x==0){
            timelineDates.insert(0,timelineData["eventDates"]?[x]);
          } else{
            timelineDates.insert(timelineDates.length - 1, timelineData["eventDates"]?[x]);
          }
          timelinePointInfo.add(timelineData["events"]?[x]);
          //timelinePointInfo.insert(timelineDates.length - 1, timelineData["events"]?[x]);
          if (x==0){
            daysBetween.add(getDateTime(timelineData["eventDates"]?[x], startDate));
          } else{
            daysBetween.insert(timelineDates.length - 1, getDateTime(timelineData["eventDates"]?[x], dtConv(timelineData["eventDates"]?[x-1])));
          }
          spacing.add(pixelTlLength*(daysBetween[daysBetween.length - 1]/daysLength));
          //spacing.add(pixelTlLength*(daysLength/daysBetween[daysBetween.length - 1]));
          print("a");
        }
      } else{
        spacing = [pixelTlLength];
      }
      print("Reached recursive adding to tlpoints");
      //List<Widget> timelinePoints = [];
      for (int x=0; x < timelineDates.length; x++){
        timelinePoints.add(
          //Column(
          //  crossAxisAlignment: CrossAxisAlignment.start,
          //  children: [
              TimelineTile(
                node: const DotIndicator(),
                contents: Text(timelineDates[x]),
                oppositeContents: Text(timelinePointInfo[x]),
              ),
        //      SizedBox(
        //        width: spacing[x],
        //      )
        //    ],
        //  )
        );
      }
    }
    //List<Widget> events = []; //recursively adding events aligned by their dates to the UI
    //if (timelineData["eventDates"]?.length != null){
    //  print(timelineData["eventDates"]!.length-1);
    //  for (int x=0; x <= timelineData["eventDates"]!.length-1; x++){
    //    print("sonething happened");
    //    int evDateDays = getEventPos(timelineData["eventDates"]?[x], endDate);
    //    double eventPos = evDateDays/daysLength;
    //    Widget toAdd = Align( //(timelineSt.x+(eventPos*pixelTlLength)) ((1/MediaQuery.of(context).size.width)+((1/MediaQuery.of(context).size.width)*timelineSt.x))+((1/MediaQuery.of(context).size.width)*(timelineSt.x+(eventPos*pixelTlLength))), 0.5
    //      alignment: Alignment(0,1),
    //      child: FloatingActionButton(
    //        onPressed: testButton,
    //        child: const Text("help me"),
    //      )
    //    );
    //    setState(() {
    //      events.add(toAdd);
    //    });
    //  }
    //  print(events);
    //}
    print("reached scaffold");
    if(isLoading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    } else{
      return Scaffold(
        body: CustomPaint(
          painter: TimelinePainter(),
          child: Stack(
            children: [
              Timeline.tileBuilder(
                theme: TimelineThemeData(
                  direction: Axis.horizontal
                ),
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.after,
                  itemCount: timelinePoints.length,
                  contentsBuilder: (context, index) {
                    //return Padding(padding: EdgeInsets.only(right: spacing[index]), child: timelinePoints[index]);
                    return timelinePoints[index];
                  }
                  //itemExtent: 20,
                  )
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: testButton, 
                  icon: const Icon(Icons.add)
                ),
              )
            ]
          ),
        )
      );
    }
  }
}
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:projectmanager/home.dart';
import 'package:flutter/services.dart';

import 'package:timelines/timelines.dart';

class timelinePage extends StatefulWidget{
  const timelinePage({super.key});

  State<timelinePage> createState() => timelinePageState();
}

class timelinePageState extends State<timelinePage>{
  bool isLoading = true;
  //todo - pass path of json file to a variable from the main state
  String path = "lib/testtimeline.json";
  Map<String, List> jsonData = Map();
  List<Widget> points = [];
  List<double> spacing = [];
  DateTime startDate = DateTime(0000,01,01);
  DateTime endDate = DateTime(9999,12,31);
  int timelineLength = 0;

  Future<void> readJson(path) async{
    String str = await rootBundle.loadString(path);
    final data = await jsonDecode(str);
    jsonData["dates"] = [data["startdate"]];
    jsonData["descriptions"] = ["none"];
    if (data["eventdates"]?.length != null){
      for(int x=0; x < data["eventdates"]?.length; x++){
        jsonData["dates"]?.add(data["eventdates"][x]);
        jsonData["descriptions"]?.add(data["events"][data["eventdates"][x]]);
        print("uh oh");
      }
    }
    jsonData["dates"]?.add(data["enddate"]);
    jsonData["descriptions"]?.add("none");
    setState(() {
      isLoading = false;
      print("yipee");
    });
  }

  DateTime getDT(String dateStr){
    return DateTime(
      int.parse(dateStr.substring(6,10)),
      int.parse(dateStr.substring(3,5)),
      int.parse(dateStr.substring(0,2))
    );
  }

  void initState(){
    super.initState();
    readJson(path);
  }

  void getSpacing(double pixelLength){
    double spaceBuffer = 0;

    String dateStr = jsonData["dates"]?[0];
    startDate = getDT(dateStr);
    dateStr = jsonData["dates"]?[jsonData["dates"]!.length-1];
    endDate = getDT(dateStr);
    timelineLength = endDate.difference(startDate).inDays;
    if(jsonData["dates"]?.length != null){
      for (int x=0; x<jsonData["dates"]!.length; x++){
        if(x+2<=jsonData["dates"]!.length){ //make a check for index becoming negative
          spaceBuffer = pixelLength*((getDT(jsonData["dates"]![jsonData["dates"]!.length-x-1]).difference(getDT(jsonData["dates"]![jsonData["dates"]!.length-x-2])).inDays)/(endDate.difference(startDate).inDays));
          spacing.add(spaceBuffer);
        } else{
          continue;
        }
      }
      spacing.add(0);
    } else{
      spacing = [pixelLength, 0];
    }
  }

  void buildTimeline(){

  }
  
  @override
  Widget build(BuildContext context){
    Point timelineStart = Point(MediaQuery.of(context).size.width*0.05, MediaQuery.of(context).size.height*0.5);
    Point timelineEnd = Point(MediaQuery.of(context).size.width*0.95, MediaQuery.of(context).size.height*0.5);
    double pixelLength = timelineEnd.x-timelineStart.x as double;
    if(!isLoading){
      getSpacing(pixelLength);
      return Scaffold(
        body: Stack(
          children: [
            Timeline.tileBuilder(
              builder: TimelineTileBuilder.connected(
                itemCount: jsonData["dates"]!.length,
                connectionDirection: ConnectionDirection.after,
                contentsBuilder: (context, index) {
                  return TimelineTile(
                    node: const DotIndicator(),
                    contents: Text(jsonData["descriptions"]?[index]),
                    oppositeContents: Text(jsonData["dates"]?[index]),
                  );
                },
              )
            )
          ],
        ),
      );
    } else{
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart';

class Home extends StatefulWidget{
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}


class HomeState extends State<Home>{
  List<String> toDo = [];

  @override
  void initState(){
    super.initState();
    loadToDo();
  }

  Future<void> loadToDo() async {
    // Load and parse the data, then update the list
    String str = await rootBundle.loadString("lib/list.txt");
    List<String> strList = str.split(", ");
    setState(() {
      toDo = strList;
    });
  }

  final List test = ["a", "b", "c"];

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("hola")
                ],
              ),
            )
          ),  
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 43, 43, 43),
                borderRadius: BorderRadius.circular(25),
              ),
              child: SizedBox(
                width: 400,
                  child: Column(
                    children:[
                      const Text("To Do:"),
                      Expanded(
                        child:ListView.separated(
                          itemCount: toDo.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(toDo[index]),
                            );
                          }
                        )
                      )
                    ]
                  ),
                )
              ),
            ),
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProjectList(title: 'Project List'),
    );
  }
}

//will change to homepage later on - could add todo list to homepage??
class ProjectList extends StatefulWidget {
  const ProjectList({super.key, required this.title});
  final String title;

  @override
  State<ProjectList> createState() => ProjectListState();
}

class ProjectListState extends State<ProjectList> {
  //making the default page0 so it doesnt crash off of startup
  Widget page = const Page0();

  //Text style for all text on this page
  final txtStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  //function to switch page using index from the list tile
  void SwitchIndex(int index){
    setState(() {
      switch(index){
        case 0:
        page = const Page0();
        case 1:
        page = const Page1();
      }
    });
    //close drawer
    Navigator.pop(context);
  }

  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project List"),
        backgroundColor: Colors.red,
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
          child: ListView(
            children: [
              ListTile(
                title: const Text("index 0"),
                //did not know that i had to do this - prevents function being called on build which if it is called raises an error :l
                  onTap: () => SwitchIndex(0),
              ),
              ListTile(
                title: const Text("index 1"),
                onTap: () => SwitchIndex(1),
              ),
            ],
          )
        ),
      ),
      body: page
    );
  }
}

//test pages to make sure initial page swapping actually works - it does :D
class Page0 extends StatelessWidget{
  const Page0({super.key});

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: Text("Index 0 - Page 0"),
      ),
    );
  }
}

class Page1 extends StatelessWidget{
  const Page1({super.key});

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: Center(
        child: Text("Index 1 - Page 1"),
      ),
    );
  }
}
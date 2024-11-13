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

  //function to switch page using index from the list tile
  void switchIndex(int index){
    setState(() {
      switch(index){
        case 0:
        subPage = const Home();
        case 1:
        subPage = const Page0();
        case 2:
        subPage = const Page1();
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
            onDestinationSelected: switchIndex,
            destinations: const [
              NavigationRailDestination(
                label: Text("Home", style: TextStyle(color: Colors.white,)),
                icon: Icon(Icons.abc),
              ),
              NavigationRailDestination(
                label: Text("index 0", style: TextStyle(color: Colors.white,)),
                icon: Icon(Icons.access_alarm),
              ),
              NavigationRailDestination(
                label: Text("index 1", style: TextStyle(color: Colors.white,)),
                icon: Icon(Icons.handshake),
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
class Page0 extends StatefulWidget{
  const Page0({super.key});

  @override
  State<Page0> createState() => ProjectTestState();
}

class ProjectTestState extends State<Page0>{
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
        mainAxisAlignment: MainAxisAlignment.end,
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
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 43, 43, 43),
                    //borderRadius: BorderRadius.circular(25),
                  ),
                  child: SizedBox(
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
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
          Row( //doesnt work rn
            children: [
              Text("bishbosh")
            ],
          )
        ],
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
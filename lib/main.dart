import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'decision_map.dart';

//HIVE
late Box<DecisionMap> box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//HIVE
  await Hive.initFlutter();
  Hive.registerAdapter(DecisionMapAdapter());
  box = await Hive.openBox<DecisionMap>('decisionMap');

//CSV
  String csv = "assets/map_decision.csv";
  String fileData = await rootBundle.loadString(csv);
  List<String> rows = fileData.split("\n");

//Load the data
  for (int i = 0; i < rows.length; i++) {
    String row = rows[i];
    List<String> itemInRow = row.split(",");
    DecisionMap decMap = DecisionMap()
      ..ID = int.parse(itemInRow[0])
      ..yesID = int.parse(itemInRow[1]) //yesID
      ..noID = int.parse(itemInRow[2]) //noID
      ..description = itemInRow[3] //description
      ..question = itemInRow[4]; //question
    int key = int.parse(itemInRow[0]);
    box.put(key, decMap);
  }
//RUN
  runApp(const MaterialApp(
    home: StartingScreen(),
  ));
}

//Starting Screen
class StartingScreen extends StatelessWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/jan-kronies-K-x7h4NXtAY-unsplash.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(_createRoute());
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: const Color(0xFF52BE80),
              splashColor: Colors.greenAccent,
              minWidth: 150,
              child: const Text(
                "Start",
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'Lobster',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              onPressed: () {
                //SystemNavigator.pop;
                Navigator.of(context).pop(); //android
                exit(0); //apple
              },
              minWidth: 150,
              color: Colors.pinkAccent,
              splashColor: Colors.redAccent,
              //to change add 0xFF
              child: const Text(
                "Quit",
                style: TextStyle(fontSize: 50, fontFamily: 'Lobster'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MyGame(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      });
}

//Second screen
class MyGame extends StatefulWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  State<MyGame> createState() {
    return _MyGameState();
  }
}

class _MyGameState extends State<MyGame> {
  late int ID, yesID, noID;
  String description = "", question = "";

//Function to store the current values
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        DecisionMap? current = box.get(0);
        if (current != null) {
          ID = current.ID;
          yesID = current.yesID;
          noID = current.noID;
          description = current.description;
          question = current.question;
        }
      });
    });
  }

//Button handler function
  void buttonHandler(String choice) {
    setState(() {
      DecisionMap? current;
      if (choice == "yes") {
        current = box.get(yesID);
      } else if (choice == "no") {
        current = box.get(noID);
      }
      if (current != null) {
        ID = current.ID;
        yesID = current.yesID;
        noID = current.noID;
        description = current.description;
        question = current.question;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/krystal-ng-O07o2Cd_vX0-unsplash.jpg'),
                fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  color: const Color(0xFFFFEEDD),
                  child: Column(
                    children: [
                      ListTile(
                        subtitle: Text(
                          "$description\n$question",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Courgette',
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          buttonHandler("yes");
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        minWidth: 115,
                        splashColor: Colors.greenAccent,
                        color: Colors.pinkAccent,
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Lobster',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        onPressed: () {
                          //buttonHandlerNo();
                          buttonHandler("no");
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minWidth: 115,
                        splashColor: Colors.greenAccent,
                        color: Colors.pinkAccent,
                        child: const Text(
                          "No",
                          style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Lobster',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(_createRoute());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  minWidth: 115,
                  color: Colors.pinkAccent,
                  splashColor: Colors.greenAccent,
                  child: const Text(
                    "Menu",
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lobster',
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

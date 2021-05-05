import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class Picky extends StatefulWidget {
  @override
  _PickyState createState() => _PickyState();
}

class _PickyState extends State<Picky> {
  List types = [
    "None",
    "Social",
    "Education",
    "Cooking",
    "Busywork",
    "Relaxation",
    "Recreational",
  ];
  String typeChoice = "None";
  double price = -1;
  double accessibility = -0.1;
  int participants = -1;
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Someone knows what they want"),
        centerTitle: true,
      ),
      key: _key,
      body: Center(
        child: Container(
          height: size.height - 20,
          width: size.width,
          color: Theme.of(context).primaryColorLight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                choiceField("Type of activity: "),
                choiceFieldNumber(
                    "Price of activity: ",
                    "Range: 0 to 0.1",
                    "Make sure the number is between 0.1 and 1!",
                    1,
                    _key.currentState),
                choiceFieldNumber(
                    "Accessibility of event: ",
                    "Range: 0.1 to 1",
                    "Make sure the number is between 0.1 and 1!",
                    1,
                    _key.currentState),
                choiceFieldNumber(
                    "Number of participants: ",
                    "Range: 1 to 5",
                    "Make sure the number is between 1 and 5!",
                    5,
                    _key.currentState),
                getActivity(_key.currentState)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget choiceField(String prefix) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Container(
        width: size.width - 50,
        decoration: BoxDecoration(
          color: Color(0xffffc947),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    prefix,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            DropdownButton(
              items: types.map((e) {
                return DropdownMenuItem(
                  value: e.toString(),
                  child: Text(e),
                );
              }).toList(),
              value: typeChoice,
              hint: Text("Choose your type of activity"),
              onChanged: (newValue) {
                print("changed");
                setState(() {
                  typeChoice = newValue.toString();

                  print(typeChoice);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget choiceFieldNumber(
      String prefix, String hint, String toast, int limit, ScaffoldState s) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Container(
        width: size.width - 50,
        decoration: BoxDecoration(
          color: Color(0xffffc947),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    prefix,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 200,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(fontSize: 15),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (String input) {
                    if (prefix.toLowerCase().contains("price")) {
                      if(input[0] == ".") input = "0" + input;
                      if (double.parse(input) > limit || double.parse(input) < 0) {
//                      print("yes");
                        s.showSnackBar(SnackBar(content: Text(toast)));
                      } else {
                        setState(() {
                          print(double.parse(input));
                          price = double.parse(input);
                          print("Price: " + price.toString());
                        });
                      }
                      print("Price updated: " + price.toString());
                    } else if (prefix.toLowerCase().contains("accessibility")) {
                      if (double.parse(input) > limit ||
                          double.parse(input) < 0) {
//                      print("yes");
                        s.showSnackBar(SnackBar(content: Text(toast)));
                      } else {
                        setState(() {
                          accessibility = double.parse(input);
                        });
                      }
                      print(
                          "Accessibility updated: " + accessibility.toString());
                    } else if (prefix.toLowerCase().contains("participants")) {
                      if (int.parse(input) > limit || int.parse(input) < 0) {
//                      print("yes");
                        s.showSnackBar(SnackBar(content: Text(toast)));
                      } else {
                        setState(() {
                          participants = int.parse(input);
                        });
                      }
                      print("Participants updated: " + participants.toString());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getActivity(ScaffoldState s) {
    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        width: 200,
        height: 200,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("https://i.imgur.com/fzAdbAd.png"),
              radius: 100.0,
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    var connected = await Connectivity().checkConnectivity();
                    if (connected == ConnectivityResult.wifi ||
                        connected == ConnectivityResult.mobile) {


                      if(participants == -1 && price == -1 && accessibility == -0.1 && typeChoice == "None"){
                        _key.currentState.showSnackBar(SnackBar(content: Text("Fill out at least one of the form fields!"),));
                      } else{
                        String url = "http://www.boredapi.com/api/activity?";
                        String addition = "";

                        if(!typeChoice.contains("None")){
                          String temp = typeChoice.toLowerCase();
                          addition += "type=$temp&&";
                        }
                        if(participants > 0){
                          addition += "participants=$participants&&";
                        }
                        if(price > 0){
                          addition += "price=$price&&";
                        }
                        if(accessibility > -0.1){
                          addition += "accessibility=&$accessibility&&";
                        }

                        print(url+addition);
                        // check which fields are filled out
                        final response = await http.get(url + addition);
                        var res = jsonDecode(response.body);
//                        if("res.keys().toList())
                        if(res.keys.toList().contains("error")){
                          s.showSnackBar(SnackBar(content: Text("Sorry nothing found :( Try some different parameters")));
                        }else{
                          Navigator.pop(context, res);
                        }
                      }

                    } else {
                      s.showSnackBar(
                          SnackBar(content: Text("Please turn on WiFi or Mobile data!")));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

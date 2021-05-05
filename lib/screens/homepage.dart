import 'dart:convert';
import 'package:flutter/material.dart';
import '../components/activity.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:pexels/pexels.dart';

import '../constants/values.dart';
import './picky.dart';


class HomePage extends StatefulWidget {
  @override
  HomePage_State createState() => HomePage_State();
}

class HomePage_State extends State<HomePage> {
  int counter;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map data = {
    "activity": "",
    "type": "",
    "participants": 0,
    "price": 0.0,
    "link": "",
    "accessibility": 0.0
  };

  HomePage_State() {
    counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Need something to do?"),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: Stack(children: [
        toDoCard(size),
            (counter>0)?
            choiceButtons(_scaffoldKey.currentState, "I'm Feeling Picky!", true, size):
            Container(),
            choiceButtons(_scaffoldKey.currentState, "Tell Me What To Do!", false, size),

      ]),
    );
  }

  void getActivity(ScaffoldState s) async {
    var connected = await Connectivity().checkConnectivity();
    if (connected == ConnectivityResult.wifi ||
        connected == ConnectivityResult.mobile) {
      final response = await http.get("http://www.boredapi.com/api/activity/");
      var res = jsonDecode(response.body);
      setState(() {
        data = res;
      });
    } else {
      s.showSnackBar(
          SnackBar(content: Text("Please turn on WiFi or Mobile data!")));
    }
  }

  void getUserChoice(ScaffoldState c) async {
      BuildContext proper = c.context;
     final result = await Navigator.push(proper, MaterialPageRoute(builder:(proper) => Picky()));
     if(result != null){
       setState(() {
         data = result;
       });
     }

   }

  Widget toDoCard(Size size) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height - 30,
          minWidth: size.width,
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
          ),
          child: SingleChildScrollView(
            child: (counter > 0) ? Activity(data) : Container(
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }

  Widget choiceButtons(ScaffoldState state, String text, bool picky, Size size) {
    double left;
    double right;
    if(picky){
      left = 40;
      right = size.width-190;
    } else {
      left = size.width-210;
      right = 50;
    }
    return Positioned(
      bottom: 15,
      left: left,
      right: right,
      child: Container(
        height: 50,
        width: size.width-10,
        decoration: BoxDecoration(
            color: Color(0xffffc947),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child:
        Center(
          child: FlatButton(onPressed: () {
            setState(() {
              counter += 1;
              if(counter>1) counter = 1;
            });

            if(picky){
              getUserChoice(state);
            }else{
              getActivity(state);
            }
          }, child: Center(child: Container(child: Text(text)))),
        ),
      ),
    );
  }
}

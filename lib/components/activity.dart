import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pexels/pexels.dart';
import '../constants/values.dart';

class Activity extends StatelessWidget {
  Map data;

  Activity(Map d) {
    data = d;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
//      fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width - 50,
            ),
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(8, 10),
                      ),
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageHeader(context),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 15),
                        child: Text(
                          data["activity"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Accessibility: ",
                            style: TextStyle(fontSize: 17),
                          ),
                          RatingBarIndicator(
                            itemCount: 5,
                            direction: Axis.horizontal,
                            rating: (data["accessibility"].runtimeType == int)
                                ? 0.0
                                : data["accessibility"].toDouble() * 5,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Price: ",
                            style: TextStyle(fontSize: 17),
                          ),
                          RatingBarIndicator(
                            itemCount: 5,
                            direction: Axis.horizontal,
                            rating: (data["price"].runtimeType == int)
                                ? 0.0
                                : data["price"].toDouble() * 5,
                            itemBuilder: (context, _) => Icon(
                              Icons.monetization_on_rounded,
                              color: Colors.green[700],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Participants: ",
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: data["participants"],
                                itemBuilder: (context, _) {
                                  return Icon(
                                    Icons.account_circle,
                                    color: Colors.purple,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xffffc947),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: (data["type"] != "")
                  ? Text(
                      data["type"][0].toUpperCase() + data["type"].substring(1),
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    )
                  : Text(""),
            ),
          ),
        ]);
  }

  Widget ImageHeader(BuildContext c) {
    if (data["activity"] == "") {
      return Container();
    }
    return FutureBuilder<String>(
      future: getImage(),
      builder: (c, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
//          return Image.network(snapshot.data, height: 200,);
          return Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Container(
              height: 200,
              child: CircleAvatar(
//              maxRadius: ,
                backgroundImage: NetworkImage(snapshot.data),
                radius: 90.0,
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<String> getImage() async {
    var connected = await Connectivity().checkConnectivity();
    if (connected == ConnectivityResult.wifi ||
        connected == ConnectivityResult.mobile) {
      var client = PexelsClient(apikey);
      var result = await client.searchPhotos(data["activity"]);
      var link = result[0].sources['medium'].link;
      return link;
    }
  }
}

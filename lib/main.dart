import 'package:flutter/material.dart';

import './data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool cartIsEmpty = false;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                height: 300.0,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          cartIsEmpty = !cartIsEmpty;
                        });
                      },
                      child: ClipPath(
                        clipper: ArcClipper(),
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Container(
                      height: 100.0,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              height: double.infinity,
                              width: 100.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.blue,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return _foodItemFactory(context, index);
                    // Padding(
                    //   padding: EdgeInsets.all(10.0),
                    //   child: Container(
                    //     height: 100.0,
                    //     width: double.infinity,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       color: Colors.blue,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              )
            ],
          ),
        ),

        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Container(
            height: 50.0,
            width: double.infinity,
            color: Colors.green,
          ),
          crossFadeState: cartIsEmpty
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
        // cartIsEmpty
        //     ? Container()
        //     : Container(
        //         height: 50.0,
        //         width: double.infinity,
        //         color: Colors.green,
        //       ),
      ],
    );
  }

  Widget _foodItemFactory(BuildContext context, int index) {
    return Container(
      width: double.infinity,
      child: Padding(
          padding: EdgeInsets.only(bottom: 12.0, left: 16.0, right: 32.0),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 36.0),
                child: Container(
                  width: double.infinity,
                  // height: 100.0,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(10.0, 10.0),
                            blurRadius: 10.0),
                      ]),
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 35.0 + 8.0, top: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pizza 4 cheeses',
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.grey[800]),
                          ),
                          Text(
                            desc,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 10.0, color: Colors.grey[600]),
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '\$',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Text('575.00',
                                      style: TextStyle(fontSize: 22.0)),
                                ],
                              ),
                              Spacer(),
                              Chip(
                                backgroundColor: Colors.red[400],
                                label: Row(
                                  children: <Widget>[
                                    Text(
                                      'medium'.toUpperCase(),
                                      style: TextStyle(fontSize: 10.0),
                                    ),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Image.asset(
                  'assets/images/pizza-3.png',
                  width: 70,
                  height: 70.0,
                  fit: BoxFit.fill,
                ),
              )
            ],
          )),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  static const double ARC_HEIGHT = 100.0;
  @override
  getClip(Size size) {
    var path = Path();
    // print(size);
    path.lineTo(0.0, size.height - ARC_HEIGHT);
    // path.lineTo(size.width, size.height - 50.0);
    path.arcTo(
        Rect.fromLTWH(
            0.0, size.height - 2 * ARC_HEIGHT, size.width, 2 * ARC_HEIGHT),
        3.14,
        -3.14,
        false);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

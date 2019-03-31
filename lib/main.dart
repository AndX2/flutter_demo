import "package:flutter/material.dart";
import 'dart:math';

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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // print('shrink delta: $shrinkOffset, $minExtent, $maxExtent}');
    return new SizedBox.expand(
        child: _buildHeader(1.0 - shrinkOffset / maxExtent));
  }

  Widget _buildHeader(double shrinkDelta) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // setState(() {
              //   cartIsEmpty = !cartIsEmpty;
              // });
            },
            child: ClipPath(
              clipper: ArcClipper(arcScale: shrinkDelta),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Color(0xFFFF4700),
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
                    // child: Image.asset('assets/images/thumb_c1.jpg',
                    //     fit: BoxFit.cover),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/thumb_c1.jpg'),
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 4.0),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                      // image: DecorationImage(
                      //   fit: BoxFit.cover,
                      //   image: AssetImage('assets/images/thumb_c1.jpg'),
                      // ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
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

  // Widget _buildHeader(double shrinkDelta) {
  //   return Container(
  //     height: double.infinity,
  //     width: double.infinity,
  //     child: Stack(
  //       alignment: Alignment.bottomCenter,
  //       children: <Widget>[
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               cartIsEmpty = !cartIsEmpty;
  //             });
  //           },
  //           child: ClipPath(
  //             clipper: ArcClipper(arcScale: shrinkDelta),
  //             child: Container(
  //               height: double.infinity,
  //               width: double.infinity,
  //               color: Color(0xFFFF4700),
  //             ),
  //           ),
  //         ),
  //         Container(
  //           height: 100.0,
  //           width: double.infinity,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (BuildContext context, int index) {
  //               return Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Container(
  //                   height: double.infinity,
  //                   width: 100.0,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     image: DecorationImage(
  //                       fit: BoxFit.cover,
  //                       image: AssetImage('assets/images/thumb_c1.jpg'),
  //                     ),
  //                     // gradient: LinearGradient(
  //                     //     begin: Alignment.topCenter,
  //                     //     end: Alignment.bottomCenter,
  //                     //     colors: [Colors.black12, Colors.black54],
  //                     //     tileMode: TileMode.clamp),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).orientation);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  maxHeight: 300.0,
                  minHeight: 125.0,
                  child: Container(),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return _foodItemFactory(context, index);
                }),
              ),
              // SliverFixedExtentList(
              //   itemExtent: 120.0,
              //   delegate: SliverChildBuilderDelegate(
              //       (BuildContext context, int index) {
              //     return _foodItemFactory(context, index);
              //   }),
              // ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 20,
              //     itemBuilder: (BuildContext context, int index) {
              //       return _foodItemFactory(context, index);
              //     },
              //   ),
              // )
            ],
          ), //
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
                                    '₽',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  Text('575.00',
                                      style: TextStyle(fontSize: 22.0)),
                                ],
                              ),
                              Spacer(),
                              Chip(
                                backgroundColor: Color(0xFFFF4700),
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
  double arcHeight = 100.0;
  double arcScale = 1.0;
  ArcClipper({this.arcScale}) {
    this.arcHeight = 100.0 * this.arcScale;
  }
  @override
  getClip(Size size) {
    // print(size.height);
    var path = Path();
    // print(size);
    path.lineTo(0.0, size.height - arcHeight);
    // path.lineTo(size.width, size.height - 50.0);
    path.arcTo(
        Rect.fromLTWH(
            0.0, size.height - 2 * arcHeight, size.width, 2 * arcHeight),
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

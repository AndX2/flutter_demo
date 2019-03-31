import "package:flutter/material.dart";
import 'dart:math';
import 'dart:async';

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
  TabController controller;
  var scrollController = ScrollController();
  final double minHeight;
  final double maxHeight;
  final Widget child;
  StreamController<dynamic> _positionController = StreamController.broadcast();
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  void tabControllerChanged() {
    _positionController.add(null);
    // print('tabControllerChanged');
    // print(
    //     'extent: ${scrollController.position.maxScrollExtent}, viewport: ${scrollController.position.viewportDimension}');
    double extent = scrollController.position.maxScrollExtent;
    double viewport = scrollController.position.viewportDimension;
    int index = controller.index;
    double scrollLength = extent + viewport;
    int count = controller.length;
    double scrollTo = scrollLength / (count * 2) +
        index * (scrollLength / (count)) -
        viewport / 2;
    if (scrollTo < 0) scrollTo = 0.0;
    if (scrollTo > extent) scrollTo = extent;
    scrollController.animateTo(scrollTo,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);

    // scrollController.animateTo(controller.index * scrollController.)
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    controller = DefaultTabController.of(context);
    controller.addListener(tabControllerChanged);

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
            child: StreamBuilder(
              stream: _positionController.stream,
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return _buildTabItems();
              },
            ),
          )
        ],
      ),
    );
  }

  ListView _buildTabItems() {
    return ListView.builder(
      controller: scrollController,
      itemCount: controller.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              print('tap on $index');
              controller.animateTo(index);
            },
            child: Container(
              child: Text(index.toString()),
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
                boxShadow: [
                  controller.index == index
                      ? BoxShadow(
                          color: Colors.black54,
                          offset: Offset(6.0, 6.0),
                          blurRadius: 5.0)
                      : BoxShadow(color: Colors.transparent)
                ],
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
                // image: DecorationImage(
                //   fit: BoxFit.cover,
                //   image: AssetImage('assets/images/thumb_c1.jpg'),
                // ),
              ),
            ),
          ),
        );
      },
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

  @override
  Widget build(BuildContext context) {
    int categoryLength = 5;
    var categoryFoodsTabs = List<Widget>();
    for (int i = 0; i < categoryLength; i++) {
      categoryFoodsTabs.add(_listFoodTab());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        DefaultTabController(
          length: categoryLength,
          child: Expanded(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      maxHeight: 300.0,
                      minHeight: 125.0,
                      child: Container(),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: categoryFoodsTabs,
              ),
            ), //
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

  Widget _listFoodTab() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return _foodItemFactory(context, index);
      }),
    );
  }

  Widget _foodItemFactory(BuildContext context, int index) {
    return Container(
      width: double.infinity,
      child: Padding(
          padding: EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
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

import 'package:flutter/material.dart';
import 'dart:math';

class DemoPrefWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      width: 30.0,
      decoration: new BoxDecoration(
        color: Colors.redAccent,
        border: new Border.all(color: Colors.black),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(30.0);
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
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

@override
Widget build(BuildContext context) {
  // return Container(color: Colors.blue,);

  return CustomScrollView(
    slivers: <Widget>[
      // SliverAppBar(
      //   pinned: true,
      //   expandedHeight: 250.0,
      //   flexibleSpace: FlexibleSpaceBar(
      //     // background: Image.asset(''),
      //     title: Text('Demo'),
      //   ),
      // ),
      SliverPersistentHeader(
        pinned: true,
        delegate: _SliverAppBarDelegate(
            maxHeight: 250.0,
            minHeight: 100.0,
            child: Container(
              color: Colors.yellow,
              height: double.infinity,
              width: double.infinity,
            )),
      ),
      SliverFixedExtentList(
        itemExtent: 50.0,
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              color: Colors.lightBlue[100 * (index % 9)],
              child: Text('list item $index'),
            );
          },
        ),
      ),
    ],
  );
}

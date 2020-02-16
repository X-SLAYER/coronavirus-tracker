import 'package:corona_tracker/screens/mapView.dart';
import 'package:corona_tracker/screens/statsView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: <Widget>[
          MapView(),
          StatsView(),
        ],
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: bottomItems(),
    );
  }

  BottomNavigationBar bottomItems() {
    return BottomNavigationBar(
      selectedItemColor: Colors.pink,
      onTap: (int index) {
        setState(
          () {
            currentIndex = index;
          },
        );
        pageController.animateToPage(
          index,
          duration: Duration(
            milliseconds: 200,
          ),
          curve: Curves.easeIn,
        );
      },
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text("Map"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          title: Text("Stats"),
        ),
      ],
    );
  }
}

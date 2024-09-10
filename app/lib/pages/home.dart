import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/drawer.dart';
import '../widgets/navbar.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          title: "Home",
        ),
        backgroundColor: ThemeColors.bgColorScreen,
        // key: _scaffoldKey,
        drawer: SpeecoDrawer(currentPage: "Home"),
        body: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text("Hello")
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("view1"),
                    Text("view2"),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

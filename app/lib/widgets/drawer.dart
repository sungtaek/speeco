import 'package:flutter/material.dart';

import '../theme.dart';
import 'drawer-tile.dart';

// import 'package:argon_flutter/widgets/drawer-tile.dart';

class SpeecoDrawer extends StatelessWidget {
  final String currentPage;

  SpeecoDrawer({this.currentPage = "home"});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: ThemeColors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 32),
                  child: Text("Speeco"),
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            children: [
              DrawerTile(
                  icon: Icons.home,
                  onTap: () {
                    if (currentPage != "Home") {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  iconColor: ThemeColors.primary,
                  title: "Home",
                  isSelected: currentPage == "Home" ? true : false),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 4, thickness: 0, color: ThemeColors.muted),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 16.0, left: 16, bottom: 8),
                    child: Text("DOCUMENTATION",
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 15,
                        )),
                  ),
                ],
              )),
        ),
      ]),
    ));
  }
}

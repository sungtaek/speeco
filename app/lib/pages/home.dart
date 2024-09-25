import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
        drawer: SpeecoDrawer(currentPage: "Home"),
        body: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(child: Text("Body")),
            ),
            Container(
              height: 80,
              child: Row(children: [
                Lottie.asset('images/thinking2.json', repeat: true, animate: true),
                Lottie.asset('images/mic2.json', repeat: true, animate: true),
              ])
            )
          ]),
        ));
  }
}

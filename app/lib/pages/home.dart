import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/conversation.dart';
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
        body: Conversation());
  }
}

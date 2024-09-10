import 'package:flutter/material.dart';

import '../theme.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool transparent;
  final bool rightOptions;
  final bool backButton;
  final bool noShadow;
  final Color bgColor;

  Navbar(
      {this.title = "Home",
      this.transparent = false,
      this.rightOptions = true,
      this.backButton = false,
      this.noShadow = false,
      this.bgColor = Colors.white});

  final double _prefferedHeight = 180.0;

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 102.0,
        decoration: BoxDecoration(
            color: !transparent ? bgColor : Colors.transparent,
            boxShadow: [
              BoxShadow(
                  color: !transparent && !noShadow ? ThemeColors.initial : Colors.transparent,
                  spreadRadius: -10,
                  blurRadius: 12,
                  offset: Offset(0, 5))
            ]),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(
                                !backButton ? Icons.menu : Icons.arrow_back_ios,
                                color: !transparent
                                    ? (bgColor == ThemeColors.white
                                        ? ThemeColors.initial
                                        : ThemeColors.white)
                                    : ThemeColors.white,
                                size: 24.0),
                            onPressed: () {
                              if (!backButton) {
                                Scaffold.of(context).openDrawer();
                              } else {
                                Navigator.pop(context);
                              }
                            }),
                        Text(title,
                            style: TextStyle(
                                color: !transparent
                                    ? (bgColor == ThemeColors.white
                                        ? ThemeColors.initial
                                        : ThemeColors.white)
                                    : ThemeColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0)),
                      ],
                    ),
                    if (rightOptions)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/pro');
                            },
                            child: IconButton(
                                icon: Icon(Icons.notifications_active,
                                    color: !transparent
                                        ? (bgColor == ThemeColors.white
                                            ? ThemeColors.initial
                                            : ThemeColors.white)
                                        : ThemeColors.white,
                                    size: 22.0),
                                onPressed: null),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/pro');
                            },
                            child: IconButton(
                                icon: Icon(Icons.shopping_basket,
                                    color: !transparent
                                        ? (bgColor == ThemeColors.white
                                            ? ThemeColors.initial
                                            : ThemeColors.white)
                                        : ThemeColors.white,
                                    size: 22.0),
                                onPressed: null),
                          ),
                        ],
                      )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

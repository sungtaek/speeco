import 'package:flutter/material.dart';

import '../theme.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback onTap;
  final bool isSelected;
  final Color iconColor;

  DrawerTile(
      {this.title,
      this.icon,
      this.onTap,
      this.isSelected = false,
      this.iconColor = ThemeColors.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: isSelected ? ThemeColors.primary : ThemeColors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            children: [
              Icon(icon,
                  size: 20, color: isSelected ? ThemeColors.white : iconColor),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(title,
                    style: TextStyle(
                        letterSpacing: .3,
                        fontSize: 15,
                        color: isSelected
                            ? ThemeColors.white
                            : Color.fromRGBO(0, 0, 0, 0.7))),
              )
            ],
          )),
    );
  }
}

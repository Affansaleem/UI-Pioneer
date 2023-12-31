import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmpAppBar extends StatelessWidget {
  final VoidCallback openDrawer;

  const EmpAppBar({
    Key? key,
    required this.openDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.bars),
        color: Colors.white,
        onPressed: openDrawer,
      ),
      backgroundColor: const Color(0xFFE26142),
      elevation: 0,
      title: const Center(
        child: Padding(
          padding:  EdgeInsets.only(right: 55.0), // Add right padding
          child: Text(
            "EMP-ID-0108",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

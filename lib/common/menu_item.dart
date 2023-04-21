import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const MenuItem({Key? key, required this.icon,required this.title,required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 3.0, right: 20.0, bottom: 3.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(icon),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle( fontSize: 16.0),
                    ),
                  ),
                  const Icon(Icons.chevron_right)
                ],
              )),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(
              color: Colors.black26,
              height: 18,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InfoItem extends StatelessWidget {
  final String name;
  final String value;

  const InfoItem({Key? key, required this.name, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, top: 2.0, right: 20.0, bottom: 2.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(name,
                      textAlign: TextAlign.left,
                      style: const TextStyle( fontSize: 14.0)),
                ),
                Expanded(
                    child: Text(value,
                        textAlign: TextAlign.right,
                        style:
                            const TextStyle(fontSize: 14.0))),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(
              height: 20,color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}

class RemarkItem extends StatelessWidget {
  final String value;

  const RemarkItem({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 5.0, right: 20.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              )),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Divider(color: Colors.black26),
          )
        ],
      ),
    );
  }
}

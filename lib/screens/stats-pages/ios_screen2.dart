import 'package:flutter/material.dart';

class IosSecondPage extends StatelessWidget {
  const IosSecondPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 550,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 40,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Text("IOS $index"),
          );
        },
      ),
    );
  }
}
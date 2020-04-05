import 'package:flutter/material.dart';

enum decision {
  yes,
  no,
}

class InQuarantineScreen extends StatefulWidget {
  @override
  _InQuarantineScreenState createState() => _InQuarantineScreenState();
}

class _InQuarantineScreenState extends State<InQuarantineScreen> {
  decision selectedDecision;
  bool answer=false;

  @override
  Widget build(BuildContext context) {
    bool selected;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Are you in Qurantine?',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: 80.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                  width: 130.0,
                  child: OutlineButton(
                    color: Color(0xFFFA6400),
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: selectedDecision == decision.yes ? Color(0xFFFA6400) : Colors.black
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        answer = true;
                        selectedDecision = decision.yes;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    borderSide: BorderSide(
                      width: 1.0
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  width: 130.0,
                  child: OutlineButton(
                    focusColor: Color(0xFFFA6400),
                    highlightedBorderColor: Color(0xFFFA6400),
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: selectedDecision == decision.no ? Color(0xFFFA6400) : Colors.black
                      ),
                    ),
                    onPressed: (){
                      setState(() {
                        answer = false;
                        selectedDecision = decision.no;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    borderSide: BorderSide(
                        width: 1.0
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
          SizedBox(
            width: 281.0,
            height: 55.0,
            child: RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(
                    fontSize: 18.0
                ),
              ),
              color: Colors.black45,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed:  _isButtonDisabled ? null :
                  () {
                Navigator.pushNamed(context, '/warning');
              },
            ),
          ),
        ],
      ),
    );
  }
}

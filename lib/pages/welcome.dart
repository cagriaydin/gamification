import 'package:flutter/material.dart';
import 'package:yorglass_ik/pages/phone.dart';
import 'package:yorglass_ik/widgets/outcome-button.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      "assets/yorglass.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                    child: Container(
                      child: Text(
                        "Hey\nYorglass'lı\nHoşgeldin !",
                        style: TextStyle(
                          fontSize: height * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Image.asset(
                "assets/welcome.png",
                width: height - 370 > (width / (373 / 296))
                    ? width - 50
                    : height - 370,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
              child: OutcomeButton(
                text: "İlerle",
                action: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return PhoneValidationPage();
                    },
                  ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

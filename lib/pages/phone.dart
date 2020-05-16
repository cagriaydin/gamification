import 'package:flutter/material.dart';
import 'package:yorglass_ik/enums/authentication-enum.dart';
import 'package:yorglass_ik/helpers/string-helper.dart';
import 'package:yorglass_ik/pages/validation-code.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/outcome-button.dart';

class PhoneValidationPage extends StatefulWidget {
  @override
  _PhoneValidationPageState createState() => _PhoneValidationPageState();
}

class _PhoneValidationPageState extends State<PhoneValidationPage> {
  String phoneNo;
  bool isLoading = false;

  final _scaffOldState = GlobalKey<ScaffoldState>();

  final TextEditingController registrationNumberController =
      new TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final double width = size.width;
    final double height = size.height;
    final bodyHeight =
        height - (mediaQuery.padding.bottom + mediaQuery.padding.top);
    return Scaffold(
      key: _scaffOldState,
      body: !isLoading
          ? GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: SafeArea(
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Container(
                    height: bodyHeight,
                    width: width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Center(
                            child: Image.asset(
                              "assets/yorglass.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: height * 0.1,
                              ),
                              Image.asset(
                                "assets/welcome-right.png",
                                height: double.infinity,
                                fit: BoxFit.fill,
                                width: width - height * 0.25,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.25,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Container(
                                  child: Text(
                                    "Sicil Numaranızı\nGiriniz..",
                                    style: TextStyle(
                                      fontSize:
                                          (height * 0.04).toInt().toDouble(),
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: height * 0.33,
                              padding: EdgeInsets.only(right: 20),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: height * 0.022,
                                  ),
                                  TextField(
                                    textAlign: TextAlign.end,
                                    autofocus: false,
                                    controller: registrationNumberController,
                                    onTap: () async {
                                      await Future.delayed(
                                          Duration(milliseconds: 400));
                                      _controller.animateTo(
                                          _controller.position.maxScrollExtent,
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.ease);
                                    },
                                    decoration: InputDecoration(
                                        counterText: "",
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "xxx xx xx"),
                                    maxLength: 11,
                                    style: TextStyle(
                                      fontSize:
                                          (height * 0.04).toInt().toDouble(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                  Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor,
                                      Colors.white
                                    ])),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                          child: OutcomeButton(
                            text: "İlerle",
                            action: () {
                              verifyPhone(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.white70,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Kod Gönderiliyor...",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 24,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  verifyPhone(context) async {
    String phoneNumber = await StringHelper.getPhoneWithRegNumber(
        registrationNumberController.text);
    if (phoneNumber != "") {
      setState(() {
        isLoading = true;
      });
      await AuthenticationService.instance
          .verifyPhone('+90' + phoneNumber, context, (status) {
        if (status.authenticationEnum == AuthenticationEnum.smsSent) {
          setState(() {
            isLoading = false;
          });
          pushToValidationPage(context, status.verificationId);
        }
      });
    } else {
      showWarning('Lütfen geçerli bir sicil numarası giriniz');
    }
  }

  showWarning(String text) {
    _scaffOldState.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  pushToValidationPage(BuildContext context, String verificationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ValidationCodePage(verificationId: verificationId);
        },
      ),
    );
  }
}

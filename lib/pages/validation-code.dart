import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/enums/verification-status-enum.dart';
import 'package:yorglass_ik/helpers/statusbar-helper.dart';
import 'package:yorglass_ik/pages/home.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/widgets/loading_builder.dart';
import 'package:yorglass_ik/widgets/outcome-button.dart';

class ValidationCodePage extends StatefulWidget {
  String verificationId;

  ValidationCodePage({this.verificationId}) {
    StatusbarHelper.setSatusBar();
  }

  @override
  _ValidationCodePageState createState() => _ValidationCodePageState();
}

class _ValidationCodePageState extends State<ValidationCodePage> {
  final _scaffOldState = GlobalKey<ScaffoldState>();
  bool hasLoading = false;

  final TextEditingController codeController = new TextEditingController();

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    hasLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaQuery = MediaQuery.of(context);
    final double width = size.width;
    final double height = size.height;
    final bodyHeight = height - (mediaQuery.padding.bottom + mediaQuery.padding.top);
    return Scaffold(
        key: _scaffOldState,
        body: !hasLoading
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
                            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/welcome-left.png",
                                  height: double.infinity,
                                  fit: BoxFit.fill,
                                  width: width - height * 0.25,
                                ),
                                SizedBox(
                                  width: height * 0.1,
                                )
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
                                      "Telefonunuza\nGönderdiğimiz Kodu\nGiriniz",
                                      style: TextStyle(
                                        fontSize: (height * 0.04).toInt().toDouble(),
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
                                width: height * 0.22,
                                padding: EdgeInsets.only(right: 20),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: height * 0.022,
                                    ),
                                    TextField(
                                      controller: codeController,
                                      onTap: () async {
                                        await Future.delayed(Duration(milliseconds: 400));
                                        _controller.animateTo(_controller.position.maxScrollExtent, duration: Duration(milliseconds: 250), curve: Curves.ease);
                                      },
                                      decoration: InputDecoration(
                                          counterText: "",
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          hintText: "xx xx xx"),
                                      textAlign: TextAlign.end,
                                      maxLength: 6,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: (height * 0.04).toInt().toDouble(),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor, Colors.white])),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                            child: OutcomeButton(
                              text: "Giriş Yap",
                              action: () {
                                signInWithPhoneNumber(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : LoadingBuilder(
                text: "Giriş Yapılıyor...",
              ));
  }

  signInWithPhoneNumber(BuildContext context) async {
    setState(() {
      hasLoading = true;
    });
    VerificationStatusEnum status = await AuthenticationService.instance.signInWithOTP(codeController.text, widget.verificationId);
    switch (status) {
      case VerificationStatusEnum.ok:
        pushToLandingPage(context);
        break;
      case VerificationStatusEnum.wrongCode:
        showWarning('Yanlış kod girdiniz, tekrar deneyiniz.');
        break;
      case VerificationStatusEnum.emptyCode:
        showWarning('Boş kod giremezsiniz, tekrar deneyiniz.');
        break;
      default:
        showWarning('Yanlış kod girdiniz, tekrar deneyiniz.');
    }
    setState(() {
      hasLoading = false;
    });
  }

  showWarning(String text) {
    _scaffOldState.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  pushToLandingPage(BuildContext context) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChangeNotifierProvider.value(value: AuthenticationService.verifiedUser, child: HomePage());
        },
      ),
      (Route<dynamic> route) => false,
    );
  }
}

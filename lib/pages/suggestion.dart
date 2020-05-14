import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/suggestion.dart';
import 'package:yorglass_ik/repositories/suggestion_repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/shared/custom_box_shadow.dart';
import 'package:yorglass_ik/widgets/outcome-button.dart';
import 'package:yorglass_ik/widgets/point-widget.dart';

class SuggestionPage extends StatefulWidget {
  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  Suggestion suggestion;

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  final color = Color(0xFF2FB4C2);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).accentColor,
                    size: 34,
                  ),
                ),
                SizedBox(
                  width: size.width / 30,
                ),
                Text(
                  "Öneri Oluştur",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(
                  width: size.width / 30,
                ),
                Icon(
                  Icons.edit,
                  color: Theme.of(context).accentColor,
                  size: 24,
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    CustomBoxShadow(
                        color: color,
                        offset: new Offset(0, 4),
                        blurRadius: 20.0,
                        blurStyle: BlurStyle.outer),
                  ],
                ),
                height: size.height * .6,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    AuthenticationService.verifiedUser.image,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                AuthenticationService.verifiedUser.name,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).accentColor),
                              ),
                              SizedBox(height: 5),
                              Text(
                                AuthenticationService.verifiedUser.branchName[0]
                                        .toUpperCase() +
                                    AuthenticationService
                                        .verifiedUser.branchName
                                        .substring(1)
                                        .toLowerCase() +
                                    ' İşletmesi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff4BADBB).withOpacity(.6),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 20.0, bottom: 20.0),
                            child: PointBuilder(
                              point: "10",
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: TextField(
                        maxLength: 28,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        controller: titleController,
                        decoration: new InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          hintText: "Önerine bir başlık ver",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(.25),
                          ),
                          fillColor: Colors.red,
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 10, 20, 0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        maxLengthEnforced: false,
                        maxLength: 500,
                        maxLines: 3,
                        cursorColor: Colors.black,
                        controller: descriptionController,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.only(top: 7),
                          hintText: "Önerinden biraz bahseder misin",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(.25),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            OutcomeButton(
              text: "Önerimi Paylaş",
              action: () => sendSuggestion(),
              color: Color(0xFF3FC1C9),
            )
          ],
        )),
      ),
    );
  }

  sendSuggestion() {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        descriptionController.text.length >= 10) {
      suggestion.title = titleController.text;
      suggestion.description = descriptionController.text;
      SuggestionRepository().sendSuggestion(suggestion);
    }
    return;
  }
}

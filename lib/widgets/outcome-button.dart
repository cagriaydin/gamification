import 'package:flutter/material.dart';
import 'package:yorglass_ik/shared/custom_box_shadow.dart';

class OutcomeButton extends StatelessWidget {
  const OutcomeButton({
    GlobalKey key,
    @required this.text,
    @required this.action,
    this.color,
  }) : super(key: key);

  final String text;
  final Function action;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => action(),
        child: Container(
          width: MediaQuery.of(context).size.width - 150,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(21.5),
            boxShadow: [
              CustomBoxShadow(
                  color: color ?? Theme.of(context).primaryColorDark,
                  offset: new Offset(1, 3),
                  blurRadius: 3.0,
                  blurStyle: BlurStyle.outer),
              CustomBoxShadow(
                  color: color ?? Theme.of(context).primaryColorDark,
                  offset: new Offset(-1, 3),
                  blurRadius: 3.0,
                  blurStyle: BlurStyle.outer),
              CustomBoxShadow(
                  color: Colors.white,
                  offset: new Offset(0, 0),
                  blurRadius: 6.0,
                  blurStyle: BlurStyle.outer),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: TextStyle(
                  color: color ?? Color(0xFF26315F),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextIconButton extends StatefulWidget {
  TextIconButton({required this.text, required this.onTap, required this.icon});

  final String text;
  final Function onTap;
  final IconData icon;

  @override
  State createState() => TextIconButtonState();
}


class TextIconButtonState extends State<TextIconButton> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        child: Row(children: [
        Icon(
          widget.icon,
          color: Theme.of(context).primaryColorLight,
          size: 15.0,
        ),
        Text(widget.text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
                color: Theme.of(context).primaryColorLight
                )
              )
              ]
            )
          )
    );
  }

}
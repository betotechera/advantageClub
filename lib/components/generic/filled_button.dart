import 'package:flutter/material.dart';

class FilledButton extends StatefulWidget {
  FilledButton({required this.text, required this.onTap, required this.icon});

  final String text;
  final Function onTap;
  final IconData icon;

  @override
  State createState() => FilledButtonState();
}

class FilledButtonState extends State<FilledButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        //onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.text,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25.0,
                      color: Colors.black87,
                      fontFamily: "Gotik")),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              Icon(widget.icon)
            ],
          ),
        ),
      ),
    );
  }
}

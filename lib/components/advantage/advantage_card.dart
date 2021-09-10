import 'package:advantage_club/model/advantage.dart';
import 'package:flutter/material.dart';

import 'advantage_detail.dart';

class AdvantageCard extends StatefulWidget {
  
  final Advantage advantage;

  const AdvantageCard({required this.advantage});
  @override
  _AdvantageCardState createState() => _AdvantageCardState();
}

class _AdvantageCardState extends State<AdvantageCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => AdvantageDetail(advantage: widget.advantage)));
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF656565).withOpacity(0.5),
                      blurRadius: 8.0,
                      spreadRadius: 1.0,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: widget.advantage.callActionImage,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image(
                            image:
                                NetworkImage(widget.advantage.callActionImage),
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover)),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Text(widget.advantage.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                              color: Colors.black87,
                              fontFamily: "Gotik"))),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 5),
                      child: Row(children: [
                        Icon(Icons.location_on, color: Colors.grey),
                        Text(widget.advantage.marketingType.description)
                      ])),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      child: Text(widget.advantage.call)),
                ],
              ))),
    );
  }
}

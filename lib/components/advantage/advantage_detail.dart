import 'package:advantage_club/model/advantage.dart';
import 'package:advantage_club/model/user.dart';
import 'package:advantage_club/service/advantage_service.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../login.dart';

class AdvantageDetail extends StatefulWidget {
  final Advantage advantage;

  const AdvantageDetail({required this.advantage});
  @override
  State<StatefulWidget> createState() => AdvantageDetailState();
}

class AdvantageDetailState extends State<AdvantageDetail> {
  Stack _teaser() {
    return Stack(
      children: [
        Container(
            height: MediaQuery.of(context).size.width - 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0, 2.0),
                      color: Colors.black26,
                      blurRadius: 6)
                ])),
        Container(
            padding: EdgeInsets.only(bottom: 40),
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Hero(
              tag: widget.advantage.callActionImage,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Image(
                    width: MediaQuery.of(context).size.width,
                    image: NetworkImage(widget.advantage.callActionImage),
                    fit: BoxFit.cover,
                  )),
            )),
        Positioned(
          left: 0,
          bottom: 40,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.advantage.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25.0,
                        color: Colors.white,
                        fontFamily: "Gotik")),
                Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(widget.advantage.call,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )))
              ],
            ),
          ),
        ),
        Positioned(
            right: 20,
            bottom: 8,
            child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0, 2.0),
                          color: Colors.black26,
                          blurRadius: 6)
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(widget.advantage.logo),
                  radius: 50,
                )))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        body: CustomScrollView(slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData.fallback().copyWith(color: Colors.white),
            brightness: Brightness.dark,
            floating: false,
            expandedHeight: MediaQuery.of(context).size.width - 100,
            flexibleSpace: FlexibleSpaceBar(
              background: _teaser(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    _detailTitle("Sobre a oferta"),
                    _detailText(widget.advantage.teaser),
                    advantageButton(),
                    _detailTitle("Instru????es de uso"),
                    _detailText(widget.advantage.functioningDescription),
                    _detailTitle("Regulamento"),
                    _detailText(
                        "N??o acumulativo com outras promo????es ou cupons V??lido somente para compras realizadas no hotsite atrav??s do link."),
                    _line(),
                    _detailTitle("Termos gerais"),
                    _detailText(
                        "Todas as ofertas s??o de uso exclusivo para Clientes Wingoo.",
                        fontSize: 14),
                    _detailText(
                        "Loja F??sica: Dirija-se a um dos endere??os v??lidos e no momento da compra solicite seu desconto, apresentando o cart??o do segurado* ou voucher gerado, junto com seu documento de identifica????o pessoal.",
                        fontSize: 14),
                    _detailText(
                        "Loja Virtual: Compre atrav??s do link personalizado ou utilize o c??digo de desconto dispon??vel.",
                        fontSize: 14),
                    _detailText(
                        "O Clube de Vantagens reserva-se no direito de substituir, a qualquer momento, sem comunica????o pr??via, qualquer um dos parceiros, produtos e/ou servi??os e constantes de qualidade, igual ou superior, sempre com o intuito de oferecer o melhor servi??o.",
                        fontSize: 14),
                    SizedBox(height: 40)
                  ],
                ),
              )
            ]),
          )
        ]));
  }

  Padding advantageButton() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                )
              ]),
          child: Column(children: [
            _detailTitle("Validade"),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _detailText(
                  DateFormat("dd/MM/y").format(widget.advantage.beginDate)),
              _detailText(
                  DateFormat("dd/MM/y").format(widget.advantage.endDate))
            ]),
            StoreConnector<AppState, User>(converter: (store) {
              return store.state.currentUser;
            }, builder: (context, User currentUser) {
              final userLogged = currentUser != null;
              return InkWell(
                onTap: () async {
                  if(userLogged){
                    await AdvantageService().createEntry(widget.advantage.id);
                    await launch(widget.advantage.externalLink);
                    return;
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginWidget()));
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _detailTitle("Aproveitar benef??cio"),
                      Icon(Icons.check_circle_outline)
                    ],
                  ),
                ),
              );
            })
          ])),
    );
  }

  Widget _line() {
    return Container(
        padding: EdgeInsets.all(20), child: Divider(color: Colors.black));
  }

  Padding _detailText(String text, {double fontSize: 16}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
      child: Text(text,
          style: TextStyle(fontSize: fontSize, color: Colors.black87)),
    );
  }

  Padding _detailTitle(String value) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(value,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 25.0,
              color: Colors.black87,
              fontFamily: "Gotik")),
    );
  }
}

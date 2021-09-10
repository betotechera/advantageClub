import 'package:advantage_club/model/user.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config.dart';
import 'login.dart';

class DrawerWidget extends StatefulWidget {
  DrawerCallback callback;
  final BuildContext context;

  DrawerWidget({required this.callback, required this.context});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

Widget _menuItem(text, icon, context, {onTap}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
                border: Border.all(
                    color: Theme.of(context).primaryColorLight, width: 1.2)),
            child: Row(children: [
              Expanded(
                  // 1st use Expanded
                  child: Center(
                      child: Text(text,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.0,
                              color: Theme.of(context).primaryColorLight)))),
              Icon(icon, color: Theme.of(context).primaryColorLight)
            ]))),
  );
}

Widget _avatar(userLogged, user, context) {
  return Column(
      children: userLogged
          ? [
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircleAvatar(
                      radius: 75,
                      backgroundImage: NetworkImage('https://placekitten.com/g/160/160')
                     )),
              Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, bottom: 25),
                  child: Text(user?.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0,
                          color: Theme.of(context).primaryColorLight,
                          fontFamily: "Gotik"))),
            ]
          : [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Image.asset('assets/clubewingoo-logo.png'),
              )
            ]);
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    widget.callback(true);
    super.initState();
  }

  @override
  void dispose() {
    widget.callback(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StoreConnector<AppState, User>(converter: (store) {
        return store.state.currentUser;
      }, builder: (context, User currentUser) {
        final userLogged = currentUser != null;
        return Padding(
            padding: const EdgeInsets.all(7),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.5),
                        blurRadius: 1.0,
                        spreadRadius: 0.5,
                      )
                    ]),
                child: ListView(
                  children: [
                    _avatar(userLogged, currentUser, widget.context),
                    _buildMenuItems(userLogged),
                  ],
                )));
      }),
    );
  }

  Widget _buildMenuItems(userLogged) {
    return userLogged
        ? Column(
            children: [
              _menuItem("Meu Perfil", Icons.person, widget.context, onTap: () => launch("${Config.domain}/area-logada/usuario")),
              _menuItem("Minhas Compras", Icons.card_travel, widget.context, onTap: () => launch("${Config.domain}/area-logada/minhas-compras")),
              _menuItem("Dependentes", Icons.group, widget.context, onTap: () => launch("${Config.domain}/area-logada/dependentes")),
              _menuItem("Sair", Icons.input, widget.context),
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              _menuItem("Entrar", Icons.arrow_forward, widget.context,
                  onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginWidget()));
              }),
              _menuItem("Cadastrar", Icons.assignment_ind, widget.context, onTap: () => launch("${Config.domain}/cadastro")),
            ]),
          );
  }
}

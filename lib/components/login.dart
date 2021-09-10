import 'package:advantage_club/model_views/banner_view.dart';
import 'package:advantage_club/model_views/login_view.dart';
import 'package:advantage_club/service/user_service.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import 'generic/filled_button.dart';

class LoginWidget extends StatefulWidget {
  //LoginWidget({Key key}) : super(key: key);

  @override
  State createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _userController = TextEditingController();
    final _passwordController = TextEditingController();
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
          child: Container(
            height: 625,
            padding: EdgeInsets.all(20),
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image(image: ExactAssetImage('assets/clubewingoo-logo.png')),
                  _text("Seja bem vindo ao nosso clube de vantagens!", 15),
                  _inputField(context, 'Seu e-mail', _userController),
                  _inputField(context, 'Sua senha', _passwordController,
                      obscureText: true),
                  StoreConnector<AppState, LoginView>(converter: (store) {
                    return LoginView.create(store);
                  }, builder: (context, loginView) {
                    return FilledButton(
                        text: "Entrar",
                        icon: Icons.input,
                        onTap: () async {
                          try {
                            final user = await UserService().login(
                                _userController.text, _passwordController.text);
                            loginView.loadUser(user);
                            BannerView.create(loginView.store).loadBanners();
                            Navigator.pop(context);
                          } catch (error) {
                            final snackBar =
                                SnackBar(content: Text('Dados de acesso inválidos. Tente novamente.'));
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        });
                  }),
                  _line(),
                  _text(
                      "Ainda não possui conta? Realize o seu cadastro em poucos minutos",
                      16),
                  _signUpButton(context),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  Padding _inputField(
      BuildContext context, String text, TextEditingController controller,
      {obscureText: false}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColorLight)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColorLight)),
            hintText: text),
      ),
    );
  }

  InkWell _signUpButton(BuildContext context) {
    return InkWell(
      onTap: () => launch("${Config.domain}/cadastro"),
        child: Container(
      width: 150,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(
              color: Theme.of(context).primaryColorLight, width: 1.2)),
      child: Text(
        "Cadastrar",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).primaryColorLight),
      ),
    ));
  }

  Padding _text(String text, double fontSize) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(text,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: fontSize,
            )));
  }
}

Widget _line() {
  return Container(
      padding: EdgeInsets.all(5), child: Divider(color: Colors.black));
}

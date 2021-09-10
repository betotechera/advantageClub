import 'package:advantage_club/store/actions.dart';
import 'package:advantage_club/store/app_state.dart';
import 'package:redux/redux.dart';

class LoginView {
  final Store<AppState> store;
  final Function loadUser;

  LoginView(this.store, this.loadUser);

  factory LoginView.create(Store<AppState> store) {
    _loadUser(user) async {
      store.dispatch(UserLogged(user));
    }

    return LoginView(store, _loadUser);
  }
}
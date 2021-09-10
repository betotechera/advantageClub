
import 'package:advantage_club/model/user.dart';
import 'package:requests/requests.dart';

import '../config.dart';

class UserService {
  Future<User> login(String user, String password) async {
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'},
        srequestBody = {
      'username': user,
      'password': password,
      'grant_type': 'password'
    };
    final response = await Requests.post(
        "${Config.api}/login",
        headers: headers,
        body: srequestBody);
    response.raiseForStatus();
    return me();
  }

  Future<User> me() async {
    var response =
        await Requests.get("${Config.api}/users/me");
    response.raiseForStatus();
    print(response.json());
    var result = User.fromJson(response.json());
    return result;
  }
}

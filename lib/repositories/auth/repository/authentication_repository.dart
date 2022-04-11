import 'dart:async';
import 'package:dukkantek/constants/api_path_constants.dart';
import 'package:dukkantek/constants/app_constants.dart';
import 'package:dukkantek/repositories/auth/model/user_model.dart';
import 'package:dukkantek/utils/services/networking/api_provider.dart';
import 'package:dukkantek/utils/services/shared_preference/shared_preference.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final ApiProvider _apiProvider = ApiProvider();

  final SharedPreference _sharedPref = SharedPreference();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept-Charset': 'utf-8'
  };

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.authenticated;
    yield* _controller.stream;
  }

  Future<dynamic> socialMedia({required String email, required String name, required String uid}) async {

    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = true;
    data['message'] = "Login successful";
    data['name'] = name;
    data['email'] = email;
    data['uid'] = uid;


      await _sharedPref.saveJson(sharedPrefUser, data);
      _controller.add(AuthenticationStatus.authenticated);
    return data;

  }



  Future<dynamic> logIn({required String email, required String password}) async {
    var body = <String, String>{};
    body['email'] = email;
    body['password'] = password;
    final response = await _apiProvider.post(url: login, body: body);
    if(response["status"]){
      await _sharedPref.saveJson(sharedPrefUser, response);
      _controller.add(AuthenticationStatus.authenticated);
    }

    return response;
  }

  Future<dynamic> signUp({required String userName,required String email, required String password, required String dob}) async {

    var map = <String,String>{};

    map['name'] = userName;
    map['email'] = email;
    map['password'] = password;
    map['dob'] = dob;

    final response = await _apiProvider.post(url:register, body: map);
    _controller.add(AuthenticationStatus.authenticated);
    return response;
  }

  void logOut() async {
    await _sharedPref.remove(sharedPrefUser);
    _controller.add(AuthenticationStatus.unauthenticated);
  }
  void dispose() => _controller.close();
}
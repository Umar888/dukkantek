import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dukkantek/constants/app_constants.dart';
import 'package:dukkantek/repositories/auth/model/user_model.dart';
import 'package:dukkantek/repositories/auth/repository/authentication_repository.dart';
import 'package:dukkantek/utils/services/shared_preference/shared_preference.dart';


part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required AuthenticationRepository authenticationRepository}):
        _authenticationRepository = authenticationRepository,
        super(AuthenticationState.unknown(User_model())) {
    _authenticationStatusSubscription = _authenticationRepository.status.listen(
          (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  SharedPreference sharedPref = SharedPreference();
  late StreamSubscription<AuthenticationStatus>
  _authenticationStatusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationRepository.logOut();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationRepository.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
      AuthenticationStatusChanged event) async {
    switch (event.status) {
      case AuthenticationStatus.authenticated:
        var user = (await _tryGetUser());
        return user != null && user.uid != null
            ? AuthenticationState.authenticated(user)
            : AuthenticationState.unauthenticated(User_model());
      case AuthenticationStatus.unauthenticated:
        return AuthenticationState.unauthenticated(User_model());
      default:
        return AuthenticationState.unknown(User_model());
    }
  }

  Future<User_model?> _tryGetUser() async {
    try {
      var userMap = await sharedPref.readJson(sharedPrefUser);
      if(userMap == null){
        return User_model();
      }else{
        return User_model.fromJson(userMap);
      }
    } on Exception {
      return null;
    }
  }
}

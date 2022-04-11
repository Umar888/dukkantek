import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dukkantek/repositories/auth/model/user_model.dart';
import 'package:dukkantek/repositories/auth/repository/authentication_repository.dart';
import 'package:dukkantek/utils/modules/login/models/email.dart';
import 'package:dukkantek/utils/services/shared_preference/shared_preference.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import '../../register/models/password.dart';

part 'login_event.dart';
part 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })   : _authenticationRepository = authenticationRepository,
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;
  SharedPreference sharedPref = SharedPreference();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email','https://www.googleapis.com/auth/userinfo.profile','https://www.googleapis.com/auth/user.birthday.read']);

  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is LoginEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginWithGoogle) {
      yield* _mapGoogleLoginSubmittedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapEmailChangedToState(
      LoginEmailChanged event,
      LoginState state,
      ) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.password, email]),
    );
  }

  LoginState _mapPasswordChangedToState(
      LoginPasswordChanged event,
      LoginState state,
      ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.email]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
      LoginSubmitted event,
      LoginState state,
      ) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        final response = await _authenticationRepository.logIn(
          email: state.email.value,
          password: state.password.value,
        );
        var userModel = User_model.fromJson(response);
        if(userModel.status!){
          emit(state.copyWith(
              status: FormzStatus.submissionSuccess,
              message: userModel.message
          ));
        }
        else{
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              message: userModel.message));
        }
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure, message: 'Something went wrong!');
      }
    }
  }


  Stream<LoginState> _mapGoogleLoginSubmittedToState(
      LoginWithGoogle event,
      LoginState state,
      ) async* {

      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        _googleSignIn.signOut().then((value) async {
          GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn().catchError((error)  {
            emit(state.copyWith(status: FormzStatus.submissionFailure, message: 'Google Sign In Error $error'));
          });
          if(googleSignInAccount != null){
            print(googleSignInAccount.email);
            print(googleSignInAccount.displayName);
            print(googleSignInAccount.id);
            print(googleSignInAccount.photoUrl);

            final response = await _authenticationRepository.socialMedia(
              name: googleSignInAccount.displayName!,
              uid: googleSignInAccount.id,
              email: googleSignInAccount.email,
            );

            var userModel = User_model.fromJson(response);

            emit(state.copyWith(
                status: FormzStatus.submissionSuccess,
                message: userModel.message
            ));

          }
          else{
            emit(state.copyWith(status: FormzStatus.submissionFailure, message: 'Something went wrong!'));
          }
        });

      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure, message: 'Something went wrong!');
      }

  }



  Future<String> getDOB() async {
    final headers = await _googleSignIn.currentUser!.authHeaders.catchError((error, stackTrace) {
      print("errorororo1 ${error.toString()}");
    });
    print("auth ${headers["Authorization"]}");
    final r = await http.get(Uri.parse("https://people.googleapis.com/v1/people/me?personFields=birthdays&key="),
        headers: {
          "Authorization": headers["Authorization"]!
        }
    ).catchError((error, stackTrace) {

    });
    final response = jsonDecode(r.body);
    log(jsonEncode(response));
    return response["birthdays"][0]["date"]["year"].toString()+"-"+response["birthdays"][0]["date"]["month"].toString()+"-"+response["birthdays"][0]["date"]["day"].toString();
  }
}
part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState._(
      this.user, {
        this.status = AuthenticationStatus.unknown,
      });

  const AuthenticationState.unknown(User_model user) : this._(user);

  const AuthenticationState.authenticated(User_model user)
      : this._(user,status: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated(User_model user)
      : this._(user,status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final User_model user;

  @override
  List<Object> get props => [status, user];
}

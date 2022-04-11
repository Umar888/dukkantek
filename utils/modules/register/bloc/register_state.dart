part of 'register_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

class RegisterState extends Equatable {
  const RegisterState({
    this.userName = const UserName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.isTermCondition = const IsTermCondition.pure(),
    this.status = FormzStatus.pure,
    this.message = '',
    this.dob = const DateOfBirth.pure(),
  });

  final UserName userName;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final IsTermCondition isTermCondition;
  final FormzStatus status;
  final String message;
  final DateOfBirth dob;

  @override
  List<Object> get props => [userName,email, dob, password, confirmedPassword, isTermCondition,status, message];

  RegisterState copyWith({
    UserName? userName,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
    IsTermCondition? isTermCondition,
    FormzStatus? status,
    String? message,
    DateOfBirth? dob,
  }) {
    return RegisterState(
        userName: userName ?? this.userName,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        isTermCondition: isTermCondition ?? this.isTermCondition,
        status: status ?? this.status,
        message: message ?? this.message,
        dob: dob ?? this.dob,
    );
  }
}
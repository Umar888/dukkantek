import 'package:dukkantek/constants/colors_constants.dart';
import 'package:dukkantek/utils/helpers/internet/internet_cubit.dart';
import 'package:dukkantek/utils/modules/login/bloc/login_bloc.dart';
import 'package:dukkantek/utils/modules/register/screens/register_page.dart';
import 'package:dukkantek/utils/ui/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  final _loginForm = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        hideKeyBoard(context);
      },
      child:Stack(
        children: [
          SizedBox.expand(
            child: BlocBuilder<InternetCubit, InternetState>(
                builder: (context,state){
                  if(state is InternetDisconnected){
                    return BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state.status.isSubmissionFailure && state.message.isNotEmpty) {
                          showSnackBarMessage(context, state.message);
                        } else if (state.status.isSubmissionSuccess && state.message.isNotEmpty) {
                          hideKeyBoard(context);
                          showSnackBarMessage(context, state.message);
                        }
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.12),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/login_banner.png',
                                height: size.height * 0.25,
                              ),
                              const SizedBox(height: 15),
                              loginWithYourAccount(context),
                              Padding(
                                padding: EdgeInsets.fromLTRB(size.height * 0.02,
                                    size.height * 0.03, size.height * 0.02, 0),
                                child: Form(
                                  key: _loginForm,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        _EmailInput(emailController: emailController),
                                        const SizedBox(height: 4.0),
                                        _PasswordInput(passwordController: passwordController),
                                        _ForgotPasswordButton(),
                                        const SizedBox(height: 18.0),
                                        CustomElevatedButton(
                                            text: "Login",
                                            width: 300.0,
                                            height: 50,
                                            buttonColor: blueTextColor,
                                            onPressed:  () {
                                              showSnackBarMessage(context, "No Internet Connection");
                                            }),
                                        SizedBox(height: size.height * 0.035),
                                        _SignUpButton(),
                                        SizedBox(height: size.height * 0.001),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  else{
                    return BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state.status.isSubmissionFailure && state.message.isNotEmpty) {
                          showSnackBarMessage(context, state.message);
                        } else if (state.status.isSubmissionSuccess && state.message.isNotEmpty) {
                          hideKeyBoard(context);
                          showSnackBarMessage(context, state.message);
                        }
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.12),
                          child: Column(
                            children: [

                              Image.asset(
                                'assets/images/login_banner.png',
                                height: size.height * 0.25,
                              ),
                              const SizedBox(height: 15),
                              loginWithYourAccount(context),
                              Padding(
                                padding: EdgeInsets.fromLTRB(size.height * 0.02,
                                    size.height * 0.03, size.height * 0.02, 0),
                                child: Form(
                                  key: _loginForm,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        _EmailInput(emailController: emailController),
                                        _PasswordInput(passwordController: passwordController),
                                        _ForgotPasswordButton(),
                                        const SizedBox(height: 5.0),
                                        _LoginButton(loginForm: _loginForm,buildContext: context,),
                                        SizedBox(height: size.height * 0.03),
                                        Row(
                                          children: [
                                            Expanded(child: Divider(color: primaryColorDark,)),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: Text("OR",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),),
                                            ),
                                            Expanded(child: Divider(color: primaryColorDark,)),
                                          ],

                                        ),
                                        SizedBox(height: size.height * 0.03),
                                        _GoogleSignIn(),
                                        SizedBox(height: size.height * 0.03),
                                        _SignUpButton(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

void hideKeyBoard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
}

Widget loginWithYourAccount(BuildContext context) {
  return  Text("Login with your Account",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColorDark));
}

class _EmailInput extends StatelessWidget {
  final TextEditingController emailController;
  _EmailInput({required this.emailController});


  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_emailInput_textField'),
          controller: emailController,
          validator: (email) {
            if (!(_emailRegExp.hasMatch(email!))) {
              return "Please enter valid email address";
            }
            return null;
          },

          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "Email Address",
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: primaryColorDark
              )
            ),
            isDense: true,
            helperText: '',
            errorText: state.email.invalid && emailController.text.isNotEmpty
                ? "Please enter valid email address"
                : null,
          ),
        );
      },
    );
  }
}
class _GoogleSignIn extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: GoogleAuthButton(
            onPressed: () {
              context.read<LoginBloc>().add(LoginWithGoogle());
            },

            // darkMode: true,
            text: "Sign in with Google".toUpperCase(),
            style: AuthButtonStyle(

              elevation: 5,
              separator: 30,

              width: double.infinity,
              iconSize: 24,
              height: 50,
              textStyle: TextStyle(color: Colors.white),
              buttonType: AuthButtonType.secondary,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {

  final TextEditingController passwordController;
  _PasswordInput({required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginForm_passwordInput_textField'),
          controller: passwordController,
          validator: (password) {
            if (password!.length < 4) {
              return "Please enter a valid password";
            }
            return null;
          },

          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: primaryColorDark
                )
            ),
            isDense: true,
            labelText: "Password",
            helperText: '',
            errorText:
            state.password.invalid && passwordController.text.isNotEmpty ? "Please enter a valid password" : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  GlobalKey<FormState> loginForm;
  BuildContext buildContext;
  _LoginButton({required this.loginForm,required this.buildContext});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
        builder: (context,state){
          if(state is InternetDisconnected){
            return CustomElevatedButton(
                text:"Submit",
                width: 300.0,
                height: 50,
                buttonColor: primaryColorDark,
                onPressed: () {
                  showSnackBarMessage(context, "No Internet Connection");
                });
          }
          else{

            return BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (previous, current) => previous.status != current.status,
              builder: (context, state) {
                return state.status.isSubmissionInProgress
                    ? const CircularProgressIndicator()
                    : !state.status.isValidated?
                CustomElevatedButton(
                    text: "Login",
                    width: 300.0,
                    height: 50,
                    buttonColor: primaryColorDark,
                    onPressed: null)
                    :CustomElevatedButton(
                      text: "Login",
                      width: 300.0,
                      height: 50,
                        buttonColor: primaryColorDark,
                      onPressed: state.status.isValidated
                          ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                          : (){
                        showSnackBarMessage(context, "Please complete form correctly");
                      });
              },
            );
          }
        }
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('loginForm_forgot_flatButton'),
      child: Text("Forget Password", style: const TextStyle(color: primaryColorDark),
      ),
      onPressed: (){},
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(
             "Not a Member?",
             style:  TextStyle(color: Colors.black87),
          ),
           const SizedBox(width: 4),
           Text(
             "Register Free",
            style: const TextStyle(color: primaryColorDark),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).push<void>(RegisterPage.route());
      },
    );
  }
}
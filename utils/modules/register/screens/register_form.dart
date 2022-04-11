import 'package:dukkantek/constants/colors_constants.dart';
import 'package:dukkantek/utils/helpers/internet/internet_cubit.dart';
import 'package:dukkantek/utils/modules/register/bloc/register_cubit.dart';
import 'package:dukkantek/utils/ui/custom_elevated_button.dart';
import 'package:dukkantek/utils/ui/format_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  int index=-1;




  @override
  void dispose() {
    _birthDateController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => hideKeyBoard(context),
      child: Scaffold(
        body: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetDisconnected) {
              return  BlocListener<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state.status.isSubmissionFailure) {
                    showSnackBarMessage(context, state.message);
                  } else if (state.status.isSubmissionSuccess) {
                    hideKeyBoard(context);
                    showSnackBarMessage(context, state.message);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.00),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: size.height * 0.04),
                        Image.asset(
                          'assets/images/register_banner.png',
                          height: size.height * 0.23,
                        ),
                        const SizedBox(height: 10),
                        createFreeAccount(context),
                        const SizedBox(height: 5),
                        Padding(
                            padding: EdgeInsets.fromLTRB(size.height * 0.02,
                                size.height * 0.02, size.height * 0.02, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5.0),
                                _UserNameInput(controller: _nameController,),
                                const SizedBox(height: 5.0),
                                _EmailInput(controller: _emailController,),
                                const SizedBox(height: 5),
                                _DateOfBirthInput(controller: _birthDateController, date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
                                const SizedBox(height: 5.0),
                                _PasswordInput(controller: _passwordController,),
                                const SizedBox(height: 5.0),
                                _ConfirmPasswordInput(controller: _confirmController,),
                                _IsTermAndCondition(),
                                SizedBox(height: size.height * 0.02),
                                Align(alignment: Alignment.center,child: CustomElevatedButton(
                                    text: "Register",
                                    width: 300.0,
                                    height: 50,
                                    buttonColor: primaryColorDark,
                                    onPressed:(){
                                      showSnackBarMessage(context, "No Internet Connection");
                                    })),
                                SizedBox(height: size.height * 0.02),
                                _LoginButton(),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }
            else{
              return BlocListener<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state.status.isSubmissionFailure) {
                    showSnackBarMessage(context, state.message);
                  } else if (state.status.isSubmissionSuccess) {
                    hideKeyBoard(context);
                    showSnackBarMessage(context, state.message);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.00),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: size.height * 0.04),
                        Image.asset(
                          'assets/images/register_banner.png',
                          height: size.height * 0.23,
                        ),
                        const SizedBox(height: 10),
                        createFreeAccount(context),
                        const SizedBox(height: 5),
                        Padding(
                            padding: EdgeInsets.fromLTRB(size.height * 0.02,
                                size.height * 0.02, size.height * 0.02, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 5.0),
                                _UserNameInput(controller: _nameController,),
                                const SizedBox(height: 5.0),
                                _EmailInput(controller: _emailController,),
                                const SizedBox(height: 5),
                                _DateOfBirthInput(controller: _birthDateController, date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
                                const SizedBox(height: 5.0),
                                _PasswordInput(controller: _passwordController,),
                                const SizedBox(height: 5.0),
                                _ConfirmPasswordInput(controller: _confirmController,),
                                _IsTermAndCondition(),
                                SizedBox(height: size.height * 0.02),
                                Align(alignment: Alignment.center,child: _SignUpButton()),
                                SizedBox(height: size.height * 0.02),
                                _LoginButton(),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
        ));

  }




}

void showSnackBarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message)),
    );
}

void hideKeyBoard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

Widget createFreeAccount(BuildContext context) {
  return Text("Create free account",
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: primaryColorDark));
}

Widget createMenaCashBackAccount(BuildContext context) {
  return Text("Create Dukkantek account", style: const TextStyle(fontSize: 14));
}

class _IsTermAndCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.isTermCondition != current.isTermCondition,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
              child: CheckboxListTile(
                value: state.isTermCondition.value,
                activeColor: primaryColorDark,
                onChanged: (value) => context
                    .read<RegisterCubit>()
                    .isTermAndConditionChange(value!),
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: () {
              },
              child: Row(
                children: [
                  Text("I agree to"),
                  const SizedBox(width: 5),
                  Text(
                   "Dukkantek T&Cs",
                    style: const TextStyle(color: primaryColorDark),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DateOfBirthInput extends StatelessWidget {
  TextEditingController controller;
  DateTime date;
  _DateOfBirthInput({required this.controller,required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.dob != current.dob,
      builder: (context, state) {
        return TextField(
          controller: controller,
          onTap: () {
            DatePicker.showDatePicker(context,
                theme: DatePickerTheme(
                    backgroundColor:appBackgroundColor,
                    itemStyle: TextStyle(
                        color:appBackgroundColorDark
                    ),

                    doneStyle: TextStyle(

                        color: appBackgroundColorDark
                    ),
                    cancelStyle: TextStyle(

                        color: appBackgroundColorDark
                    )
                ),
                showTitleActions: true,

                minTime: DateTime(1960, 01, 01),
                maxTime: DateTime(date.year-18, date.month, date.day),

                onConfirm: (date) {
                  controller.text = FormatDate().getFormatDate(date);
                  context.read<RegisterCubit>().dobChanges(FormatDate().getFormatDate(date));

                }, currentTime: DateTime.now(),
                locale:LocaleType.en);
            hideKeyBoard(context);
          },
          readOnly: true,
          key: const Key('signUpForm_dobInput_textField'),
          onChanged: (userName) =>
              context.read<RegisterCubit>().dobChanges(userName),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            isDense: true,
            labelText: "Date of Birth",
            helperText: '',
            errorText: state.dob.invalid && controller.text.isNotEmpty
                ? "Please enter a valid date of birth"
                : null,
          ),
        );
      },
    );
  }
}

class _UserNameInput extends StatelessWidget {
  TextEditingController controller;
  _UserNameInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.userName != current.userName,
      builder: (context, state) {
        return TextFormField(
          key: const Key('signUpForm_userNameInput_textField'),
          controller: controller,

          onChanged: (userName) =>
              context.read<RegisterCubit>().userNameChanged(userName),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            isDense: true,
            labelText: "Full Name",
            helperText: '',
            errorText: state.userName.invalid && controller.text.isNotEmpty
                ? "Please enter atleast three characters"
                : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  TextEditingController controller;
  _EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_emailInput_textField'),
          controller: controller,
          onChanged: (email) =>
              context.read<RegisterCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            labelText: "Email Address",
            helperText: '',
            errorText: state.email.invalid && controller.text.isNotEmpty
                ? "Please enter a valid email address"
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  TextEditingController controller;
  _PasswordInput({required this.controller});



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_passwordInput_textField'),
          controller: controller,
          onChanged: (password) =>
              context.read<RegisterCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            isDense: true,
            labelText: "Password",
            helperText: '',
            errorText: state.password.invalid && controller.text.isNotEmpty
                ? "Please enter a valid password"
                : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  TextEditingController controller;
  _ConfirmPasswordInput({required this.controller});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword,
      builder: (context, state) {
        return TextField(
          key: const Key('signUpForm_confirmedPasswordInput_textField'),
          controller: controller,
          onChanged: (confirmPassword) => context
              .read<RegisterCubit>()
              .confirmedPasswordChanged(confirmPassword),
          obscureText: true,
          decoration: InputDecoration(
            isDense: true,
            labelText: "Confirm Password",
            helperText: '',
            errorText: state.confirmedPassword.invalid && controller.text.isNotEmpty
                ? "Password do not match"
                : null,
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(builder: (context, state) {
      if (state is InternetDisconnected) {
        return CustomElevatedButton(
            text: "Register",
            width: 300.0,
            height: 50,
            buttonColor: primaryColorDark,
            onPressed: () {
              showSnackBarMessage(context, "No Internet Connection");
            });
      } else {
        return BlocBuilder<RegisterCubit, RegisterState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return state.status.isSubmissionInProgress
                ? const CircularProgressIndicator()
                : CustomElevatedButton(
                    text: "Register",
                    width: 300.0,
                    height: 50,
                    buttonColor: primaryColorDark,
                    onPressed:
                    state.status.isValidated?
                       () {
                            context.read<RegisterCubit>().signUpFormSubmitted();
                          }
                       : null
            );
          },
        );
      }
    });
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        key: const Key('signupForm_moveToLogin_flatButton'),
        child: Text(
          "Already a member",
          style: const TextStyle(color: primaryColorDark),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

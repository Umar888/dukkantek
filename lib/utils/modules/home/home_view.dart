import 'package:dukkantek/constants/app_constants.dart';
import 'package:dukkantek/constants/colors_constants.dart';
import 'package:dukkantek/repositories/auth/bloc/authentication_bloc.dart';
import 'package:dukkantek/repositories/auth/model/user_model.dart';
import 'package:dukkantek/utils/helpers/internet/internet_cubit.dart';
import 'package:dukkantek/utils/modules/login/bloc/login_bloc.dart';
import 'package:dukkantek/utils/modules/register/screens/register_page.dart';
import 'package:dukkantek/utils/services/shared_preference/shared_preference.dart';
import 'package:dukkantek/utils/ui/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomeView());
  }
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AuthenticationBloc authenticationBloc;
  SharedPreference sharedPreference = SharedPreference();
  late User_model user;
  bool isLoading=true;


  @override
  void initState() {
    authenticationBloc=context.read<AuthenticationBloc>();
    getUser().then((value){
      user=User_model.fromJson(value);
      setState(() {
        isLoading=false;
      });
    });
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
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: appBackgroundColor,
      height: size.height,
      width: size.width,
      child: isLoading?CupertinoActivityIndicator():Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Welcome ${user.name}"),
          CustomElevatedButton(
              text: "Logout",
              width: 300.0,
              height: 50,
              buttonColor: blueTextColor,
              onPressed:  () {
                authenticationBloc.add(AuthenticationLogoutRequested());
              }),
        ],
      ),
    );
  }
  Future<Map<String?,dynamic>> getUser() async{
    SharedPreference sharedPreference= SharedPreference();
    var res = await sharedPreference.readJson(sharedPrefUser);
    return res;
  }

  Future<User_model?> _tryGetUser() async {
    try {
      var userMap = await sharedPreference.readJson(sharedPrefUser);
      if(userMap == null){
        return User_model();
      }else{
        return User_model.fromJson(userMap);
      }
    } on Exception {
      return User_model();
    }
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


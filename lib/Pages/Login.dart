import 'dart:convert';
import 'dart:io';

import 'package:driver/beanmodel/profilebean.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driver/Auth/login_navigator.dart';
import 'package:driver/Components/entry_field.dart';
import 'package:driver/Routes/routes.dart';
import 'package:driver/Themes/colors.dart';
import 'package:driver/baseurl/baseurl.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'blockButtonWidget.dart';


class Login extends StatefulWidget {
  @override
  _Logintate createState() => _Logintate();
}

class _Logintate extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  var fullNameError = "";

  bool showDialogBox = false;
  dynamic token = '';
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    firebaseMessagingListener();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child:
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.39,
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
                child: Image.asset(
                  "images/logos/Delivery.gif",
                  width: MediaQuery.of(context).size.width, //footer image
                ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.39 - 20,
            child: Container(
              decoration: BoxDecoration(
                  color: kCardBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 50,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding:
                  EdgeInsets.only(top: 50, right: 27, left: 27, bottom: 20),
              width: MediaQuery.of(context).size.width * 0.88,
//              height: config.App(context).appHeight(55),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) => !input.contains('@')
                          ? 'Debe ser un email válido'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'carlosc@ejemplo.com',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.alternate_email,
                            color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      obscureText: hidePassword,
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      validator: (input) => input.length < 3
                          ? 'Debe tener mas de 3 caracteres'
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '••••••••••••',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.lock_outline,
                            color: Theme.of(context).accentColor),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          color: Theme.of(context).focusColor,
                          icon: Icon(hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30),
                    BlockButtonWidget(
                      text: Text(
                        'Entrar',
                        style: TextStyle(color: kWhiteColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        login(_emailController.text, _passwordController.text,
                            context);
                      },
                    ),
                    SizedBox(height: 15),
                    FlatButton(
                      onPressed: () {
                        /*
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));

                         */
                      },
                      shape: StadiumBorder(),
                      textColor: Theme.of(context).hintColor,
                      child: Text('No tengo una Cuenta'),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    ),
//                      SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            child: Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/ForgetPassword');
                  },
                  textColor: Theme.of(context).hintColor,
                  child: Text('Olvidé mi Contraseña'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> login(String email, String password, BuildContext context) async {
    if (token != null && token.length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = driverlogin;
      http.post(url, body: {
        'email': email,
        'api_token': token
      }).then((response) {
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 1 || true) {
          //  DriverProfile profile = DriverProfile.fromJson(jsonData['data']);
            DriverProfile profile = new DriverProfile(1, '1', 'Carlos', 'images/admin/profile/08-02-21/080221103352pm-person.png' , '0998452106', '12345', 0.5, 0.5, token, '04-08-95', 1, '0998452106', 'true', '0998452106', 1,1);
            prefs.setInt('duty', 0);
            var delivery_id = int.parse('${profile.delivery_boy_id}');
            prefs.setInt("delivery_boy_id", delivery_id);
            prefs.setString("delivery_boy_name", profile.delivery_boy_name);
            prefs.setString("delivery_boy_image", profile.delivery_boy_image);
            prefs.setString("delivery_boy_phone", profile.delivery_boy_phone);
            prefs.setString("delivery_boy_pass", profile.delivery_boy_pass);
            prefs.setString("device_id", profile.device_id);
            prefs.setString("delivery_boy_status", profile.delivery_boy_status);
            prefs.setString("is_confirmed", profile.is_confirmed);
            var cityadmin_id = int.parse(
                '${(profile.cityadmin_id != null) ? profile.cityadmin_id : 0}');
            prefs.setInt("cityadmin_id", cityadmin_id);
            var phone_verify = int.parse('${profile.phone_verify}');
            prefs.setInt("phoneverifed", phone_verify);
            prefs.setBool("islogin", true);
            /*if (jsonData['currency'] != null &&
                jsonData['currency'].toString().length > 2) {
              CurrencyData currencyData =
              CurrencyData.fromJson(jsonData['currency']);

             */
              prefs.setString("curency", '\$');
            prefs.setBool("islogin", true);
          }

          Toast.show('Bienvenido a Freinar Express', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            Navigator.popAndPushNamed(
                context, PageRoutes.accountPage);

          } else {
            prefs.setBool("islogin", false);
            Toast.show('Datos Incorrectos', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            setState(() {
              showDialogBox = false;
            });
          }

       });
    } else {
      firebaseMessaging.getToken().then((value) {
        token = value;
        login(email, password, context);
      });
    }


  }

  void hitService(String name, String email, BuildContext context) async {
    Navigator.pushNamed(context, LoginRoutes.verification);

    /*
    if (token != null && token.toString().length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var phoneNumber = prefs.getString('user_phone');
      var url = registerApi;
      http.post(url, body: {
        'user_name': name,
        'user_email': email,
        'user_phone': phoneNumber,
        'user_password': 'no',
        'device_id': '${token}',
        'user_image': 'usre.png'
      }).then((value) {
        print('Response Body: - ${value.body.toString()}');
        if (value.statusCode == 200) {
          setState(() {
            showDialogBox = false;
          });
          Navigator.pushNamed(context, LoginRoutes.homepage);
        }
      });
    } else {
      firebaseMessaging.getToken().then((value) {
        setState(() {
          token = value;
        });
        print('${value}');
        hitService(name, email, context);
      });
    }

    */
  }

  void firebaseMessagingListener() async {
    if (Platform.isIOS) iosPermission();
    firebaseMessaging.getToken().then((value) {
      setState(() {
        token = value;
      });
    });
  }

  void iosPermission() {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered.listen((event) {});
  }
}

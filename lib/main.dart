import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/views/Login/Login.dart';
import 'package:flutter/material.dart';

import 'config/themes/ThemeDefault.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'OLX Clone',
    home: Login(),
    initialRoute: RouteGenerate.ROTA_LOGIN,
    onGenerateRoute: RouteGenerate.genetareRoutes,
    theme: temaPadrao,
  ));
}
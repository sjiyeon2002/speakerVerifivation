import 'package:flutter/material.dart';
import 'package:thisone/home.dart';
import 'package:thisone/fastapi.dart';
import 'package:mysql_client/mysql_client.dart';
//

void main() {
  //dbConnector(); // mySQLConnector.dart의 dbConnector 함수 호출
  runApp(const MyApp());    //MyApp() -> const MyApp()으로 변경
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

//
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      home: Home() //LoginPage()
    );
  }
}
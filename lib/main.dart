import 'package:flutter/material.dart';
import 'package:poetry_maker/components/helper.dart';
import 'package:poetry_maker/poetry_maker.dart';

void main() async {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        title: "Poetry Maker",
        // theme: ThemeData(
        //     colorScheme: ColorScheme.fromSwatch().copyWith(
        //   primary: Colors.blue[200],
        //   secondary: Colors.pinkAccent,
        // )),
        home: const SafeArea(child: PoetryMaker())),
  );
}

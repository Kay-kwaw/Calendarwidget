import 'package:calendarwidget/event_editing_page.dart';
import 'package:calendarwidget/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calendar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (BuildContext context) => EventProvider(),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainPage(),
        ),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('CalenderWidget'),
          centerTitle: true,
          backgroundColor: const Color(0xffF4A18A),
        ),
        body: const CalendarWidget(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffF4A18A),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventEditingPage()),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
}

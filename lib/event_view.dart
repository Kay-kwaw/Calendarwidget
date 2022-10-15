// import 'dart:html';

import 'package:calendarwidget/event.dart';
import 'package:calendarwidget/event_editing_page.dart';
import 'package:calendarwidget/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewPage extends StatelessWidget {
  final Event event;
  const EventViewPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('DETAILS'),
          leading: const CloseButton(),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => EventEditingPage(
                    event: event,
                  ),
                ),

              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final provider =
                    Provider.of<EventProvider>(context, listen: false);

                provider.deleteEvent(event);
              },
            ),
          ],
          //  buildViewingActions(),
          backgroundColor:const Color(0xffF4A18A),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                ('Personal Details'),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                "From:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                selectionColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                event.from.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                selectionColor: Colors.red,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                "To:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                selectionColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                event.to.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                selectionColor: Colors.red,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Text(
                "Program/Class Name:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                selectionColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                event.title,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                selectionColor: Colors.red,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              event.description,
              style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
            ),
          ],
        ),
      );

  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate(event.isAllDay ? 'All-day' : 'From', event.from),
        if (!event.isAllDay) buildDate('To', event.to),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    return Container();
    // Text(
    //   "Information",
    //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    // );
  }

//  List <Widget> buildViewingActions(BuildContext context, Event event) {
//    IconButton(
//       icon: const Icon(Icons.edit),
//       onPressed: () => Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => EventEditingPage(
//             event: event,
//           ),
//         ),
//       ),
//     );

}

  // buildViewingActions(BuildContext context, Event event) {
  //   IconButton(
  //     icon: const Icon(Icons.edit),
  //     onPressed: () => Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => EventEditingPage(
  //           event: event,
  //         ),
  //       ),
  //     ),
  //   );
    // IconButton(
    //   icon: const Icon(Icons.delete),
    //   onPressed: () {
    //     final provider = Provider.of<EventProvider>(context, listen: false);

    //     provider.deleteEvent(event);
    //   },
    // );
  // }


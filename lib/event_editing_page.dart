import 'package:calendarwidget/event.dart';
import 'package:calendarwidget/main.dart';
import 'package:calendarwidget/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event_provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({Key? key, this.event}) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formkey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF4A18A),
        leading: CloseButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          },
        ),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitle(),
                // buildNote(),
                const SizedBox(
                  height: 12,
                ),
                buildDateTimePickers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffF4A18A),
              shadowColor: Color(0xffF4A18A),
            ),
            onPressed: saveForm,
            icon: const Icon(Icons.done),
            label: const Text("SAVE")),
      ];

  Widget buildTitle() => Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          style: const TextStyle(fontSize: 15),
          decoration: const InputDecoration(
              border: UnderlineInputBorder(), hintText: 'Subject/Class Name'),
          onFieldSubmitted: (_) => saveForm(),
          validator: (title) => title != null && title.isEmpty
              ? "Subject/Class Name cannot be empty"
              : null,
          controller: titleController,
        ),
      );

  Widget buildDateTimePickers() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: buildHeader(
          header: 'Start',
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: buildDropdownField(
                    text: Utils.toDate(fromDate),
                    onClicked: () => pickFromDateTime(pickDate: true),
                  )),
              Expanded(
                  child: buildDropdownField(
                text: Utils.toTime(fromDate),
                onClicked: () => pickFromDateTime(pickDate: false),
              ))
            ],
          ),
        ),
      );

  Widget buildTo() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: buildHeader(
          header: 'End',
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: buildDropdownField(
                    text: Utils.toDate(toDate),
                    onClicked: () => pickToDateTime(pickDate: true),
                  )),
              Expanded(
                  child: buildDropdownField(
                text: Utils.toTime(toDate),
                onClicked: () => pickToDateTime(pickDate: false),
              ))
            ],
          ),
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2005, 8),
          lastDate: DateTime(2201));

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Widget buildDropdownField(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Row child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          child,
        ],
      );

  Future saveForm() async {
    final isValid = _formkey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        from: fromDate,
        description: 'Description',
        isAllDay: false,
        to: toDate,
      );

      final isEditing = widget.event != null;
      final provider = Provider.of<EventProvider>(context, listen: false);

      if (isEditing) {
        provider.editEvent(event, widget.event!);

        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
      }
      provider.addEvent(event);

      Navigator.of(context).pop();
    }
  }

  Widget buildNote() => Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Card(
                color: const Color(0xffF4A18A),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 12, //or null
                    decoration:
                        const InputDecoration.collapsed(hintText: "Notes"),
                    onSubmitted: (_) => saveForm(),
                    controller: noteController,
                  ),
                ))
          ],
        ),
      );
}

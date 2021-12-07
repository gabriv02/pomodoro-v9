import 'package:flutter/material.dart';
import 'package:flutter_circular_timer/api_service.dart';
import 'package:flutter_circular_timer/info.dart';
import 'package:flutter_circular_timer/list.dart';
import 'package:flutter_circular_timer/timer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(),
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
    );
  }
}

// ignore: must_be_immutable
class DemoApp extends StatefulWidget {
  Info? info;

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  // CountDownController _controller = CountDownController();
  // int _duration = 5;
  // bool _isPause = false;

  TextEditingController idController = TextEditingController();
  TextEditingController namController = TextEditingController();
  TextEditingController tarController = TextEditingController();

  ApiService apiService = ApiService();
  SharedPreferences? sharedPreferences;

  bool editable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            children: [
              Column(
                children: [
                  SizedBox(height: 30.0),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      hintText: "Id",
                      fillColor: Colors.white,
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: namController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      hintText: "Materia",
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: tarController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      hintText: "Tarea",
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        Info data = await apiService
                            .getInfoId(int.parse(idController.text));
                        getData(
                            data, idController, namController, tarController);
                      },
                      child: Text('Obtener tarea'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        Info info = Info(
                          api: 0,
                          name: namController.text.toString(),
                          tarea: tarController.text.toString(),
                        );
                        await apiService.postInfo(info);
                      },
                      child: Text('Agregar tarea'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () {
                        if (editable) {
                          Info info = Info(
                            api: int.parse(idController.text),
                            name: namController.text,
                            tarea: tarController.text,
                          );
                          apiService.putInfo(
                              int.parse(idController.text.toString()), info);
                          Navigator.pop(context);
                        }
                        setState(() {
                          editable = !editable;
                        });
                      },
                      child: const Text('Editar'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 200.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        Info info = Info(
                          api: 0,
                          name: namController.text.toString(),
                          tarea: tarController.text.toString(),
                        );

                        await apiService.deleteInfo(
                            int.parse(idController.text.toString()));
                      },
                      child: Text('eliminar tarea'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SecondRoute()));
                  },
                  child: const Text("Información")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CalRoute(
                                tittle: 'Calendario de tareas')));
                  },
                  child: const Text("Calendario")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Timer()));
                  },
                  child: const Text("Comenzar")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LISTA(
                                  tittle: 'tareas realizadas',
                                )));
                  },
                  child: const Text("Tareas realizadas")),
            ]),
      ),
    );
  }

  getData(
    Info data,
    TextEditingController id,
    TextEditingController nam,
    TextEditingController tar,
  ) {
    id.text = data.api.toString();
    nam.text = data.name.toString();
    tar.text = data.tarea.toString();
  }
}

// ignore: must_be_immutable
class SecondRoute extends StatelessWidget {
  SecondRoute({Key? key}) : super(key: key);

  TextEditingController idController = TextEditingController();
  TextEditingController namController = TextEditingController();
  TextEditingController tarController = TextEditingController();
  ApiService apiService = ApiService();
  SharedPreferences? sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información mostrada'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          Column(
            children: [
              const SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  hintText: "ID",
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: namController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  hintText: "Nombre",
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: tarController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  hintText: "Tarea",
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: () async {
                    List<Info> data = await apiService.getInfo();
                    getData(data, idController, namController, tarController);
                  },
                  child: const Text('Mostrar Info'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  child: const Text("Volver")),
            ],
          ),
        ],
      ),
    );
  }

  getData(
    List<Info> data,
    TextEditingController id,
    TextEditingController nam,
    TextEditingController tar,
  ) {
    id.text = data.first.api.toString();
    nam.text = data.first.name.toString();
    tar.text = data.first.tarea.toString();
  }
}

class CalRoute extends StatelessWidget {
  const CalRoute({Key? key, required this.tittle}) : super(key: key);
  final String tittle;
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      firstDayOfWeek: 6,
      initialDisplayDate: DateTime(2021, 03, 01, 08, 30),
      initialSelectedDate: DateTime(2021, 03, 01, 08, 30),
      dataSource: MeetingDataSource(getAppointments()),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting',
      color: Colors.blue,
      recurrenceRule: 'FREQ=DAILY;COUNT=10',
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

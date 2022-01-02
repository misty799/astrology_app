import 'package:astrology_app/Bloc/panchang_bloc.dart';
import 'package:astrology_app/Bloc/panchang_event.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late PanchangBloc _panchangBloc;
  @override
  void didChangeDependencies() {
    _panchangBloc = BlocProvider.of<PanchangBloc>(context);
    _panchangBloc.panchangEventSink.add(FetchPanchang());
    super.didChangeDependencies();
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _showDatePickerDialog() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime(DateTime.now().year + 1));
    setState(() {
      selectedDate = date!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _showDatePickerDialog();
          },
          child: Icon(Icons.menu),
        ),
        body: Container(
            margin: EdgeInsets.all(15),
            child: Column(children: [
              Row(
                children: const [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                  Text(
                    'Daily Panchang',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                  "India is a country known for its festival but knowing the exact dates can sometimes be difficult. To ensure you do not miss out on the critical dates we bring you the daily panchang"),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.deepOrange[100],
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(flex: 1, child: Text("Date:")),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(DateFormat('d MMM ,y')
                                          .format(selectedDate)),
                                      IconButton(
                                          onPressed: () {
                                            _showDatePickerDialog();
                                          },
                                          icon: Icon(Icons.arrow_drop_down))
                                    ],
                                  ),
                                ),
                              )
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(flex: 1, child: Text("Location:")),
                              Expanded(
                                flex: 3,
                                child: PopupMenuButton(
                                  child: GestureDetector(
                                    onTap: () {
                                      _panchangBloc.panchangEventSink
                                          .add(FetchPlaces());
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        color: Colors.white,
                                        child: Text('Delhi India')),
                                  ),
                                  itemBuilder: (context) {
                                    return List.generate(
                                        _panchangBloc.placeList.length, (i) {
                                      return PopupMenuItem(
                                          onTap: () {},
                                          value: _panchangBloc.placeList[i],
                                          child: Flexible(
                                              child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _panchangBloc
                                                  .placeList[i].placeName,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          )));
                                    });
                                  },
                                ),
                              ),
                            ])
                      ])),
              SizedBox(
                height: 10,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Tithi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const PanchangRowWidget(
                        firstText: "Tithi Number", secondText: "13"),
                    const PanchangRowWidget(
                        firstText: "Tithi Name",
                        secondText: "Shukla Trayodashi"),
                    const PanchangRowWidget(
                        firstText: "Special", secondText: "Jaya Tithi"),
                    const PanchangRowWidget(
                        firstText: "Summary",
                        secondText:
                            "Auspicious day to start important business ,wearing new clothes,fulfilment of promises and sensual pleasures."),
                    const PanchangRowWidget(
                        firstText: "Diety", secondText: "Cupid"),
                    PanchangRowWidget(
                        firstText: "End Time", secondText: "4 hr 42 min 15 sec")
                  ]
                      .map((e) => Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: e,
                          ))
                      .toList())
            ])));
  }
}

class PanchangRowWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  const PanchangRowWidget(
      {Key? key, required this.firstText, required this.secondText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Flexible(
          flex: 1,
          child: Text(
            firstText,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          )),
      Expanded(
          flex: 2,
          child: Text(
            secondText,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ))
    ]);
  }
}

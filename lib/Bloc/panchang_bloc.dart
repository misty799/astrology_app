import 'dart:async';
import 'dart:convert';
import 'package:astrology_app/Bloc/panchang_event.dart';
import 'package:astrology_app/Models/place.dart';
import 'package:http/http.dart' as http;

import 'package:bloc_provider/bloc_provider.dart';

class PanchangBloc extends Bloc {
  final placeUri =
      "https://www.astrotak.com/astroapi/api/Place/place?inputPlace=Delhi";

  List<Place> _placeList = [];
  List<Place> get placeList => _placeList;
  final StreamController<PanchangEvent> _panchangEventController =
      StreamController<PanchangEvent>.broadcast();
  Stream<PanchangEvent> get panchangEventStream =>
      _panchangEventController.stream;
  Sink<PanchangEvent> get panchangEventSink => _panchangEventController.sink;
  final StreamController<List<Place>> _placeDataController =
      StreamController<List<Place>>.broadcast();
  Stream<List<Place>> get placeDataStream => _placeDataController.stream;
  Sink<List<Place>> get placeDataSink => _placeDataController.sink;
  PanchangBloc() {
    panchangEventStream.listen(mapEventToState);
  }
  Future<void> mapEventToState(PanchangEvent event) async {
    if (event is FetchPlaces) {
      try {
        http.Response response = await http.get(Uri.parse(placeUri));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _placeList = [];
          for (int i = 0; i < data["data"].length; i++) {
            Place place = Place.fromJson(data["data"][i]);
            _placeList.add(place);
          }
          placeDataSink.add(_placeList);
        }
      } catch (e) {
        print(e);
      }
    } else if (event is FetchPanchang) {
      const panchang =
          'https://www.astrotak.com/astroapi/api/horoscope/daily/panchang';
      final Map<String, dynamic> body = {
        "day": '2',
        "month": '7',
        "year": '2021',
        "placeId": "ChIJL_P_CXMEDTkRw0ZdG-0GVvw"
      };

      final uri = Uri.parse(panchang);

      http.Response response = await http.post(uri, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
      } else {
        print("error");
      }
    }
  }

  @override
  void dispose() {
    _panchangEventController.close();
    _placeDataController.close();
  }
}

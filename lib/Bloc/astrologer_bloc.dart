import 'dart:async';
import 'dart:convert';

import 'package:astrology_app/Bloc/astrologer_event.dart';
import 'package:astrology_app/Models/astrologer.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:http/http.dart' as http;

class AstrologerBloc extends Bloc {
  final astrologerUri = "https://www.astrotak.com/astroapi/api/agent/all";
  List<Astrologer> _astrologerList = [];
  List<Astrologer> get astrologerList => _astrologerList;
  final StreamController<AstrologerEvent> _astrologerEventController =
      StreamController<AstrologerEvent>.broadcast();
  Stream<AstrologerEvent> get astrologerEventStream =>
      _astrologerEventController.stream;
  Sink<AstrologerEvent> get astrologerEventSink =>
      _astrologerEventController.sink;
  final StreamController<List<Astrologer>> _astrologerDataController =
      StreamController<List<Astrologer>>.broadcast();
  Stream<List<Astrologer>> get astrologerDataStream =>
      _astrologerDataController.stream;
  Sink<List<Astrologer>> get astrologerDataSink =>
      _astrologerDataController.sink;
  AstrologerBloc() {
    astrologerEventStream.listen(mapEventToState);
  }
  Future<void> mapEventToState(AstrologerEvent event) async {
    if (event is FetchAstrologer) {
      try {
        http.Response response = await http.get(Uri.parse(astrologerUri));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _astrologerList = [];
          for (int i = 0; i < data["data"].length; i++) {
            Astrologer astrologer = Astrologer.fromMap(data["data"][i]);
            _astrologerList.add(astrologer);
          }
          astrologerDataSink.add(_astrologerList);
        }
      } catch (e) {
        print(e);
      }
    } else if (event is FetchSortedAstrologer) {
      if (_astrologerList.isNotEmpty) {
        if (event.index == 0) {
          _astrologerList.sort((a, b) => b.experience.compareTo(a.experience));
        } else if (event.index == 1) {
          _astrologerList.sort((a, b) => a.experience.compareTo(b.experience));
        } else if (event.index == 2) {
          _astrologerList.sort((a, b) => b.price.compareTo(a.price));
        } else {
          _astrologerList.sort((a, b) => a.price.compareTo(b.price));
        }
        astrologerDataSink.add(_astrologerList);
      }
    }
  }

  @override
  void dispose() {
    _astrologerEventController.close();
  }
}

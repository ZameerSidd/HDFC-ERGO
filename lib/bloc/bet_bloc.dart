import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:hdfc/model/pet_model.dart';

import '../utils/utils.dart';

enum PetAction { list, detail, delete }

class PetBloc {
  final _streamController = StreamController<List<PetModel>>.broadcast();
  StreamSink<List<PetModel>> get counterSink => _streamController.sink;
  Stream<List<PetModel>> get counterStream => _streamController.stream;

  final _eventController = StreamController<PetAction>();
  StreamSink<PetAction> get eventSink => _eventController.sink;
  Stream<PetAction> get eventStream => _eventController.stream;

  final _searchController = StreamController<String>();
  StreamSink<String> get searchEventSink => _searchController.sink;
  Stream<String> get searchEventStream => _searchController.stream;

  PetBloc() {
    eventStream.listen((event) async {
      if (event == PetAction.list) {
        List<PetModel> petList = [];
        log('List');
        var petData = await Utils.getStringFromSF('pet_data');
        if (petData != null && petData.isNotEmpty) {
          List list = jsonDecode(petData);
          for (var element in list) {
            var model = PetModel.fromJson(element);
            petList.add(model);
          }
        }
        try {
          counterSink.add(petList);
          log(petList.length.toString());
        } on Exception catch (e) {
          log(e.toString());
        }
      }
    });
    searchEventStream.listen((event) async {
      List<PetModel> searchPetList = [];
      var petData = await Utils.getStringFromSF('pet_data');
      if (event.trim().isNotEmpty) {
        if (petData != null && petData.isNotEmpty) {
          List list = jsonDecode(petData);
          for (var item in list) {
            PetModel element = PetModel.fromJson(item);
            if (element.name != null &&
                element.name!
                    .toLowerCase()
                    .contains(event.trimRight().toLowerCase())) {
              log(element.name.toString());
              searchPetList.add(element);
            }
          }
          try {
            counterSink.add(searchPetList);
          } on Exception catch (e) {
            log(e.toString());
          }
        }
      } else {
        List<PetModel> petList = [];
        log('List');
        var petData = await Utils.getStringFromSF('pet_data');
        if (petData != null && petData.isNotEmpty) {
          List list = jsonDecode(petData);
          for (var element in list) {
            var model = PetModel.fromJson(element);
            petList.add(model);
          }
        }
        counterSink.add(petList);
      }
    });
  }

  void dispose() {
    _eventController.close();
    _streamController.close();
    _searchController.close();
  }
}

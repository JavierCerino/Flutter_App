import 'dart:io';
import 'dart:typed_data';

import 'package:giusseppe_flut/screens/house_creation.dart';

import '../models/house/house_model_update.dart';
import '../repository/house_repository.dart';

class HouseCreationPresenter {

  final HouseRepository houseRepository = HouseRepository();

  HouseModelUpdate? house;

  late HouseCreationView _backView = HouseCreationView();

  HouseCreationPresenter() {
  }

  void getTopDescriptions() async {
    List<String> descriptions = await houseRepository.getTopDescriptions();
    _backView.refreshHouseCreationView(descriptions);
  }

  void createHouse(String userId,String name, String housingType, String rentPrice, String description, String city, String neighborhood, String address, String floor, String appartmentArea, String roomsNumber, String roomArea, String bathroomNumber, String stratum, bool elevator, bool furnished, bool gymnasium, bool internet, bool laundryArea, bool pets, bool reception, bool smoke, bool supermarkets, bool tv, bool vape, List<File> images) async {
    try {
      String path = "/images_houses/${name}_${city}_${neighborhood}_$address/";
      List<String> imagesUrls = await houseRepository.uploadHouseImages(path, images);
      HouseModelUpdate house = HouseModelUpdate(id: "", name: name, city: city, neighborhood: neighborhood, address: address, housingType: housingType, rentPrice: double.parse(rentPrice), stratum: int.parse(stratum), area: double.parse(appartmentArea), apartmentFloor: int.parse(floor), roomsNumber: int.parse(roomsNumber), roomArea: double.parse(roomArea), bathroomsNumber: int.parse(bathroomNumber), laundryArea: laundryArea, internet: internet, tv: tv, furnished: furnished, elevator: elevator, gymnasium: gymnasium, reception: reception, supermarkets: supermarkets, description: description, rating: 5, longitude: -74.069, latitude: 4.6487, images: imagesUrls);
      houseRepository.createHouse(house);
    } catch (error) {
      rethrow;
    }
  }

  set backView(HouseCreationView value) {
    _backView = value;
  }

}
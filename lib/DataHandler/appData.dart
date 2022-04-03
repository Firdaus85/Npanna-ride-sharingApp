import 'package:flutter/cupertino.dart';
import 'package:ridesharingapp/Models/address.dart';

class AppData extends ChangeNotifier {
   Address? pickUpLocation, dropOffLocation;

  void updatePickupLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAdress) {
    dropOffLocation = dropOffAdress;
    notifyListeners();
  }
}

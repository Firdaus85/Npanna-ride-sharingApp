import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ridesharingapp/Assistants/requestAssistant.dart';
import 'package:ridesharingapp/DataHandler/appData.dart';
import 'package:ridesharingapp/Models/address.dart';
import 'package:ridesharingapp/Models/directDetails.dart';
import 'package:ridesharingapp/configMaps.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      //placeAddress =  response["results"][0]["formatted_address"];

      st1 = response["results"][0]["address_components"][3]["short_name"];
      st2 = response["results"][0]["address_components"][4]["short_name"];
      st3 = response["results"][0]["address_components"][5]["short_name"];
      st4 = response["results"][0]["address_components"][6]["short_name"];

      //placeAddress = st1 + ", " + st2 + ", " + st4;
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickUpAddress =  Address(
          latitude: position.latitude,
          longitude: position.longitude,
          placeName: placeAddress);
      //userPickUpAddress.longitude = position.longitude;
      //userPickUpAddress.latitude = position.latitude;
      //userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async{
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$mapKey";


    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(encodedPoints: ''
      );

    directionDetails.encodedPoints=res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText=res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue=res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText=res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue=res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  
  }
}

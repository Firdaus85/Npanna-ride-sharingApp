import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridesharingapp/Assistants/requestAssistant.dart';
import 'package:ridesharingapp/DataHandler/appData.dart';
import 'package:ridesharingapp/Models/address.dart';
import 'package:ridesharingapp/Models/placePredictions.dart';
import 'package:ridesharingapp/allWidgets/Divider.dart';
import 'package:ridesharingapp/allWidgets/progressDialog.dart';
import 'package:ridesharingapp/configMaps.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String? placeAddress =
        Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 215.0,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ]),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 25.0,
                  top: 25.0,
                  right: 25.0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.0,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back),
                        ),
                        Center(
                          child: Text(
                            'Set Drop off',
                            style:
                                TextStyle(fontSize: 18.0, fontFamily: 'Lato'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/user_icon.png",
                          height: 20.0,
                          width: 20.0,
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickUpTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "My location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18.0,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/destination_icon.png",
                          height: 20.0,
                          width: 20.0,
                        ),
                        SizedBox(
                          height: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (value) {
                                  findPlace(value);
                                },
                                controller: dropOffTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Where to?",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //tile for predictions

            SizedBox(
              height: 10.0,
            ),

            (placePredictionList.length > 0)
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                            placePredictions: placePredictionList[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autocompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&components=country:gh";

      var res = await RequestAssistant.getRequest(autocompleteUrl);

      if (res == "failed") {
        return;
      }

      if (res["status"] == "OK") {
        var predictions = res['predictions'];

        var placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionList = placeList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  const PredictionTile({Key? key, required this.placePredictions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceAddressDetails(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 14.0,
            ),
            Row(
              children: [
                Icon(Icons.place),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: 14.0,
            ),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Setting Dropoff, please wait..."));

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if (res == "failed") {
      return;
    }

    if (res["status"] == "OK") {
      Address address = Address(
          longitude: res["result"]["geometry"]["location"]["lng"],
          placeName: res["result"]["name"],
          latitude: res["result"]["geometry"]["location"]["lat"]);
     /* address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];*/

      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      print("this is drop off location :: ");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");
    }
  }
}

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoover/datamodels/address.dart';
import 'package:hoover/datamodels/directiondetails.dart';
import 'package:hoover/datamodels/ouruser.dart';

import 'package:hoover/dataprovider/appdata.dart';
import 'package:hoover/globalVariables.dart';
import 'package:hoover/helpers/requesthelper.dart';
import 'package:provider/provider.dart';

class HelperMethods {
  static void getCurrentUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    String userId = currentFirebaseUser.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/$userId');
    userRef.once().then((DataSnapshot snapshot) {
      currentUserInfo =
          snapshot.value != null ? OurUser.fromSnapshot(snapshot) : null;
      print('my name is ${currentUserInfo.fullName}');
    });
  }

  static Future<String> findCoordinateAddress(
      Position position, context) async {
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    if (response != 'Failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      //use provider to update the address fpt the other the other view.
      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKey';
    var response = await RequestHelper.getRequest(url);

    if (response == 'Failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];

    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details) {
    //mile = 1.1
    //min = 0.3
    //base = 5
    double baseFare = 3;
    double distanceFare = details.distanceValue / 1000 * 1.1;
    double durationFare = details.durationValue / 60 * 0.3;

    double totalFare = baseFare + distanceFare + durationFare;

    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomNumberGenerator = Random();
    int randInt = randomNumberGenerator.nextInt(max);

    return randInt.toDouble();
  }

  static sendNotification(String token, context, String rideId) async {
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };

    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination.placeName}'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': rideId,
    };

    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token
    };

    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: headerMap, body: jsonEncode(bodyMap));

    print(response.body);
  }
}

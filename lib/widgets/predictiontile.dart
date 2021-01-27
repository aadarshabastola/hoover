import 'package:flutter/material.dart';
import 'package:hoover/datamodels/address.dart';
import 'package:hoover/datamodels/prediction.dart';
import 'package:hoover/dataprovider/appdata.dart';
import 'package:hoover/helpers/requesthelper.dart';
import 'package:hoover/screens/brand_colors.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../globalVariables.dart';
import 'ProgressDialog.dart';

class PredicitonTile extends StatelessWidget {
  final Prediction prediction;

  PredicitonTile({this.prediction});

  void getPlaceDetails(String placeId, context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Loading...',
            ));

    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    Navigator.pop(context);

    if (response == 'Failed') {
      return;
    }

    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeId;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlace);

      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(prediction.placeId, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      OMIcons.locationOn,
                      color: BrandColors.colorDimText,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prediction.mainText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            prediction.secondaryText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 12, color: BrandColors.colorDimText),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

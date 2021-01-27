import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'datamodels/ouruser.dart';

String mapKey = 'AIzaSyCwN40u4S-ptB-0clf67AZIKAzRmYgQ8aY';

String serverKey =
    'AAAALNQLJPo:APA91bH0XXBkT_DZllNuZ50mDhoIseCr10qFrSWEKirI3uUfw6_-uwCYFxGoUkNuJdCe196qDOxbNXW8pwrB1WykTUQszKkB8jD2Yv9LeARro5fBAwGiY8Dh-g6hetYYVrgnYcg8XKlr';

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

User currentFirebaseUser;
OurUser currentUserInfo;

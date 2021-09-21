import 'package:sportify_app/modals/Activity.dart';

class BikeActivity extends ActivityWithGeolocation {
  BikeActivity({String ownerId}) {
    this.activityType = ActivityType.Bike;
    this.ownerId = ownerId;
    this.createdAt = DateTime.now();
  }
}

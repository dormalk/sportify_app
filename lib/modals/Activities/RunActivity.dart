import 'package:sportify_app/modals/Activity.dart';

class RunActivity extends ActivityWithGeolocation {
  RunActivity({String ownerId, Function onLocationUpdate}) {
    this.activityType = ActivityType.Run;
    this.ownerId = ownerId;
    this.createdAt = DateTime.now();
  }
}

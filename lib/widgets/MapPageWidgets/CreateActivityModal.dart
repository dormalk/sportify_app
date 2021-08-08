import 'package:flutter/material.dart';
import 'package:sportify_app/modals/Activity.dart';
import 'package:sportify_app/shared/Labels.dart';
import 'package:sportify_app/providers/Tracker.dart';
import 'package:provider/provider.dart';

class CreateActivityModal extends StatelessWidget {
  const CreateActivityModal({Key key}) : super(key: key);

  Widget _buildIconButton({IconData icon, Function onPress}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Icon(
          icon,
          size: 35,
        ),
      ),
      onTap: onPress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(Labels.CREATE_ACTIVITY_MODAL_TITLE)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(
              icon: mapActivityIcon[ActivityType.Bike],
              onPress: () {
                Provider.of<Tracker>(context, listen: false)
                    .startRecord(ActivityType.Bike);
                Navigator.of(context).pop();
              }),
          _buildIconButton(
              icon: mapActivityIcon[ActivityType.Run],
              onPress: () {
                Provider.of<Tracker>(context, listen: false)
                    .startRecord(ActivityType.Run);
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}

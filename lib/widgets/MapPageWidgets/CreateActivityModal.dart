import 'package:flutter/material.dart';
import 'package:sportify_app/shared/Labels.dart';

class CreateActivityModal extends StatelessWidget {
  const CreateActivityModal({Key key}) : super(key: key);

  Widget _buildIconButton({IconData icon, Function onPress}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
              icon: Icons.directions_bike, onPress: () => print('bike')),
          _buildIconButton(
              icon: Icons.directions_run, onPress: () => print('run')),
        ],
      ),
    );
  }
}

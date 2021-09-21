import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportify_app/providers/Activities.dart';
import 'package:sportify_app/providers/TrackerInfo.dart';
import 'package:sportify_app/shared/Colors.dart';

class ActivityPauseRow extends StatefulWidget {
  const ActivityPauseRow({Key key}) : super(key: key);

  @override
  _ActivityPauseRowState createState() => _ActivityPauseRowState();
}

class _ActivityPauseRowState extends State<ActivityPauseRow>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  void dispose() {
    _controller.animateBack(0, duration: Duration(seconds: 1));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool recordIsPaused =
        Provider.of<TrackerInfo>(context, listen: true).recordIsPaused;
    if (recordIsPaused) {
      _controller.forward();
    } else {
      _controller.animateBack(0, duration: Duration(seconds: 1));
    }
    return SizeTransition(
      sizeFactor: _animation,
      axis: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: double.infinity,
        color: CustomColor.primaryColor,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'YOU DID A GREAT JOB!!!',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  var trackerInfo =
                      Provider.of<TrackerInfo>(context, listen: false);
                  Provider.of<Activities>(context, listen: false)
                      .addActivity(trackerInfo.pickedActivity);
                  trackerInfo.stopActivity();
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red),
                  child: Text(
                    'POST AS CHALLENGE',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
            IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[500],
                ),
                onPressed: () =>
                    Provider.of<TrackerInfo>(context, listen: false)
                        .stopActivity())
          ],
        ),
      ),
    );
  }
}

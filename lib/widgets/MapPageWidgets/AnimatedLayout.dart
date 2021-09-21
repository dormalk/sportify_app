import 'package:flutter/material.dart';
import 'package:sportify_app/widgets/MapPageWidgets/MainMap.dart';
import 'package:sportify_app/widgets/MapPageWidgets/TrackerInformationCard/TrackerInformationCard.dart';

class AnimatedLayout extends StatefulWidget {
  final bool openMode;
  const AnimatedLayout({Key key, @required this.openMode}) : super(key: key);

  @override
  _AnimatedLayoutState createState() => _AnimatedLayoutState();
}

class _AnimatedLayoutState extends State<AnimatedLayout>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Size> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 0), end: Size(double.infinity, 0.30))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  Widget _buildLayer({Widget child, double height}) {
    double offset = widget.openMode ? 0 : kBottomNavigationBarHeight;
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height -
                  offset -
                  MediaQuery.of(context).padding.top) *
              height,
          minHeight: 0),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.openMode ? _controller.forward() : _controller.reverse();
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (ctx, _) => Wrap(alignment: WrapAlignment.start, children: [
        _buildLayer(
            child: TrackerInformationCard(),
            height: _heightAnimation.value.height),
        _buildLayer(child: MainMap(), height: 1.0)
      ]),
    );
  }
}

import 'package:flutter/material.dart';

abstract class StatelessWidgetCommon extends StatelessWidget {

  const StatelessWidgetCommon({super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: (_) {},
      onPointerDown: (_) {
      },
      onPointerUp: (_) {},
      onPointerSignal: (_) {

      },
      onPointerMove: (_) {},
      child: rootWidget(context),
    );
  }

  Widget rootWidget(BuildContext context);
}


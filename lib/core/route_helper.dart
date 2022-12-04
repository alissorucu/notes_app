// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

Future<void> nextScreen(
    BuildContext context, Widget page, String routeName) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => page, settings: RouteSettings(name: routeName)),
  );
}

void nextScreenAnimated(
  BuildContext context,
  Widget page,
  String routeName,
  RouteFrom routeFrom,
) {
  Navigator.push(context, SlidRoute(page, routeFrom, routeName));
}

void nextScreenCloseOthers(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenCloseOthersAnimated(
  BuildContext context,
  Widget page,
  String routeName,
  RouteFrom routeFrom,
) {
  Navigator.pushAndRemoveUntil(
      context, SlidRoute(page, routeFrom, routeName), (route) => false);
}

void nextScreenReplace(BuildContext context, Widget page, String routeName) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => page,
          settings: RouteSettings(name: routeName)));
}

Future<void> nextScreenSlide(BuildContext context, Widget page,
    String routeName, RouteFrom routeFrom) async {
  await Navigator.push(context, SlidRoute(page, routeFrom, routeName));
}

enum RouteFrom {
  TOP(Offset(0, -1)),
  BOTTOM(Offset(0, 1)),
  RIGHT(Offset(1, 0)),
  LEFT(Offset(-1, 0));

  const RouteFrom(this.offset);
  final Offset offset;
}

class SlidRoute extends PageRouteBuilder {
  final Widget page;
  final RouteFrom routeFrom;
  final String routeName;

  SlidRoute(this.page, this.routeFrom, this.routeName)
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                SlideTransition(
                  position: Tween<Offset>(
                    begin: routeFrom.offset,
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
            settings: RouteSettings(name: routeName));
}

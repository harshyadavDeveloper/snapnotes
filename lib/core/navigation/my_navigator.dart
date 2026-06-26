import 'package:flutter/material.dart';

class MyNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get _navigator => navigatorKey.currentState;

  static BuildContext? get context => navigatorKey.currentContext;

  static Future<T?> push<T>(Route<T> route) {
    return _navigator!.push(route);
  }

  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator!.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> route, {
    TO? result,
  }) {
    return _navigator!.pushReplacement(route, result: result);
  }

  static void pop<T extends Object?>([T? result]) {
    if (_navigator?.canPop() ?? false) {
      _navigator?.pop(result);
    }
  }

  static Future<T?> pushAndRemoveUntil<T>(Route<T> route) {
    return _navigator!.pushAndRemoveUntil(route, (route) => false);
  }

  static bool canPop() {
    return _navigator?.canPop() ?? false;
  }
}

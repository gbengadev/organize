//Filter a stream to return a list based on certain conditions
import 'package:flutter/material.dart';

extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}

//Parse argument between pages
extension GetArgument on BuildContext {
  T? getArgument<T>() {
    //'this' refers to the build context
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}

import 'package:flutter/material.dart';

abstract class BaseNotifier extends ChangeNotifier {
  bool _isLoading = false;

  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<T?> execute<T>(Future<T> Function() action) async {
    try {
      setLoading(true);

      setError(null);

      return await action();
    } catch (e) {
      setError(e.toString());

      return null;
    } finally {
      setLoading(false);
    }
  }
}

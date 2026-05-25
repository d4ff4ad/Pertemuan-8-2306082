import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/photo_service.dart';

class PhotoProvider with ChangeNotifier {
  List<PhotoModel> _photos = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<PhotoModel> get photos => _photos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPhotos() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _photos = await PhotoService.getPhotos();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

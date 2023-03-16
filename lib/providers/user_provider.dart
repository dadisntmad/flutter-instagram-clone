import 'package:flutter/widgets.dart';
import 'package:instagram/models/user_model.dart';
import 'package:instagram/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final _authService = AuthService();

  UserModel? get user => _user;

  Future<void> getCurrentUser() async {
    UserModel user = await _authService.getCurrentUser();
    _user = user;
    notifyListeners();
  }
}

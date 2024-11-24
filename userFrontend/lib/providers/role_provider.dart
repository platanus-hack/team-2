// lib/providers/role_provider.dart
import 'package:flutter/foundation.dart';

class RoleProvider with ChangeNotifier {
  String _selectedRole = 'Engineer';

  String get selectedRole => _selectedRole;

  void updateRole(String newRole) {
    _selectedRole = newRole;
    notifyListeners();
  }
}
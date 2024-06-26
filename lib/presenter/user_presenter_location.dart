
import 'dart:async';

import '../models/user/user_model.dart';
import '../repository/user_repository.dart';
import '../screens/base_mvp/base_mvp_location.dart';
import '../screens/base_mvp/views_abs.dart';
import '../service/connectivity_manager_service.dart';

class UserListPresenterLocation {
  final UserRepository userRepository = UserRepository();
  List<UserModel>? usersList = [];
  late UserListViewLocation _backView= UserListViewLocation();

  UserListPresenterLocation(){

  }
  void getNearUsers(double latitud, double longitud) async {
    try {
      List<UserModel>? users = [];
      users = await userRepository.getDocumentsWithinRadiusPagination(latitud!,longitud!);
      if (users != null) {
        usersList = users;
        _backView.refreshUserListView(usersList!);
      }
    } catch (error) {
      rethrow;
    }
  }

  set backView(UserListViewLocation value) {
    _backView = value;
    _backView.refreshUserListView(usersList!);
  }


}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:giusseppe_flut/models/user/query_filter_user.dart';
import 'package:giusseppe_flut/models/user/query_likes_user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:giusseppe_flut/service/backend_service.dart';

import '../../models/user/user_model.dart';
import 'abstract/base_user_dao.dart';

final storageRef = FirebaseStorage.instance.ref();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class UserDaoFireStore extends UserDao {
  Future<Uint8List?> getImage(String image) async {
    final ref = storageRef.child(image);
    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await ref.getData(oneMegabyte);
      return data;
    } on FirebaseException catch (e) {
      // Handle any errors.
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = [];
    try {
      final querySnapshot = await firestore.collection("Users").get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var user = querySnapshot.docs[i];
        final userData = user.data();
        final userId = user.id;
        var userModel = UserModel.fromJson({...userData, 'id': userId});

        users.add(userModel);
      }
      return users;
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching users: $error");
      }
      rethrow;
    }
  }

  Future<List<UserModel>> getTopUsers() async {
    List<UserModel> users = [];
    try {
      final querySnapshot = await BackendService().getAll("best/users");
      if (querySnapshot.isEmpty) {
        return [];
      } else {
        users = await compute(parseObjects, querySnapshot);
      }
      return users;
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching users: $error");
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    try {
      final querySnapshot = await firestore.collection("Users").doc(id).get();
      final userData = querySnapshot.data();
      final userId = querySnapshot.id;

      if (userData != null) {
        final userModel = UserModel.fromJson({...userData, 'id': userId});
        return userModel;
      } else {
        throw Exception("No data found for ID: $id");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching users: $error");
      }
      rethrow;
    }
  }

  Stream<List<UserModel>> getUsersByPreferencesStream() {
    final controller = StreamController<List<UserModel>>();

    try {
      Query query = firestore.collection("Users");

      final stream = query.snapshots();
      stream.listen((querySnapshot) {
        List<UserModel> users = [];

        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var user = querySnapshot.docs[i];
          final userData = user.data() as Map<String, dynamic>;
          final userId = user.id;
          UserModel nuevoUsuario =
              UserModel.fromJson({...userData, 'id': userId});
          users.add(nuevoUsuario);
        }

        controller.add(users);
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching users by filter: $error");
      }
      controller.addError(error);
    }

    return controller.stream;
  }

  Future<List<UserModel>> getAllUsersByPreferences(
      UserPreferencesDTO userPreferences) {
    throw UnimplementedError();
  }

  Future<List<UserModel>> getUsersByPreferences(
      {int skip = 0, int limit = 5}) async {
    try {
      List<UserModel> users = [];
      final querySnapshot = await BackendService()
          .postAll("users/filtered", UserFilter(), skip: skip, limit: limit);
      if (querySnapshot.isNotEmpty) {
        users = await compute(parseObjects, querySnapshot);
      }
      return users;
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching users by searching: $error");
      }
      rethrow;
    }
  }

  Future<List<UserModel>> getDocumentsWithinRadius(
      double latitude, double longitude) async {
    List<UserModel> users = [];
    Map<String, dynamic> mapa = {'latitude': latitude, 'longitude': longitude};
    final querySnapshot =
        await BackendService().postAll("users/ubication", mapa);
    users = await compute(parseObjects, querySnapshot);
    return users;
  }

  Future<List<UserModel>> getDocumentsWithinTotal(
      double latitude, double longitude) async {
    List<UserModel> users = [];
    Map<String, dynamic> mapa = {'latitude': latitude, 'longitude': longitude};
    final querySnapshot =
        await BackendService().postAll("users/ubication/total", mapa);
    users = await compute(parseObjects, querySnapshot);
    return users;
  }

  Future<List<UserModel>> getLenghtWithinRadius(
      double latitude, double longitude, int skip, int limit) async {
    try {
      Map<String, dynamic> mapa = {
        'latitude': latitude,
        'longitude': longitude
      };
      final querySnapshot =
          await BackendService().postTot("users/ubication", mapa);
      final decodeMessage = json.decode(querySnapshot);
      if (decodeMessage['message'] != 'Total Users') {
        throw decodeMessage['message'];
      }
      return decodeMessage['count'];
    } catch (error) {
      if (kDebugMode) {
        print("Error searching for users: $error");
      }
      rethrow;
    }
  }

  Future<int> getLenght() async {
    try {
      final message =
          await BackendService().postTot("total/users", UserFilter());
      final decodeMessage = json.decode(message);
      if (decodeMessage['message'] != 'Total Users') {
        throw decodeMessage['message'];
      }
      return decodeMessage['count'];
    } catch (error) {
      if (kDebugMode) {
        print("Error searching for users: $error");
      }
      rethrow;
    }
  }

  @override
  Future<UserModel?> validateEmailAndPassword(
      String email, String password) async {
    try {
      final querySnapshot = await firestore
          .collection("Users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var userData = querySnapshot.docs[i].data();
          var userId = querySnapshot.docs[i].id;
          var storedPasswordHash = userData['password'];

          if (password == storedPasswordHash) {
            if (userData != null) {
              var userModel = UserModel.fromJson({...userData, "id": userId});
              return userModel;
            }
          }
        }
      }

      return null;
    } catch (error) {
      if (kDebugMode) {
        print("Error validating email and password: $error");
      }
      rethrow;
    }
  }

  @override
  Future<UserModel?> createUser(
      String email,
      String password,
      String fullname,
      int age,
      String phone,
      String genero,
      String city,
      String locality) async {
    try {
      String bringPeople = '';
      int sleep = 0;
      int phoneFin = int.parse(phone);
      bool vape = false;
      String personality = '';
      bool likesPets = false;
      String clean = '';
      bool smoke = false;
      double lat = 4.601932494220323;
      double long = -74.0653645602065;
      int star = 5;

      Map<String, dynamic> toJson() => {
            'age': age,
            'longitude': long,
            'rol': 'Renter',
            'full_name': fullname,
            'bring_people': bringPeople,
            'city': city,
            'vape': vape,
            'password': password,
            'image':
                'https://firebasestorage.googleapis.com/v0/b/senehouse-v2.appspot.com/o/images_profile%2Ffemale%2F2.jpg?alt=media&token=ac719683-e4ef-47bb-b3ea-fb429179fc1d',
            'phone': phoneFin,
            'smoke': smoke,
            'locality': locality,
            'clean': clean,
            'likes_pets': likesPets,
            'latitude': lat,
            'gender': genero,
            'stars': star,
            'personality': personality,
            'sleep': sleep,
            'email': email
          };

      final querySnapshot = await firestore
          .collection("Users")
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        final docRef = await firestore.collection("Users").add(toJson());
        final docSnapshot = await docRef.get();
        final userData = docSnapshot.data();
        final userId = docSnapshot.id;
        if (userData != null) {
          final userModel = UserModel.fromJson({...userData, 'id': userId});
          return userModel;
        } else {
          throw Exception("User not created");
        }
      } else {
        throw Exception("User already exists");
      }
    } catch (error) {
      if (kDebugMode) {
        throw Exception("Error creating user: $error");
      }
      rethrow;
    }
  }

  Future<void> updateUserPreferencesStats() async {
    try {
      BackendService().putAll("stats/usersfilters", UserFilter());
    } catch (error) {
      if (kDebugMode) {
        print("Error updating preferences stats: $error");
      }
      rethrow;
    }
  }

  getDocumentsWithinRadiusPagination(
      double latitude, double longitude) async {
    List<UserModel> users = [];
    Map<String, dynamic> mapa = {'latitude': latitude, 'longitude': longitude};
    final querySnapshot = await BackendService()
        .postAll("users/ubication", mapa);
    users = await compute(parseObjects, querySnapshot);
    return users;
  }
}

Future<List<UserModel>> parseObjects(List<dynamic> querySnapshot) async {
  List<UserModel> users = [];
  for (int i = 0; i < querySnapshot.length; i++) {
    UserModel nuevoUsuario = UserModel.fromJson({...querySnapshot[i]});
    users.add(nuevoUsuario);
  }
  return users;
}

Future<List<UserModel>> parseObjectsLocation(
    Map<dynamic, dynamic> variables) async {
  List<UserModel> users = [];
  for (var user in variables['snapshot']) {
    if (user["longitude"] >= variables['minLon'] &&
        user['maxLon'] <= variables["maxLon"]) {
      users.add(UserModel.fromJson({...user}));
    }
  }
  return users;
}

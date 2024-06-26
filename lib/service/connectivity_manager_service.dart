import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';
import 'package:get/get.dart';

class ConnectivityManagerService {
  
  static final ConnectivityManagerService _instance = ConnectivityManagerService._internal();

  factory ConnectivityManagerService() {
    return _instance;
  }

  ConnectivityManagerService._internal();
  
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  late bool connectivity=false;

  void initialize() {
    Connectivity().onConnectivityChanged.listen((result) async {
      final isDeviceConnected = await InternetConnectionChecker().hasConnection;
      connectivity = isDeviceConnected;
      _connectionStatusController.add(isDeviceConnected);
    });

    // Add a post-frame callback to ensure the context is available
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      emitStatus();
    });
  }

  void emitStatus() {
    InternetConnectionChecker().hasConnection.then((isConnected) {
      connectivity = isConnected;
      connectivitySnackbar();
    });
  }

}
part of 'internet_bloc.dart';

enum ConnectionType { WIFI, MOBILE }

abstract class Internetstate {}

class InternetInitialState extends Internetstate {}

class InternetConnectionOnlineState extends Internetstate {
  final ConnectionType connectionType;

  InternetConnectionOnlineState({required this.connectionType});
}

class InternetConnectionOfflineState extends Internetstate {}

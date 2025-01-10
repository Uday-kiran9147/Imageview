part of 'internet_bloc.dart';

abstract class InternetEvent {}

class ConnectToInternet extends InternetEvent {
  final ConnectionType connectionType;

  ConnectToInternet({required this.connectionType});
}

class DisconnectFromInternet extends InternetEvent {}

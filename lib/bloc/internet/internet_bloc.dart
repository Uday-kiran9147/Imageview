import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, Internetstate> {
  final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;

  InternetBloc({required this.connectivity}) : super(InternetInitialState()) {
    print("InternetBloc created");
    // Listen for connectivity changes and emit states accordingly
    connectivityStreamSubscription = connectivity.onConnectivityChanged.listen((newConnectivityResult) {
      if (newConnectivityResult[0] == ConnectivityResult.mobile) {
        add(ConnectToInternet(connectionType: ConnectionType.MOBILE));
        print("Added Mobile connection");
      } else if (newConnectivityResult[0] == ConnectivityResult.wifi) {
        add(ConnectToInternet(connectionType: ConnectionType.WIFI));
        print("Added Wifi connection");
      } else if (newConnectivityResult[0] == ConnectivityResult.none) {
        add(DisconnectFromInternet());
        print("Added Disconnected");
      }
    });

    // Handle events
    on<ConnectToInternet>(_connectToInternet);
    on<DisconnectFromInternet>(_disconnectFromInternet);
  }

  @override
  void onChange(Change<Internetstate> change) {
    print(change);
    super.onChange(change);
  }
  // Emit state when connected to the internet
  void _connectToInternet(ConnectToInternet event, Emitter<Internetstate> emit) {
    emit(InternetConnectionOnlineState(connectionType: event.connectionType));
  }

  // Emit state when disconnected from the internet
  void _disconnectFromInternet(DisconnectFromInternet event, Emitter<Internetstate> emit) {
    emit(InternetConnectionOfflineState());
  }

  @override
  Future<void> close() {
    // Cleanup the subscription
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}

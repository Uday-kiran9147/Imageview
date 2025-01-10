import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imageview/bloc/Image/image_bloc.dart';
import 'package:imageview/bloc/internet/internet_bloc.dart';
import 'package:imageview/pages/gallery_page.dart';
import 'package:imageview/services/api_service.dart';

void main() {
  runApp(MyApp(Connectivity(),ApiService()));
}

class MyApp extends StatelessWidget {
  MyApp(this.connectivity,this.apiService);
  Connectivity connectivity;
  ApiService apiService;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> InternetBloc(connectivity: connectivity)),
        BlocProvider(
          create: (context) => ImageBloc(apiService),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Image Gallery',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: GalleryScreen(),
      ),
    );
  }
}

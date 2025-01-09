// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imageview/bloc/image_bloc.dart';
import 'package:imageview/pages/gallery_page.dart';
import 'package:imageview/services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageBloc(ApiService()),
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

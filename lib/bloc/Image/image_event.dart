part of 'image_bloc.dart';

@immutable
abstract class ImageEvent {}

class FetchImages extends ImageEvent {}

class LoadMoreImages extends ImageEvent {}

part of 'image_bloc.dart';

@immutable
abstract class ImageState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoadingMore extends ImageLoaded {
  final List<dynamic> images;
  ImageLoadingMore(this.images):super(images: images);
}

class ImageLoaded extends ImageState {
  final List<dynamic> images;
  ImageLoaded({required this.images});
}

class ImageError extends ImageState {
  final String message;
  ImageError({required this.message});
}

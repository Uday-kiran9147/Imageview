import 'package:bloc/bloc.dart';
import 'package:imageview/services/api_service.dart';
import 'package:meta/meta.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ApiService apiService;
  int currentPage = 2;
  bool isFetching = false;


  ImageBloc(this.apiService) : super(ImageInitial()) {
    on<FetchImages>(_onFetchImages);
    on<LoadMoreImages>(_onLoadMoreImages);
  }

  @override
  void onChange(Change<ImageState> change) {
    super.onChange(change);
    print(change);
  }

  void _onFetchImages(FetchImages event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      final images = await apiService.fetchImages(currentPage, 40);
      emit(ImageLoaded(images: images));
    } catch (e) {
      emit(ImageError(message: e.toString()));
    }
  }

  void _onLoadMoreImages(LoadMoreImages event, Emitter<ImageState> emit) async {
    if (!isFetching) {
      emit(ImageLoadingMore((state as ImageLoaded).images));
      isFetching = true;
      try {
        final images = await apiService.fetchImages(currentPage, 40);
        currentPage++;
        emit(ImageLoaded(images: (state as ImageLoaded).images + images));
      } catch (e) {
        emit(ImageError(message: e.toString()));
      } finally {
        isFetching = false;
      }
    }
  }
}

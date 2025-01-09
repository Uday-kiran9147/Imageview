// lib/screens/gallery_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imageview/pages/full_image_page.dart';
import 'package:imageview/widgets/image_tile.dart';
import 'package:imageview/widgets/image_tile_list.dart';
import 'package:imageview/widgets/loading_indicator.dart';
import 'package:imageview/bloc/image_bloc.dart';
import 'package:imageview/services/api_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late ImageBloc _imageBloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _imageBloc = ImageBloc(ApiService());
    _scrollController = ScrollController()..addListener(_scrollListener);
    _imageBloc.add(FetchImages());
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _imageBloc.add(LoadMoreImages());
    }
  }

  bool _showList = false;

  void _toggleImageLayout() {
    setState(() {
      _showList = !_showList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          _imageBloc.add(FetchImages());
        },
        child: BlocBuilder<ImageBloc, ImageState>(
          bloc: _imageBloc,
          builder: (context, state) {
            if (state is ImageLoading && state is! ImageLoadingMore) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ImageError) {
              print('Error: ${state.message}');
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is ImageLoaded || state is ImageLoadingMore) {
              final images = state is ImageLoaded
                  ? state.images
                  : (state as ImageLoadingMore).images;

              return CustomScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                slivers: [
                  CupertinoSliverNavigationBar(
                    largeTitle: Text('Gallery'),
                    backgroundColor: Colors.red[300],
                    trailing: IconButton(
                        icon: Icon(_showList ? Icons.list : Icons.grid_view),
                        onPressed: _toggleImageLayout),
                  ),
                  (_showList)
                      ? SliverList(
                          delegate: SliverChildListDelegate([
                            ...images.map((image) {
                              return ImageTileList(image: image,onPressed: () {
                                  _openZoomableImage(
                                      context, image['download_url']);
                                },);
                            })
                          ]),
                        )
                      : SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var image = images[index];
                              return ImageTile(
                                image: image,
                                onPressed: () {
                                  _openZoomableImage(
                                      context, image['download_url']);
                                },
                              );
                            },
                            childCount: images.length,
                          ),
                        ),
                  if (state is ImageLoadingMore &&
                      _scrollController.position.pixels ==
                          _scrollController.position.maxScrollExtent)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 90,
                        child: LoadingIndicator(),
                      ),
                    ),
                ],
              );
            }
            return Center(child: Text('No images available.'));
          },
        ),
      ),
    );
  }

  void _openZoomableImage(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZoomableImageScreen(url: url),
      ),
    );
  }
}

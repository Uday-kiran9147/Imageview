import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imageview/bloc/Image/image_bloc.dart';
import 'package:imageview/bloc/internet/internet_bloc.dart';
import 'package:imageview/pages/image_detail_page.dart';
import 'package:imageview/widgets/image_tile.dart';
import 'package:imageview/widgets/image_tile_list.dart';
import 'package:imageview/widgets/loading_indicator.dart';

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
    _imageBloc = context.read<ImageBloc>();
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
    return BlocBuilder<InternetBloc, Internetstate>(
      builder: (context, internetState) {
        if (internetState is InternetConnectionOfflineState) {
          // Show "No Internet" Scaffold
          return Scaffold(
            appBar: AppBar(
              title: Text('Gallery'),
              backgroundColor: Colors.red,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No internet connection.\nPlease check your network.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        }

        // Main Gallery UI
        return Scaffold(
          body: RefreshIndicator.adaptive(
            onRefresh: () async {
              _imageBloc.add(FetchImages());
            },
            child: MultiBlocListener(
              listeners: [
                BlocListener<InternetBloc, Internetstate>(
                  listener: (context, internetState) {
                    if (internetState is InternetConnectionOfflineState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No internet connection.'),backgroundColor: Colors.red,
                          duration: Duration(seconds: 5),
                        ),
                      );
                    }

                  },
                ),
              ],
              child: BlocBuilder<ImageBloc, ImageState>(
                bloc: _imageBloc,
                builder: (context, state) {
                  if (state is ImageLoading && state is! ImageLoadingMore) {
                    return LoadingIndicator();
                  }
                  if (state is ImageError && state is! ImageLoadingMore) {
                    print('Error: ${state.message}');
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  if (state is ImageLoaded || state is ImageLoadingMore) {
                    final images = state is ImageLoaded
                        ? state.images
                        : (state as ImageLoadingMore).images;

                    return Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        slivers: [
                          CupertinoSliverNavigationBar(
                            largeTitle: Text('Gallery'),
                            backgroundColor: Colors.red[300],
                            trailing: IconButton(
                              icon: Icon(_showList ? Icons.list : Icons.grid_view),
                              onPressed: _toggleImageLayout,
                            ),
                          ),
                          if (_showList)
                            SliverList(
                              delegate: SliverChildListDelegate([
                                ...images.map((image) {
                                  return ImageTileList(
                                    image: image,
                                    onPressed: () {
                                      _openZoomableImage(
                                          context, image['download_url']);
                                    },
                                  );
                                }),
                              ]),
                            )
                          else
                            SliverGrid(
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
                      ),
                    );
                  }
                  return Center(child: Text('No images available.'));
                },
              ),
            ),
          ),
        );
      },
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


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:imageview/widgets/cache_manager.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({
    super.key,
    required this.image,
    required this.onPressed,
  });

  final dynamic image;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red[100],
            ),
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              fadeInDuration: Duration(milliseconds: 100),
              fadeInCurve: Curves.ease,
              imageUrl: image['download_url'],
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                child: LinearProgressIndicator(
                  color: Colors.grey.shade200,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}

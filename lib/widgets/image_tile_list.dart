import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ImageTileList extends StatelessWidget {
  const ImageTileList({
    super.key,
    required this.image,
    required this.onPressed,
  });
  final dynamic image;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: image['download_url'],
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
      subtitle: Text.rich(
        TextSpan(
          text: 'Author: ',
          children: [
            TextSpan(
              text: image['author'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onTap: onPressed
    );
  }
}

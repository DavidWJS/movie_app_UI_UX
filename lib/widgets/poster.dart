import 'package:flutter/material.dart';
import 'package:movie_app/helpers/image_path_helper.dart';

class Poster extends StatelessWidget {
  const Poster({
    Key key,
    @required this.scale,
    @required this.img,
  }) : super(key: key);

  final double scale;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Transform.scale(
        scale: scale,
        child: Image.network(buildImagePath(img)),
      ),
    );
  }
}
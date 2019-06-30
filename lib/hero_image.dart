import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final String tag;
  final Image image;
  const HeroImage(this.tag, this.image, {
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: image,
        ),
      ),
    );
  }
}

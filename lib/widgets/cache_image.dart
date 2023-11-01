import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mayfair/data/base/base_url.dart';

class CacheImage extends StatelessWidget {
  final String link;
  final String name;
  CacheImage({
    Key? key,
    required this.link,
    required this.name,
  }) : super(key: key);
  List<Color> colors=[
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.purpleAccent,
    Colors.teal,
    Colors.brown,
    Colors.deepOrange,
    Colors.blueGrey,
  ];
  int rnd=Random().nextInt(9);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(360),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: BaseUrls.baseProfileUrl+link,
          progressIndicatorBuilder: (context, url, downloadProgress) =>  Container(
            width: 40,
            height:40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360),
                color: colors[rnd]
            ),
            child: Center(
              child: Text("${name[0].toUpperCase()}",
                style:const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            ),
          ),
          errorWidget: (context, url, dynamic error) =>
              Container(
                width: 40,
                height:40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  color: colors[rnd]
                ),
                child: Center(
                  child: Text("${name[0].toUpperCase()}",
                  style:const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

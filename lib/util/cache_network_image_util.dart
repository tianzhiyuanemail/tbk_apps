
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheNetworkImageUtil{


  static Widget _buildBg(bgImage) {
    return new Image.asset(
      bgImage,
      width: double.infinity,
      fit: BoxFit.fill,
      height: double.infinity,
    );
  }

  static Widget image (String image,String bgImage){
    return CachedNetworkImage(
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.fill,
      imageUrl: image,
      placeholder: (context, url) => _buildBg(bgImage),
      errorWidget: (context, url, error) => _buildBg(bgImage),
    );
  }

  static Widget imageWH (String image,String bgImage,double width,double height){
    return CachedNetworkImage(
      width: width,
      height: height,
      fit: BoxFit.fill,
      imageUrl: image,
      placeholder: (context, url) => _buildBg(bgImage),
      errorWidget: (context, url, error) => _buildBg(bgImage),
    );
  }



}
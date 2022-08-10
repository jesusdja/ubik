import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ubik/config/ubik_colors.dart';
import 'package:ubik/widgets_utils/circular_progress_colors.dart';

import '../main.dart';


class ViewImage {
  Image assetsImage(String ruta) {
    return Image.asset(ruta);
  }
  Image netWork(String ruta) {
    Image image = Image.network(ruta);
    return image;
  }

  Widget netWorkCache(String ruta) {
    Widget image = CachedNetworkImage(
      imageUrl: ruta,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fitHeight,
          ),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 1.0,
            ),
          ],
        ),
      ),
      placeholder: (context, url) => circularProgressColors(colorCircular: UbicaColors.primary, widthContainer1: sizeW * 0.03, widthContainer2: sizeW * 0.03),
      errorWidget: (context, url, error) => Icon(Icons.error,size: sizeH * 0.03,color: Colors.grey),
    );
    return image;
  }

  Image fileImage(File ruta) {
    Image image = Image.file(ruta);
    return image;
  }

  Future<File?> croppedImageView({required String imageFilepath, CropStyle cropStyle = CropStyle.rectangle}) async {
    CroppedFile? croppedImage = await ImageCropper.platform.cropImage(
      sourcePath: imageFilepath,
      cropStyle: cropStyle,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxHeight: 800,
      maxWidth: 800,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar imagen',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
        ),
        IOSUiSettings(
          title: 'Editar imagen',
        ),
      ],
    );
    return File(croppedImage!.path);
  }
}

Widget containerImageAssets(double sizeH, double sizeW, String rutaName){
  return Container(
    width: sizeH,
    height: sizeH,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: ViewImage().assetsImage('assets/image/$rutaName').image,
        fit: BoxFit.contain,
      ),
    ),
  );
}
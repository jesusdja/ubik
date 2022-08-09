import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';


class ViewImage {
  Image assetsImage(String ruta) {
    return Image.asset(ruta);
  }
  Image netWork(String ruta) {
    Image image = Image.network(ruta);
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
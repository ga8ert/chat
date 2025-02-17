import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/utilities/assets_manager.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

@override
Widget userImageWidget({
  required String imageUrl,
  required double radius,
  required Function() onTap,
}){
  return GestureDetector(
    onTap: onTap,
    child: CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
      backgroundImage: imageUrl.isNotEmpty
        ?NetworkImage(imageUrl)
          : const AssetImage(AssetsManager.userImage) as ImageProvider,
    ),
  );
}

//picp image from gallery or camera
Future<File?> pickImage({
  required bool fromCamera,
  required Function(String) onFail,}) async {
    File? fileImage;
    if(fromCamera){
      //get picture from camera
      try{
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
        if (pickedFile == null){
          onFail('No image selected');
        }else{
          fileImage = File(pickedFile.path);
        }
      }catch(e){
        onFail(e.toString());
      }
    }else{
      //get picture from gallery
      try{
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile == null){
          onFail('No image selected');
        }else{
          fileImage = File(pickedFile.path);
        }
      }catch(e){
        onFail(e.toString());
      }
      }
    return fileImage;
    }

SizedBox buildDateTime(groupByValue) {
  return SizedBox(
    child: Card(
      elevation: 30,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          formatDate(groupByValue.timeSent, [d,' ',M]),
          textAlign: TextAlign.center,
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

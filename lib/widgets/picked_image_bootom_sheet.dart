import 'package:flutter/material.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/utils/extensions/extension.dart';

enum ImagePcikedAction { camera, gallery }

Future<ImagePcikedAction?> pickedImage(BuildContext context) async {
  ImagePcikedAction? imagePcikedAction;
  await showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: ColorConstant.white.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Card(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 4) * 3,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
                color: ColorConstant.grey300,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(30, 30),
                    topRight: Radius.elliptical(30, 30))),
            child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation ??
                      const AlwaysStoppedAnimation<double>(1),
                  curve: Curves.easeInOut,
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Picked Image',
                      style: TextStyle(
                          color: ColorConstant.balck,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 17),
                    ).symmetric(horizontal: 10),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Camera'),
                      onTap: () async {
                        imagePcikedAction = ImagePcikedAction.camera;
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () async {
                        imagePcikedAction = ImagePcikedAction.gallery;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ).symmetric(horizontal: 10)),
          ),
        );
      });
  if (imagePcikedAction != null) {
    return imagePcikedAction;
  } else {
    return null;
  }
}

const kTitleTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 25,
  letterSpacing: 1,
  fontWeight: FontWeight.w500,
);

const kSubtitleTextStyle = TextStyle(
  color: Colors.black38,
  fontSize: 16,
  letterSpacing: 1,
  fontWeight: FontWeight.w500,
);

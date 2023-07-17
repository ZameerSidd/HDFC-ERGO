import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdfc/model/pet_model.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/utils/extensions/extension.dart';
import 'package:hdfc/utils/styles.dart';
import 'package:hdfc/widgets/alert_dialog.dart';
import 'package:hdfc/widgets/button.dart';
import 'package:hdfc/widgets/picked_image_bootom_sheet.dart';

import '../../utils/utils.dart';
import '../../widgets/textfield.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  List<Map<String, dynamic>> imageList = [];

  String? userEmail;
  String? petData;
  List<PetModel> decodedPetData = [];
  @override
  void initState() {
    getUserEmail();
    super.initState();
  }

  getUserEmail() async {
    userEmail = await Utils.getStringFromSF('email');
    petData = await Utils.getStringFromSF('pet_data');
    if (petData != null && petData!.isNotEmpty) {
      List list = jsonDecode(petData ?? "");
      for (var element in list) {
        var model = PetModel.fromJson(element);
        decodedPetData.add(model);
      }
      log(decodedPetData.length.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorConstant.grey300,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  CustomButton.backButton(onPressed: () {
                    Navigator.pop(context, 'add');
                  }),
                  const SizedBox(height: 30),
                  const Text(
                    'Add your pet detail.',
                    style: Styles.style1,
                  ),
                  const SizedBox(height: 30),
                  const Text('Name*', style: Styles.textField),
                  formField(
                      controller: _petNameController,
                      inputType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Invalid pet name";
                        } else if (val.length < 3) {
                          return "Invalid pet ame";
                        }
                        return null;
                      },
                      hintText: 'Enter pet name'),
                  const SizedBox(height: 10),
                  const Text('Species*', style: Styles.textField),
                  formField(
                      controller: _speciesController,
                      inputType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Invalid Species";
                        }
                        return null;
                      },
                      hintText: 'Enter pet Species'),
                  const SizedBox(height: 10),
                  const Text(
                    'Gender*',
                    style: Styles.textField,
                  ),
                  formField(
                    controller: _genderController,
                    hintText: 'Enter gender',
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Invalid gender";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Age*',
                    style: Styles.textField,
                  ),
                  formField(
                    controller: _ageController,
                    hintText: 'Enter pet age',
                    inputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return "Invalid age";
                      } else if (imageList.isEmpty) {
                        return 'Add pet image';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomButton.button(
                    text: 'Add Image',
                    bgColor: ColorConstant.white,
                    onPressed: () async {
                      // var email = await Utils.getStringFromSF('email');
                      var email = 'one@gmail.com';
                      if (!mounted) {
                        log('mounted ********************');
                        return;
                      }
                      var response = await pickedImage(context);
                      if (response != null &&
                          userEmail != null &&
                          response == ImagePcikedAction.camera) {
                        log('Camera');
                        var images = await Utils.pickedImageFromCamera();
                        if (images != null && images.path.isNotEmpty) {
                          log(images.path);
                          imageList.add(
                              {"file": File(images.path), 'name': images.name});
                          setState(() {});
                        }
                      } else if (response != null &&
                          userEmail != null &&
                          response == ImagePcikedAction.gallery) {
                        log('Gallery ');
                        var images = await Utils.pickedImageFromGallery();
                        if (images != null && images.isNotEmpty) {
                          for (var element in images) {
                            if (element != null && element.path.isNotEmpty) {
                              log(element.path);
                              imageList.add({
                                "file": File(element.path),
                                'name': element.name
                              });
                              // uploadFile(email, element.name, File(element.path));
                            }
                          }
                          setState(() {});
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  if (imageList.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        itemCount: imageList.length,
                        itemBuilder: (context, index) {
                          var item = imageList[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text(
                                item['name'],
                                style: const TextStyle(fontSize: 13),
                              )),
                              GestureDetector(
                                onTap: () {
                                  imageList.removeAt(index);
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: ColorConstant.red,
                                ),
                              )
                            ],
                          ).symmetric(horizontal: 10, vertical: 3);
                        },
                      ),
                    ),
                  const SizedBox(height: 30),
                  CustomButton.button(
                    text: 'Add',
                    bgColor: ColorConstant.primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        loadingDialog();
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ).symmetric(horizontal: 15),
            ),
          ),
        ),
      ),
    );
  }

  loadingDialog() {
    upload();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Uploading ...'),
              ],
            ),
          ),
        );
      },
    );
  }

  upload() async {
    bool val = false;
    for (var element in imageList) {
      var filename = element['name'];
      File file = element['file'];
      var resonse = await uploadFile(filename, file);
      if (resonse != null && resonse) {
        val = true;
      } else {
        val = false;
        return false;
      }
    }
    if (val) {
      if (!mounted) return;
      Navigator.pop(context);
      Utils.showSimpleSnacbar(context, "File upload successfully");
      clearData();
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      showAlert(context, "Something went please wrong try again later.");
    }
  }

  clearData() {
    _ageController.clear();
    _genderController.clear();
    _petNameController.clear();
    _speciesController.clear();
    imageList.clear();
    setState(() {});
  }

  Future<bool?> uploadFile(String filename, File file) async {
    var extantion = file.path.split('.').last;
    try {
      log("$extantion extention of file ");
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("Images/$userEmail/-${DateTime.now()}-$filename");
      final data = await storageRef.putFile(
          file, SettableMetadata(contentType: 'image/$extantion'));
      var url = await data.ref.getDownloadURL();
      log("$url ***************");
      var petModel = PetModel(
          name: _petNameController.value.text,
          url: url,
          species: _speciesController.value.text,
          age: int.parse(_ageController.value.text),
          gender: _genderController.value.text,
          favorite: false);
      decodedPetData.add(petModel);
      var encodedData = jsonEncode(decodedPetData);
      Utils.addStringToSF('pet_data', encodedData);
      return true;
    } on FirebaseException catch (e) {
      log("${e.code} error ******************");
      return false;
    }
  }
}

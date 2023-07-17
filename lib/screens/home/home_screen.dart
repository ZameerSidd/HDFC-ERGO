import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hdfc/constant/constant.dart';
import 'package:hdfc/screens/add_pet/add_pet.dart';
import 'package:hdfc/screens/drawer/drawer_screen.dart';
import 'package:hdfc/screens/favorite/favorite.dart';
import 'package:hdfc/utils/color/color_constant.dart';
import 'package:hdfc/utils/utils.dart';

import '../../bloc/bet_bloc.dart';
import '../../model/pet_model.dart';
import '../../widgets/image_loder.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/something_went_wrong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  String? username;
  String? userEmail;
  final PetBloc _petBloc = PetBloc();

  @override
  void dispose() {
    _petBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    log('did change message *************');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getUsername();
    super.initState();
  }

  getUsername() async {
    username = await Utils.getStringFromSF('name');
    userEmail = await Utils.getStringFromSF('email');
    _petBloc.eventSink.add(PetAction.list);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.grey200,
      key: scaffoldState,
      body: SafeArea(
        child: Stack(
          children: [
            DrawerScreen(
              fun: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPet(),
                    ));
                if (result == 'add') {
                  log('message');
                  _petBloc.eventSink.add(PetAction.list);
                }
              },
              fav: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Favorite(),
                    ));
                if (result == 'fav') {
                  log('message');
                  _petBloc.eventSink.add(PetAction.list);
                }
              },
            ),
            AnimatedContainer(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
              decoration: isDrawerOpen
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    )
                  : const BoxDecoration(color: Colors.white),
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor),
              duration: const Duration(milliseconds: 250),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isDrawerOpen
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    scaleFactor = 1;
                                    isDrawerOpen = false;
                                  });
                                },
                                icon: const Icon(Icons.arrow_back_ios),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    xOffset = 230;
                                    yOffset = 150;
                                    scaleFactor = 0.6;
                                    isDrawerOpen = true;
                                  });
                                },
                                icon: const Icon(Icons.menu),
                              ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // PetBloc().eventSink.add(PetAction.list);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      username ?? 'Kyiv ',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/download.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextField(
                              onChanged: (value) {
                                _petBloc.searchEventSink.add(value);
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorConstant.primaryColor_),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[400],
                                ),
                                hintText: 'Search pet',
                                hintStyle: TextStyle(
                                    letterSpacing: 1, color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Icon(Icons.tune_sharp,
                                    color: Colors.grey[400]),
                              ),
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder<List<PetModel>>(
                                stream: _petBloc.counterStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.isNotEmpty) {
                                    return SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height /
                                                  4) *
                                              3.3,
                                      child: ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        physics: const ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          var item = snapshot.data![index];
                                          return Container(
                                            height: 230,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: (index % 2 ==
                                                                  0)
                                                              ? Colors
                                                                  .blueGrey[200]
                                                              : ColorConstant
                                                                  .primaryColor_,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: Constant
                                                              .shadowList,
                                                        ),
                                                        margin: const EdgeInsets
                                                            .only(top: 40),
                                                      ),
                                                      Align(
                                                          child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Hero(
                                                            tag:
                                                                'pet${item.url}',
                                                            child: ImageLoader(
                                                                imageUrl: item
                                                                        .url ??
                                                                    "https://t4.ftcdn.net/jpg/03/08/92/49/360_F_308924911_jsWAfFOqdSGglzvF7zcNcXIo06eS7Wch.jpg")),
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 65,
                                                            bottom: 20),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                      boxShadow:
                                                          Constant.shadowList,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              Utils.checkNullString(
                                                                  item.name),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 21.0,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (item.favorite !=
                                                                        null &&
                                                                    item.favorite!) {
                                                                  var response = await Utils.simpleDialog(
                                                                      context,
                                                                      buttonName:
                                                                          "Remove",
                                                                      subTitle:
                                                                          "Do you want to remove this from favorite?",
                                                                      title:
                                                                          "Favorite List");
                                                                  if (response) {
                                                                    var petModel = PetModel(
                                                                        name: item
                                                                            .name,
                                                                        url: item
                                                                            .url,
                                                                        species:
                                                                            item
                                                                                .species,
                                                                        age: item
                                                                            .age,
                                                                        gender: item
                                                                            .gender,
                                                                        favorite:
                                                                            Constant.unFavorite);
                                                                    snapshot.data![
                                                                            index] =
                                                                        petModel;
                                                                    var encodedData =
                                                                        jsonEncode(
                                                                            snapshot.data);
                                                                    log('&&&&&&&&&&&&&&&&');
                                                                    await Utils.addStringToSF(
                                                                        'pet_data',
                                                                        encodedData);
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                } else {
                                                                  var response = await Utils.simpleDialog(
                                                                      context,
                                                                      buttonName:
                                                                          "Add",
                                                                      subTitle:
                                                                          "Do you want to add this to favorite?",
                                                                      title:
                                                                          "Favorite List");
                                                                  if (response) {
                                                                    var petModel = PetModel(
                                                                        name: item
                                                                            .name,
                                                                        url: item
                                                                            .url,
                                                                        species:
                                                                            item
                                                                                .species,
                                                                        age: item
                                                                            .age,
                                                                        gender: item
                                                                            .gender,
                                                                        favorite:
                                                                            Constant.favorite);
                                                                    snapshot.data![
                                                                            index] =
                                                                        petModel;
                                                                    var encodedData =
                                                                        jsonEncode(
                                                                            snapshot.data);

                                                                    await Utils.addStringToSF(
                                                                        'pet_data',
                                                                        encodedData);
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                }
                                                              },
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color: (item.favorite !=
                                                                            null &&
                                                                        item
                                                                            .favorite!)
                                                                    ? ColorConstant
                                                                        .balck
                                                                    : ColorConstant
                                                                        .grey400,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          Utils.checkNullString(
                                                              item.species),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[500],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 4,
                                                              child: Text(
                                                                '${Utils.checkNullString(item.age.toString())} years old',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    var response = await Utils.logOutDialog(
                                                                        context,
                                                                        delete:
                                                                            true);
                                                                    if (response) {
                                                                      snapshot
                                                                          .data!
                                                                          .removeAt(
                                                                              index);
                                                                      var encodedData =
                                                                          jsonEncode(
                                                                              snapshot.data);

                                                                      await Utils.addStringToSF(
                                                                          'pet_data',
                                                                          encodedData);
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        ColorConstant
                                                                            .red,
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else if (snapshot.data == null ||
                                      snapshot.data!.isEmpty) {
                                    return NoDataFound(
                                      onpressed: () async {
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddPet(),
                                            ));
                                        if (result == 'add') {
                                          log('message');
                                          _petBloc.eventSink
                                              .add(PetAction.list);
                                        }
                                      },
                                    );
                                  } else {
                                    log(snapshot.hasError
                                        ? snapshot.error.toString()
                                        : "${snapshot.data} *****");
                                    return SomethingWrong(tryAhin: () {});
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  uploadFile(String userName, String filename, File file) async {
    var extantion = file.path.split('.').last;
    try {
      log("$extantion extention of file ");
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("Images/$userName/-${DateTime.now()}-$filename");
      final data = await storageRef.putFile(
          file, SettableMetadata(contentType: 'image/$extantion'));
      log("$data ***************");
    } on FirebaseException catch (e) {
      log("${e.code} error ******************");
    }
  }
}

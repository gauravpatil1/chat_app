import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_user_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cloud_firestore_controller.dart';
import '../widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final AppUserController appUserController = Get.put(AppUserController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        bool isPortrait = orientation == Orientation.portrait;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFF0E185F),
          body: SafeArea(
            child: GetX<AppUserController>(builder: (controller) {
              _nameController.text = controller.appUser.name;
              _statusController.text = controller.appUser.status;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 0,
                    backgroundColor: const Color(0xFF0E185F),
                    title: const Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          AuthController.instance.logOut();
                        },
                        icon: const Icon(Icons.logout),
                      )
                    ],
                  ),
                  SliverFillRemaining(
                    child: ListView(
                      children: [
                        Visibility(
                          visible: (!isPortrait &&
                                  MediaQuery.of(context).viewInsets.bottom > 0)
                              ? false
                              : true,
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 40, bottom: 40),
                            child: Stack(
                              children: [
                                Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(102),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(102),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        )),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: controller
                                              .appUser.photoUrl.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  controller.appUser.photoUrl,
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              key: UniqueKey(),
                                              placeholder: (context, url) =>
                                                  PersonIcon(
                                                color: Colors.grey.shade400,
                                                size: 180,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      PersonIcon(
                                                color: Colors.grey.shade400,
                                                size: 180,
                                              ),
                                            )
                                          : PersonIcon(
                                              color: Colors.grey.shade400,
                                              size: 180,
                                            ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      AuthController.instance.changeUserImage();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Name',
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter correct name';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onFieldSubmitted: (value) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              AuthController.instance
                                                  .changeUsername(value);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 25,
                                      color: Colors.green.shade400,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, bottom: 0),
                                child: const Text(
                                  'This name will be visible to your contacts and they can search your profile using this name',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: TextFormField(
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          controller: _statusController,
                                          decoration: const InputDecoration(
                                            labelText: 'Status',
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Status cannot be null';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onFieldSubmitted: (value) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              CloudFireStoreController.instance
                                                  .changeAppUserDetails(
                                                controller.appUser.uid,
                                                status: value,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      size: 25,
                                      color: Colors.green.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}

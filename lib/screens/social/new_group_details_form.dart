import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/social/send_group_invite.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/loading.dart';

class NewGroupDetailsForm extends StatefulWidget {
  const NewGroupDetailsForm({super.key});

  @override
  State<NewGroupDetailsForm> createState() => _NewGroupDetailsFormState();
}

class _NewGroupDetailsFormState extends State<NewGroupDetailsForm> {
  final groupNameController = TextEditingController();
  final groupDescriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String filePath = '';
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enter group details",
          style: appBarTextStyle,
        ),
      ),
      body: !isLoading
          ? Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            if (result != null) {
                              setState(() {
                                filePath = result.files.first.path!;
                              });
                            }
                          },
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: filePath == ''
                                ? null
                                : FileImage(File(filePath)),
                            child: filePath == ''
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 40,
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Text("Add Icon")
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80.0,
                      ),
                      TextFormField(
                        controller: groupNameController,
                        validator: (value) => value == null || value == ""
                            ? "This is a required field"
                            : null,
                        decoration:
                            const InputDecoration(labelText: "Group Name"),
                      ),
                      TextFormField(
                        controller: groupDescriptionController,
                        validator: (value) => value == null || value == ""
                            ? "This is a required field"
                            : null,
                        decoration: const InputDecoration(
                            labelText: "Group Description"),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (filePath == '') {
                              Fluttertoast.showToast(
                                  msg: 'Please upload image');
                            }
                            if (formKey.currentState!.validate() &&
                                filePath != '') {
                              setState(() {
                                isLoading = true;
                              });
                              final groupIconUrl = await FirebaseServices()
                                  .uploadFile(parcel: File(filePath));
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SendGroupInvite(
                                      groupIconUrl: groupIconUrl,
                                      groupName: groupNameController.text,
                                      groupDescription:
                                          groupDescriptionController.text)));
                            }
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.purple),
                          child: const Text(
                            "Proceed",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: LoadingWidget(),
            ),
    );
  }
}

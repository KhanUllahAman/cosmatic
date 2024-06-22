// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:cosmatic/models/user_model/user_model.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:cosmatic/widgets/textfields/custom_textfield.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EditProfile extends StatefulWidget {
  String name;
  EditProfile({super.key, required this.name});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  File? image;
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      ///appbar here
      appBar: AppBar(
        title: Text("Edit Profile",style: TextStyle(color: AppColor.primaryColor)),
        centerTitle: true,
      ),

      ///body here
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: const [
              ],
            ),


            ///update name textfield
            CustomTextField(
              prefixIcon: EneftyIcons.user_edit_outline,
              controller: nameController,
              hintText: widget.name,
              keyboadType: TextInputType.text,
            ),

            Consumer<AppProvider>(
              builder: (context, value, child) => ElevatedButton(
                onPressed: () {

                  if(nameController.text.isEmpty){
                    showMessage("No changes made!");
                  }else{
                   setState(() {
                  UserModel userModel = value.getUserInfo.copyWith(name: nameController.text);
                  value.updateUserInfoFirebase(userModel, image, context);
                  });



                  }



                },
                child: const Text("Update Profile",style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

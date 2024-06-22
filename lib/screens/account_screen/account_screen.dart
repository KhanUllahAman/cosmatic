import 'package:auto_size_text/auto_size_text.dart';
import 'package:cosmatic/admin/video_list_screen.dart';
import 'package:cosmatic/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:cosmatic/main.dart';
import 'package:cosmatic/provider/app_provider.dart';
import 'package:cosmatic/screens/Community/community_screen.dart';
import 'package:cosmatic/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:cosmatic/screens/favourites_screen/favourites_screen.dart';
import 'package:cosmatic/admin/manage_uploaded_content.dart';
import 'package:cosmatic/screens/order_screen/order_screen.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:cosmatic/widgets/setting_list_tile.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("Account",
              style: TextStyle(color: AppColor.primaryColor)),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: appProvider.getUserInfoFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    SizedBox(
                      height: size.height * 0.3,
                      child: Card(
                        elevation: 0,
                        color: Color.fromARGB(255, 247, 194, 212),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      AssetImage("assets/images/avatar.jpg")),
                              AutoSizeText(appProvider.getUserInfo.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.06)),
                              AutoSizeText(appProvider.getUserInfo.email,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.04)),
                              SizedBox(
                                width: 160,
                                child: ElevatedButton(
                                  onPressed: () => Routes.push(
                                      EditProfile(
                                          name: appProvider.getUserInfo.name),
                                      context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      AutoSizeText("Edit Profile",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      Icon(EneftyIcons.arrow_right_3_outline,
                                          color: Colors.white),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SettingListTile(
                      leading: EneftyIcons.shopping_bag_bold,
                      title: "Your Orders",
                      ontap: () => Routes.push(const OrderScreen(), context),
                    ),
                    SettingListTile(
                      leading: EneftyIcons.heart_bold,
                      title: "Favourites",
                      ontap: () =>
                          Routes.push(const FavouritesScreen(), context),
                    ),
                    SettingListTile(
                      leading: EneftyIcons.video_add_bold,
                      title: "Upload Reels",
                      ontap: () =>
                          Routes.push(ManageUploadedContent(), context),
                    ),
                    SettingListTile(
                      leading: EneftyIcons.video_play_bold,
                      title: "View Reels",
                      ontap: () => Routes.push(VideoListScreen(), context),
                    ),
                    SettingListTile(
                      leading: EneftyIcons.user_add_outline,
                      title: "Beauty Community",
                      ontap: () {
                        Routes.push(CommunityScreen(), context);
                      },
                    ),
                    SettingListTile(
                      ontap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColor.imgBgColor,
                          title: const Text("Logout"),
                          content: const Text(
                              "Are you sure, do you want to Logout?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("No",
                                  style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontSize: 18)),
                            ),
                            TextButton(
                              onPressed: () {
                                FireBaseAuthHelper().signOut();
                                Routes.pushAndRemoveUntill(
                                    const Cosme(), context);
                                showMessage("User logout");
                              },
                              child: Text("Yes",
                                  style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontSize: 18)),
                            )
                          ],
                        ),
                      ),
                      leading: EneftyIcons.logout_bold,
                      title: "Log out",
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}

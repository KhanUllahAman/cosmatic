import 'package:cosmatic/admin/admin_verified_community.dart';
import 'package:cosmatic/admin/admin_video_Verification_screen.dart';
import 'package:cosmatic/admin/categories_page.dart';
import 'package:cosmatic/admin/manage_categories.dart';
import 'package:cosmatic/admin/manage_products.dart';
import 'package:cosmatic/admin/verify_account.dart';
import 'package:cosmatic/admin/view_order.dart';
import 'package:cosmatic/chats/admin_chats.dart';
import 'package:cosmatic/screens/welcome/welcome.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/widgets/textfields/big_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String getGreeting() {
    final currentTime = DateTime.now().hour;
    if (currentTime >= 5 && currentTime < 12) {
      return 'Good Morning!';
    } else if (currentTime >= 12 && currentTime < 17) {
      return 'Good Afternoon';
    } else if (currentTime >= 17 && currentTime < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String greeting = getGreeting();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: 'Hi! Admin',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      BigText(
                        text: currentDate,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: greeting,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      GestureDetector(
                        onTap: _showLogoutDialog,
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildDashboardCard(
                        'Verify Accounts',
                        'assets/images/1.png',
                        VerifyAccounts(),
                      ),
                      _buildDashboardCard(
                        'Manage Categories',
                        'assets/images/2.png',
                        ManageCategories(),
                      ),
                      _buildDashboardCard(
                        'Create Products',
                        'assets/images/3.png',
                        ManageProducts(),
                      ),
                      _buildDashboardCard(
                        'View Orders',
                        'assets/images/4.png',
                        ViewOrders(),
                      ),
                      _buildDashboardCard(
                        'Manage Uploaded Content',
                        'assets/images/5.png',
                        AdminVerificationScreen(),
                      ),
                      _buildDashboardCard(
                        'Manage Category Products',
                        'assets/images/6.png',
                        CategoriesPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 150), // Adjust this value as needed
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminCommunity()),
        );
            },
            backgroundColor: AppColor.primaryColor,
            icon: Icon(Icons.supervised_user_circle_sharp, color: Colors.white,),
            label: Text('',),
          ),
          SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () {
               Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboardChats()),
        );
            },
            backgroundColor: AppColor.primaryColor,
            icon: Icon(Icons.chat_rounded, color: Colors.white,),
            label: Text(''),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String imagePath, Widget route) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Card(
        color: Color.fromARGB(255, 253, 221, 232),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(imagePath),
                height: 80,
                width: 80,
              ),
              SizedBox(height: 10),
              BigText(
                text: title,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
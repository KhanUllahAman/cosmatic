import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmatic/screens/auth_screens/login_ui/login.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ///controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isVisible = false;

  Future<void> signUp() async {
    _showLoadingDialog();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': emailController.text,
          'name': nameController.text,
          'phone': phoneController.text,
          'verified': false,
        });

        Navigator.of(context).pop();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Account Created"),
              content:
                  Text("Your account is pending verification by an admin."),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showMessage(e.message ?? "An error occurred");
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Creating account...'),
            ],
          ),
        );
      },
    );
  }

  bool signUpValidation(String email, String password, String name, String phone) {
    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      showMessage("Please fill in all fields");
      return false;
    }
    return true;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background.jpg"),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                width: 340,
                height: 580,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0XFFEC7D7F)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/logo.png")))),
                        SizedBox(width: 10),
                        Text(
                          "Paris Cosmetics",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Full name',
                                      suffixIcon: Icon(Icons.person),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                        hintText: 'Email',
                                        suffixIcon: Icon(Icons.alternate_email)),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: 'XXXX-XXXXXXX',
                                      suffixIcon: Icon(Icons.add_call),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                        hintText: 'Password',
                                        suffixIcon: Icon(Icons.lock_open)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50),
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    bool isValidated = signUpValidation(
                                      emailController.text,
                                      passwordController.text,
                                      nameController.text,
                                      phoneController.text,
                                    );
                                    if (isValidated) {
                                      await signUp();
                                    }
                                  },
                                  child: Text('Create Account',
                                      style: TextStyle(
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account?"),
                                  TextButton(
                                    onPressed: () {
                                      Routes.pushAndRemoveUntill(
                                          const LoginScreen(), context);
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cosmatic/screens/auth_screens/signup_ui/signup.dart';
// import 'package:cosmatic/screens/custom_navbar/custom_navbar.dart';
// import 'package:cosmatic/utils/app_colors.dart';
// import 'package:cosmatic/utils/constants.dart';
// import 'package:cosmatic/utils/routes.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool isVisible = false;

//   Future<void> login() async {
   
//     try {
//       //  _showLoadingDialog();
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//       User? user = userCredential.user;
//       if (user != null) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//         Navigator.of(context).pop();
//         if (userDoc.exists && userDoc['verified'] == true) {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
//             (route) => false,
//           );
//           showMessage("User logged in");
//         } else {
//           FirebaseAuth.instance.signOut();
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text("Account Not Verified"),
//                 content: Text("Your account is pending verification by an admin."),
//                 actions: [
//                   TextButton(
//                     child: Text("OK"),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       Navigator.of(context).pop();
//       showMessage(e.message ?? "An error occurred");
//     }
//   }
  


//   void _showLoadingDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           content: Row(
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(width: 20),
//               Text('Logging in...'),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   bool loginValidation(String email, String password) {
//     if (email.isEmpty || password.isEmpty) {
//       showMessage("Please fill in all fields");
//       return false;
//     }
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;

//     return Scaffold(
//         body: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Stack(
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: AssetImage("assets/images/background.jpg"),
//                   ),
//                 ),
//               ),
//               Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//                   width: 340,
//                   height: 400,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: const Color(0XFFEC7D7F)),
//                   child: Column(children: [
//                     Row(
//                       children: [
//                         Container(
//                             width: 50,
//                             height: 50,
//                             decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                     image: AssetImage("assets/images/logo.png")))),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         const Text(
//                           "Paris Cosmetics",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Column(
//                       children: [
//                         TextFormField(
//                             keyboardType: TextInputType.emailAddress,
//                             controller: emailController,
//                             decoration: const InputDecoration(
//                                 hintText: 'Email',
//                                 suffixIcon: Icon(Icons.alternate_email)),
//                             ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         TextFormField(
//                             controller: passwordController,
//                             keyboardType: TextInputType.text,
//                             obscureText: true,
//                             decoration: const InputDecoration(
//                                 hintText: 'Password',
//                                 suffixIcon: Icon(Icons.lock_open)),
//                             ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 40,
//                     ),
//                     SizedBox(
//                       width: 200,
//                       child: ElevatedButton(
//                          style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                         ),
//                         onPressed: () async {
//                       bool isValidated = loginValidation(emailController.text, passwordController.text);
//                       if (isValidated) {
//                         await login();
//                       }
//                     },
//                         child:  Text('Login', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         const Text("Don't have an account?"),
//                         TextButton(
//                             onPressed: () {
//                           Routes.push(const SignUpScreen(), context);
//                         },
//                             child:  Text("Sign up", style: TextStyle(color: Colors.white),))
//                       ],
//                     ),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosmatic/screens/auth_screens/signup_ui/signup.dart';
import 'package:cosmatic/screens/custom_navbar/custom_navbar.dart';
import 'package:cosmatic/utils/app_colors.dart';
import 'package:cosmatic/utils/constants.dart';
import 'package:cosmatic/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isVisible = false;
  bool isLoading = false; // State to track loading

  Future<void> login() async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc['verified'] == true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CustomBottomNavBar()),
            (route) => false,
          );
          showMessage("User logged in");
        } else {
          FirebaseAuth.instance.signOut();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Account Not Verified"),
                content: Text("Your account is pending verification by an admin."),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? "An error occurred");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  bool loginValidation(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showMessage("Please fill in all fields");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
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
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                width: 340,
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0XFFEC7D7F),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/logo.png"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Paris Cosmetics",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            suffixIcon: Icon(Icons.alternate_email),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            suffixIcon: Icon(Icons.lock_open),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          bool isValidated = loginValidation(emailController.text, passwordController.text);
                          if (isValidated) {
                            await login();
                          }
                        },
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: AppColor.primaryColor,
                              )
                            : Text(
                                'Login',
                                style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    Row(
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Routes.push(const SignUpScreen(), context);
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

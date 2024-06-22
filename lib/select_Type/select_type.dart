import 'package:cosmatic/admin/admin_login.dart';
import 'package:cosmatic/guest/custome_navbar_guest.dart';
import 'package:cosmatic/screens/auth_screens/login_ui/login.dart';
import 'package:cosmatic/widgets/button/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectType extends StatefulWidget {
  const SelectType({Key? key}) : super(key: key);

  @override
  _SelectTypeState createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFFEC7D7F).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 70),
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Select Type",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(255, 253, 236, 242),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 253, 208, 235).withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                            elevation: 8,
                            dropdownColor: Color.fromARGB(255, 252, 231, 238),
                            isExpanded: true,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            underline: Container(
                              height: 2,
                              color: Colors.transparent,
                            ),
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black, size: 30),
                            items: const [
                              DropdownMenuItem(
                                value: 'admin',
                                child: Text(
                                  'Admin',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'user',
                                child: Text(
                                  'User',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'guest',
                                child: Text(
                                  'Guest',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                            onChanged: (String? value) {
                              setState(() {
                                _selectedType = value;
                                print('Selected: $value');
                              });
                            },
                            hint: const Text(
                              'Select type',
                              style: TextStyle(fontSize: 20),
                            ),
                            value: _selectedType,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    RoundButton(
                      title: 'OK',
                      onTap: () {
                        if (_selectedType == 'admin') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminLogin()),
                          );
                        } else if (_selectedType == 'user') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        } else if (_selectedType == 'guest') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomBottomNavBarGuest()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:cosmatic/admin/admin_login.dart';
// import 'package:cosmatic/guest/Home.dart';
// import 'package:cosmatic/screens/auth_screens/login_ui/login.dart';
// import 'package:cosmatic/widgets/button/round_button.dart';
// import 'package:flutter/material.dart';

// class SelectType extends StatefulWidget {
//   const SelectType({Key? key}) : super(key: key);

//   @override
//   _SelectTypeState createState() => _SelectTypeState();
// }

// class _SelectTypeState extends State<SelectType> {
//   String? _selectedType;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFE7C5DF), Color(0xFFB9C1E5)],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 width: 340,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Select Type",
//                       style: TextStyle(
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Container(
//                       width: 300,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.white,
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: DropdownButton<String>(
//                         elevation: 8,
//                         items: const [
//                           DropdownMenuItem(
//                             value: 'admin',
//                             child: Text('Admin', style: TextStyle(fontSize: 20)),
//                           ),
//                           DropdownMenuItem(
//                             value: 'user',
//                             child: Text('User', style: TextStyle(fontSize: 20)),
//                           ),
//                           DropdownMenuItem(
//                             value: 'guest',
//                             child: Text('Guest', style: TextStyle(fontSize: 20)),
//                           ),
//                         ],
//                         onChanged: (String? value) {
//                           setState(() {
//                             _selectedType = value;
//                           });
//                         },
//                         hint: const Text(
//                           'Select type',
//                           style: TextStyle(fontSize: 20, color: Colors.grey),
//                         ),
//                         value: _selectedType,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     RoundButton(
//                       title: 'OK',
//                       onTap: () {
//                         if (_selectedType == 'admin') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => AdminLogin()),
//                           );
//                         } else if (_selectedType == 'user') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => LoginScreen()),
//                           );
//                         } else if (_selectedType == 'guest') {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => const GuestHomeScreen()),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

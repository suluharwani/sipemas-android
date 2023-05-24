import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/auth/authentication_bloc.dart';
import 'package:flutter_login_screen/ui/auth/welcome/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State createState() => _HomeState();
  // State createState() => ProfileWidget();
}

class _HomeState extends State<HomeScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[

    // Card(
    //   child: Card(
    //     elevation: 0,
    //     shape: RoundedRectangleBorder(
    //       side: BorderSide(
    //         color: Color.fromARGB(25, 25, 25, 25),
    //       ),
    //       borderRadius: const BorderRadius.all(Radius.circular(12)),
    //     ),
    //     child: const SizedBox(
    //       width: 300,
    //       height: 100,
    //       child: Center(child: Text('Outlined Card')),
    //     ),
    //   ),
    // ),

    Column(
      children: <Widget>[
        Center(
          child: BtnHome(),
        ),
      ],
    ),
    ListTileExample(),
    Column(
      children: <Widget>[
        Text('Halaman input'),
        Text('pilihan menu input'),
        Expanded(
          child: FittedBox(
            child: Text('Halaman input'),
            // child: FlutterLogo(),
          ),
        ),
      ],
    ),
    ListTileExample(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.authState == AuthState.unauthenticated) {
          pushAndRemoveUntil(context, const WelcomeScreen(), false);
        }
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 142, 11),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: user.profilePictureURL == ''
                    ? CircleAvatar(
                        backgroundColor: Colors.grey.shade400,
                        child: ClipOval(
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : displayCircleImage(user.profilePictureURL, 80, false),
                title: Text(user.fullName()),
                subtitle: Text(user.email),
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: isDarkMode(context)
                          ? Colors.grey.shade50
                          : Colors.grey.shade900),
                ),
                leading: Transform.rotate(
                  angle: pi / 1,
                  child: Icon(
                    Icons.exit_to_app,
                    color: isDarkMode(context)
                        ? Colors.grey.shade50
                        : Colors.grey.shade900,
                  ),
                ),
                onTap: () {
                  context.read<AuthenticationBloc>().add(LogoutEvent());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            'SIPEMAS',
            style: TextStyle(
                color: isDarkMode(context)
                    ? Colors.grey.shade50
                    : Colors.grey.shade900),
          ),
          iconTheme: IconThemeData(
              color: isDarkMode(context)
                  ? Colors.grey.shade50
                  : Colors.grey.shade900),
          backgroundColor:
              isDarkMode(context) ? Colors.grey.shade900 : Colors.grey.shade50,
          centerTitle: true,
        ),
        body:
          Container(
            child:   _widgetOptions.elementAt(_selectedIndex),
          ),
          // child:  _widgetOptions.elementAt(_selectedIndex),

        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Buat Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.person),
            //   label: 'Profile',
            // ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class BtnHome extends StatelessWidget {
  const BtnHome({super.key});

  @override
  Widget build(BuildContext context) {

    return OutlinedButton(
      onPressed: () {
        debugPrint('Received click');
      },
      child: const Text('Click Me'),

    );
  }
}

class ListTileExample extends StatelessWidget {
  const ListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Laporan')),
      body: ListView(
        children: const <Widget>[
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text('Headline'),
            subtitle: Text('Supporting text'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          Divider(height: 0),
          ListTile(
            leading: CircleAvatar(child: Text('B')),
            title: Text('Headline'),
            subtitle: Text(
                'Longer supporting text to demonstrate how the text wraps and how the leading and trailing widgets are centered vertically with the text.'),
            trailing: Icon(Icons.favorite_rounded),
          ),
          Divider(height: 0),
          ListTile(
            leading: CircleAvatar(child: Text('C')),
            title: Text('Headline'),
            subtitle: Text(
                "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
            trailing: Icon(Icons.favorite_rounded),
            isThreeLine: true,
          ),
          ListTile(
            leading: CircleAvatar(child: Text('C')),
            title: Text('Headline'),
            subtitle: Text(
                "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
            trailing: Icon(Icons.favorite_rounded),
            isThreeLine: true,
          ),
          ListTile(
            leading: CircleAvatar(child: Text('C')),
            title: Text('Headline'),
            subtitle: Text(
                "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
            trailing: Icon(Icons.favorite_rounded),
            isThreeLine: true,
          ),
          ListTile(
            leading: CircleAvatar(child: Text('C')),
            title: Text('Headline'),
            subtitle: Text(
                "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
            trailing: Icon(Icons.favorite_rounded),
            isThreeLine: true,
          ),
          ListTile(
            leading: CircleAvatar(child: Text('C')),
            title: Text('Headline'),
            subtitle: Text(
                "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
            trailing: Icon(Icons.favorite_rounded),
            isThreeLine: true,
          ),
          ListTile(
            leading: CircleAvatar(child: Text('C')),
            title: Text('Headline'),
            subtitle: Text(
                "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
            trailing: Icon(Icons.favorite_rounded),
            isThreeLine: true,
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}
// class ProfileWidget extends State<HomeScreen> {
//   late User user;
//
//   @override
//   void initState() {
//     super.initState();
//     user = widget.user;
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             user.profilePictureURL == ''
//                 ? CircleAvatar(
//               radius: 35,
//               backgroundColor: Colors.grey.shade400,
//               child: ClipOval(
//                 child: SizedBox(
//                   width: 70,
//                   height: 70,
//                   child: Image.asset(
//                     'assets/images/placeholder.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             )
//                 : displayCircleImage(user.profilePictureURL, 80, false),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(user.fullName()),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(user.email),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(user.userID),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_screen/model/user.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/auth/authentication_bloc.dart';
import 'package:flutter_login_screen/ui/auth/welcome/welcome_screen.dart';
import 'package:flutter_login_screen/ui/page/addpage.dart';

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
    Column(
      children: <Widget>[
        Center(
          child: BtnHome(),
        ),
      ],
    ),
    InputData(),
    ListTileExample(),
    InputData(),
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
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
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

class InputData extends StatelessWidget {
  const InputData({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FormLaporan(),
      ),
    );
  }
}

class FormLaporan extends StatefulWidget {
  const FormLaporan({super.key});

  @override
  State<FormLaporan> createState() => _FormLaporanState();
}

class _FormLaporanState extends State<FormLaporan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Pengaduan',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan teks';
                }
                return null;
              },
            ),
            const Text(
              "Rating Pelayanan",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            RadioListRating(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                  }
                },
                child: const Center(
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ));
}

enum RatingLayanan { R0, R1, R2, R3, R4 }

class RadioListRating extends StatefulWidget {
  const RadioListRating({super.key});

  @override
  State<RadioListRating> createState() => _RadioListRatingState();
}

class _RadioListRatingState extends State<RadioListRating> {
  RatingLayanan? _character = RatingLayanan.R0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        RadioListTile<RatingLayanan>(
          title: const Text('Sangat Tidak Berkualitas'),
          value: RatingLayanan.R0,
          groupValue: _character,
          onChanged: (RatingLayanan? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<RatingLayanan>(
          title: const Text('Tidak Berkualitas'),
          value: RatingLayanan.R1,
          groupValue: _character,
          onChanged: (RatingLayanan? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<RatingLayanan>(
          title: const Text('Cukup Berkualitas'),
          value: RatingLayanan.R2,
          groupValue: _character,
          onChanged: (RatingLayanan? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<RatingLayanan>(
          title: const Text('Berkualitas'),
          value: RatingLayanan.R3,
          groupValue: _character,
          onChanged: (RatingLayanan? value) {
            setState(() {
              _character = value;
            });
          },
        ),
        RadioListTile<RatingLayanan>(
          title: const Text('Sangat Berkualitas'),
          value: RatingLayanan.R4,
          groupValue: _character,
          onChanged: (RatingLayanan? value) {
            setState(() {
              _character = value;
            });
          },
        ),
      ]),
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
    return MaterialApp(
      title: 'Laporan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: AddPage(),
    );
  }
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: Scaffold(
  //       body: ListView(
  //         children:const [
  //           statusWidgetList(teks: "test teks"),
  //           statusWidgetList(teks: "test teks"),
  //           statusWidgetList(teks: "test teks"),
  //           statusWidgetList(teks: "test teks"),
  //
  //             ],
  //           ),
  //       ),
  //     );
  //  }
}

class statusWidgetList extends StatelessWidget {
  final String teks;
  const statusWidgetList({Key? key, required this.teks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Text('A')),
      title: Text(teks),
      subtitle: const Text('Supporting text'),
      trailing: const Text('10.00 PM'),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_login_screen/ui/page/listpage.dart';
import 'package:flutter/material.dart';
// import '../../model/user.dart';
import '../../services/firebase_crud.dart';

class AddPage extends StatefulWidget{


@override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPage();
  }
}

class _AddPage extends State<AddPage> {
  // final name = user.displayName;
  // final email = user.email;
  // final photoUrl = user.photoURL;
  // final emailVerified = user.emailVerified;
  // final uid = user.uid;

  // String? uid;
  // String? iduser;
  // String? tanggal;
  // String? nama;
  // String? jenis_kelamin;
  // String? kategori;
  // String? pengaduan;
  // String?
  User? user = FirebaseAuth.instance.currentUser;
  
// // Check if the user is signed in
//   if (user != null) {
//   String uid = user.uid; // <-- User ID
//   String? email = user.email; // <-- Their email
//   }
  final _laporan_nama = TextEditingController();
  final _laporan_pengaduan = TextEditingController();
  final _laporan_rating = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void initState() {
    // TODO: implement initState
    _laporan_nama.value =
        TextEditingValue(text: user!.displayName.toString());
  }
  @override
  Widget build(BuildContext context) {
    print(user);
    final nameField = TextFormField(
        controller: _laporan_nama,

        readOnly: false,
        autofocus: false,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Nama",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final positionField = TextFormField(
        controller: _laporan_pengaduan,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            // contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

            hintText: "Laporan",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final contactField = TextFormField(
        controller: _laporan_rating,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Rating",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final viewListbutton = TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ListPage(),
            ),
            (route) => false, //To disable back feature set to false
          );
        },
        child: const Text('List Laporan'));

    final SaveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await FirebaseCrud.addLaporan(

                nama: _laporan_nama.text,
                pengaduan: _laporan_pengaduan.text,
                rating: _laporan_rating.text,
                iduser: user!.uid,
                jenis_kelamin: 'L',
                kategori: '',
                tanggal: '');
            if (response.code != 200) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            }
          }
        },
        child: Text(
          "Save",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Input Laporan'),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    nameField,
                    const SizedBox(height: 25.0),
                    positionField,
                    const SizedBox(height: 35.0),
                    contactField,
                    viewListbutton,
                    const SizedBox(height: 45.0),
                    SaveButon,
                    const SizedBox(height: 15.0),
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

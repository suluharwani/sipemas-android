import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/ui/page/listpage.dart';

// import '../../model/user.dart';
import '../../services/firebase_crud.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPage();
  }
}

class _AddPage extends State<AddPage> {
  User? user = FirebaseAuth.instance.currentUser;

  final _laporan_nama = TextEditingController();
  final _laporan_pengaduan = TextEditingController();
  final _laporan_rating = TextEditingController();
  final _ratingPelayanan = TextEditingController();
  final _jenisKelamin = TextEditingController();
  String? _selectedOptionRating;
  String? _selectedOptionGender;

  String? _selectedOptionKategori;
  String? _selectedOptionSubKategori;

  List<String> _optionsKategori = [
    'Pengaduan Bagian Medis',
    'Pengaduan Non Medis',
    'Pengaduan Bagian Sarana Prasarana'
  ];
  Map<String, List<String>> _optionsSubKategori = {
    'Pengaduan Bagian Medis': [
      'Poli Umum',
      'Pelayanan Gigi',
      'Pelayanan KIA/KB',
      'Pelayanan imunisasi',
      'Pelayanan gizi',
      'Pelayanan p2p',
      'Pelayanan laboratorium',
      'Pelayanan darurat',
      'tindakan (RDT)',
      'Pelayanan nifas'
    ],
    'Pengaduan Non Medis': [
      'Loket pendaftaran',
      'pelayanan apotek',
      'pelayanan promosi kesehatan',
      'pelayanan sanitasi lingkungan'
    ],
    'Pengaduan Bagian Sarana Prasarana': [
      'Ruangan pelayanan medis',
      'kamar mandi/WC pasien',
      'KM/WC persalinan',
      'Parkir kendaraan',
      'ambulance'
    ],
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void initState() {
    // print(user);
    // TODO: implement initState
    // _laporan_nama.value = TextEditingValue(text: user!.displayName.toString());
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        controller: _laporan_nama,
        readOnly: false,
        autofocus: false,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Nama Pelapor/Pasien",
            labelText: "Nama Pelapor/Pasien",
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final genderField = DropdownButtonFormField<String>(
      value: _selectedOptionGender,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: "Jenis Kelamin",
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      items: <String>['Laki-laki', 'Perempuan']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedOptionGender = value;
        });
      },
      onSaved: (String? value) {
        _selectedOptionGender = value;
      },
    );
    final RatingLayananField = DropdownButtonFormField<String>(
      value: _selectedOptionRating,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'Rating Pelayanan',
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      items: <String>[
        'Sangat Tidak Berkualitas',
        'Tidak Berkualitas',
        'Cukup Berkualitas',
        'Berkualitas',
        'Sangat Berkualitas'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedOptionRating = value;
        });
      },
      onSaved: (String? value) {
        _selectedOptionRating = value;
      },
    );
    final KategoriField = DropdownButtonFormField<String>(
      value: _selectedOptionKategori,
      decoration: InputDecoration(
        labelText: 'Kategori Layanan',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      items: _optionsKategori.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedOptionKategori = value;
          _selectedOptionSubKategori = null;
        });
      },
    );

    final SubKategoriField = DropdownButtonFormField<String>(
      value: _selectedOptionSubKategori,
      decoration: InputDecoration(
        labelText: 'Sub layanan',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      items: _selectedOptionKategori != null
          ? _optionsSubKategori[_selectedOptionKategori!]!.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
          : [],
      onChanged: (String? value) {
        setState(() {
          _selectedOptionSubKategori = value;
        });
      },
    );
    final laporanField = TextFormField(
        controller: _laporan_pengaduan,
        maxLines: null,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            // contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

            hintText: "Laporan",
            labelText: "Laporan",
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
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
            DateTime currentTime = DateTime.now();
            int timestamp = currentTime.millisecondsSinceEpoch;
            var response = await FirebaseCrud.addLaporan(
              nama: _laporan_nama.text,
              pengaduan: _laporan_pengaduan.text,
              // rating: _laporan_rating.text,
              rating: "$_selectedOptionRating",
              iduser: user!.uid,
              jenis_kelamin: "$_selectedOptionGender",
              kategori: "$_selectedOptionKategori",
              subkategori: "$_selectedOptionSubKategori",
              tanggal: "$timestamp",
              status: '0',
            );
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
                    const SizedBox(height: 20.0),
                    genderField,
                    const SizedBox(height: 25.0),
                    KategoriField,
                    const SizedBox(height: 30.0),
                    SubKategoriField,
                    const SizedBox(height: 35.0),
                    laporanField,
                    const SizedBox(height: 40.0),
                    RatingLayananField,
                    const SizedBox(height: 50.0),
                    viewListbutton,
                    const SizedBox(height: 55.0),
                    SaveButon,
                    const SizedBox(height: 60.0),
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

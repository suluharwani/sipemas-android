import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _Collection = _firestore.collection('Laporan');

class FirebaseCrud {
//CRUD method here
  static Future<Response> addLaporan({
    required String iduser,
    required String tanggal,
    required String nama,
    required String jenis_kelamin,
    required String kategori,
    required String subkategori,
    required String pengaduan,
    required String rating,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "iduser": iduser,
      "tanggal": tanggal,
      "nama": nama,
      "jenis_kelamin": jenis_kelamin,
      "kategori": kategori,
      "subkategori": subkategori,
      "pengaduan": pengaduan,
      "rating": rating
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Berhasil ditambahkan database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readLaporan() {
    final iduser = FirebaseAuth.instance.currentUser!.uid;

    Query<Object?> notesItemCollection =
        _Collection.where("iduser", isEqualTo: iduser);

    return notesItemCollection.snapshots();
  }

  // Future<QuerySnapshot> readLaporan() async {
  //   final iduser = FirebaseAuth.instance.currentUser!.uid;
  //
  //   FirebaseFirestore.instance
  //       .collection("laporan")
  //       .doc(iduser)
  //       .get();
  // }
  static Future<Response> updateLaporan({
    required String iduser,
    required String tanggal,
    required String nama,
    required String jenis_kelamin,
    required String kategori,
    required String subkategori,
    required String pengaduan,
    required String rating,
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "iduser": iduser,
      "tanggal": tanggal,
      "nama": nama,
      "jenis_kelamin": jenis_kelamin,
      "kategori": kategori,
      "subkategori": subkategori,
      "pengaduan": pengaduan,
      "rating": rating
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Berhasil update Laporan";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> deleteLaporan({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Laporan berhasil dihapus";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}

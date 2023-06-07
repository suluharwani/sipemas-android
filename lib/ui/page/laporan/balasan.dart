import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BalasanList extends StatefulWidget {
  @override
  _BalasanListState createState() => _BalasanListState();
}

class _BalasanListState extends State<BalasanList> {
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    // Mendapatkan current user ID dari FirebaseAuth
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserId = currentUser.uid;
    }
  }

  String formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Balasan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Balasan')
            .where('iduser', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final balasanDocs = snapshot.data!.docs;

          if (balasanDocs.isEmpty) {
            return Center(
              child: Text('Tidak ada data balasan.'),
            );
          }

          return ListView.builder(
            itemCount: balasanDocs.length,
            itemBuilder: (context, index) {
              final balasanData =
                  balasanDocs[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(balasanData['balasan']),
                subtitle: Text(formatDate(balasanData['tanggal'].toInt())),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Detail Balasan'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Balasan: ${balasanData['balasan']}'),
                            Text(
                                'Jenis Kelamin: ${balasanData['jenis_kelamin']}'),
                            Text('Kategori: ${balasanData['kategori']}'),
                            Text('Nama: ${balasanData['nama']}'),
                            Text('Pengaduan: ${balasanData['pengaduan']}'),
                            Text('Rating: ${balasanData['rating']}'),
                            Text('Subkategori: ${balasanData['subkategori']}'),
                            Text(
                                'Tanggal: ${formatDate(balasanData['tanggal'].toInt())}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Tutup'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

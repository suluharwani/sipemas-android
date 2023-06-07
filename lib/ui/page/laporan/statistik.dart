import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  String formatDate(String timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return '${date.day}/${date.month}/${date.year}';
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Laporan belum dibaca';
      case 1:
        return 'Laporan sudah dibaca';
      case 2:
        return 'Laporan sudah ditanggapi';
      default:
        return 'Status tidak valid';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistik'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Laporan')
              .where('iduser', isEqualTo: _user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            List<QueryDocumentSnapshot<Map<String, dynamic>>> reports =
                snapshot.data!.docs;

            return Column(
              children: [
                for (var report in reports)
                  ListTile(
                    title: Text(report['nama']),
                    subtitle: Text(formatDate(report['tanggal'].toString())),
                    trailing: Text(getStatusText(int.parse(report['status']))),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

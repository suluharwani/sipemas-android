import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewStatisticPage extends StatefulWidget {
  @override
  _ReviewStatisticPageState createState() => _ReviewStatisticPageState();
}

class _ReviewStatisticPageState extends State<ReviewStatisticPage> {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Statistik'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

          var reports = snapshot.data!.docs;
          var data = _generateChartData(reports);

          return Column(
            children: [
              Text(
                'Jumlah Laporan Berdasarkan Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: charts.BarChart(
                  data,
                  animate: true,
                  vertical: false,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                  domainAxis: charts.OrdinalAxisSpec(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<charts.Series<StatusData, String>> _generateChartData(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> reports) {
    var statusData = <StatusData>[
      StatusData('Laporan belum dibaca', 0),
      StatusData('Laporan sudah dibaca', 0),
      StatusData('Laporan sudah ditanggapi', 0),
    ];

    for (var report in reports) {
      var status = int.parse(report['status']);
      if (status >= 0 && status <= 2) {
        statusData[status].count++;
      }
    }

    return [
      charts.Series<StatusData, String>(
        id: 'Status',
        data: statusData,
        domainFn: (StatusData data, _) => data.status,
        measureFn: (StatusData data, _) => data.count,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (StatusData data, _) => '${data.count}',
      ),
    ];
  }
}

class StatusData {
  final String status;
  int count;

  StatusData(this.status, this.count);
}

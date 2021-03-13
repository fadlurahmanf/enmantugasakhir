import 'package:commons/commons.dart';
import 'package:enmantugasakhir/database/realtimedatabase.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphicEnergyConsumption extends StatefulWidget {
  @override
  _GraphicEnergyConsumptionState createState() => _GraphicEnergyConsumptionState();
}

class _GraphicEnergyConsumptionState extends State<GraphicEnergyConsumption> {
  var kwh = "";
  var tanggal = "";
  List<TimeSeriesChartData> chartdata = [];
  List namabulan = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
  getDataRealTimeDataBase()async{
    var result = await RealTimeDatabaseServices.getFromUsername();
    DataSnapshot data = result;
    Map<dynamic, dynamic> map = data.value;
    map.forEach((key, value) {
      var tanggal_lengkap = key.toString();
      var tanggal = tanggal_lengkap.split("-")[0];
      var bulan = tanggal_lengkap.split("-")[1];
      var tahun = tanggal_lengkap.split("-")[2];
      chartdata.add(TimeSeriesChartData(DateTime(int.parse(tahun), int.parse(bulan), int.parse(tanggal)), double.parse(value["kwh"])));
      chartdata.sort((a, b){
        int compare = a.tanggal.compareTo(b.tanggal);
        return compare;
      });
      setState(() {

      });
    });
  }

  getTimeChartData(){
    List<charts.Series<TimeSeriesChartData, DateTime>> series = [
      charts.Series(
        id: 'Data Penggunaan Energi',
        data: chartdata,
        domainFn: (TimeSeriesChartData data,_)=>data.tanggal,
        measureFn: (TimeSeriesChartData data,_)=>data.jumlah,
      ),
    ];
    return series;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataRealTimeDataBase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GRAFIK KONSUMSI ENERGI'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.TimeSeriesChart(
                getTimeChartData(),
                animate: true,
                selectionModels: [
                  charts.SelectionModelConfig(
                    changedListener: (charts.SelectionModel model){
                      kwh = model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
                      var datatanggal = model.selectedSeries[0].domainFn(model.selectedDatum[0].index).toString();
                      var tanggal_lengkap = (datatanggal.split(" "))[0];
                      var bulan = int.parse((tanggal_lengkap.split("-"))[1]);
                      tanggal = (tanggal_lengkap.split("-"))[2]+" "+namabulan[bulan-1]+" "+(tanggal_lengkap.split("-"))[0];
                      setState(() {

                      });
                    }
                  )
                ],
              ),
            ),
            SizedBox(height: 50,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: 300,
              height: 100,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Text("Energi yang dipakai : ${kwh} kwh"),
                  SizedBox(height: 10,),
                  Text("Tanggal pemakaian : " + tanggal),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green[600]),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green[600],
                    offset: Offset(-5, 5),
                  ),
                ]
              ),
              margin: EdgeInsets.symmetric(vertical: 20),
            ),
          ],
        ),
      ),
    );
  }
}
class TimeSeriesChartData{
  DateTime tanggal;
  double jumlah;
  TimeSeriesChartData(this.tanggal, this.jumlah);
}

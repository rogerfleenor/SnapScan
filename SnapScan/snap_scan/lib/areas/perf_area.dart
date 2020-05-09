import 'package:flutter/material.dart';
import 'package:snap_scan/api_services.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:snap_scan/widgets/perf_chart.dart';

int today = 256;
int average = 200;
int best = 0;
int max = 1000;

class PerformanceArea extends StatelessWidget {
  PerformanceArea();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(36.0),
        child: AppBar(
          title:
              Text("Daily Performance", style: TextStyle(color: Colors.black)),
          automaticallyImplyLeading: false,
          backgroundColor: OrangeColor,
          elevation: 0,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 12, top: 4, right: 12, bottom: 16),
        child: DailyPerformance(),
      ),
    );
  }
}

class DailyPerformance extends StatefulWidget {
  DailyPerformance();

  @override
  _DailyPerformanceState createState() => _DailyPerformanceState();
}

class _DailyPerformanceState extends State<DailyPerformance> {
  bool isLoading = false;

  @override
  initState() {
    super.initState();
  }

  List<charts.Series<DailyPerf, String>> mapChartData() {
    final maxNums = [
      DailyPerf('Today', max - today),
      DailyPerf('Average', max - average),
      DailyPerf('Best', max - best)
    ];

    /// Create one series with pass in data.
    return [
      charts.Series<DailyPerf, String>(
        id: 'Performance',
        colorFn: (_, __) => charts.Color(r: 240, g: 150, b: 30, a: 254),
        domainFn: (DailyPerf perf, _) => perf.day,
        measureFn: (DailyPerf perf, _) => perf.count,
        data: perfNums(),
      ),
      charts.Series<DailyPerf, String>(
        id: 'Maximum',
        colorFn: (_, __) => charts.Color(r: 0, g: 0, b: 0, a: 254),
        domainFn: (DailyPerf perf, _) => perf.day,
        measureFn: (DailyPerf perf, _) => perf.count,
        data: maxNums,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (!perfFetched) {
      fetchPerf();
    }
    return Container(
      child: PerfBarChart(mapChartData(), max~/5),
    );
  }

  List<DailyPerf> perfNums() {
    if (isLoading) {
      return [
        //data from object pulled from mongodb
        DailyPerf('Today', 0),
        DailyPerf('Average', 0),
        DailyPerf('Best', 0)
      ];
    } else {
      return [
        //locally stored data origin mongodb
        DailyPerf('Today', today),
        DailyPerf('Average', average),
        DailyPerf('Best', best)
      ];
    }
  }

  //PERFORMANCE - ROGER FLEENOR

  void fetchPerf() async {
    print("fetching");
    setState(() {
      isLoading = true; //performance data loading
    });
    performance = await getPerformance();
    setState(() {
      today = int.parse(performance.today);
      print("today " + performance.today);
      average = int.parse(performance.average);
      print("average "+ performance.average);
      best = int.parse(performance.best);
      print("best " + performance.best);
      findMax(best);
      perfFetched = true;
      isLoading = false; //performance data loaded
    });
  }
}

void incPerf() {
  today += 100;
  findMax(today);
}

void findMax(int num) {
  if (num > max) {
    max += 250;
    findMax(num);
  }
}

void updatePerf() {
  int oldToday = int.parse(performance.today);
  int oldAverage = int.parse(performance.average ?? 0);
  int oldBest = int.parse(performance.best ?? 0);
  int oldDays = int.parse(performance.days ?? 0);
  //performance.today = "0";
  int incAvg = (oldAverage * oldDays) + today;
  performance.average = (incAvg ~/ (oldDays + 1)).toString();
  if (today > oldBest) {
    performance.best = today.toString();
  }
  performance.days = (oldDays + 1).toString();
  putPerformance();
}

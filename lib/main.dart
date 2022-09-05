import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hive/screens/mainscreen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bottom_nav_bar.dart';
import 'lang.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onBoarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await GetStorage.init();
  final onBoarding = GetStorage();
  print('onBoarding çıktısı: ${onBoarding.read('onBoardingScreen')}');
  runApp(const App());
}

class Controller extends GetxController {
  final box = GetStorage();
  bool get isDark => box.read('darkmode') ?? true;
  ThemeData get theme => isDark ? FlexThemeData.dark() : FlexThemeData.light();
  void changeTheme(bool val) => box.write('darkmode', val);
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final dataLang = GetStorage();
  final box = GetStorage();
  final onBoarding = GetStorage();
  @override
  Widget build(BuildContext context) {
    return SimpleBuilder(builder: (_) {
      return GetMaterialApp(
        translations: LocaleString(),
        locale: const Locale('tr', 'TR'),
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(
  scheme: FlexScheme.outerSpace,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 20,
  appBarOpacity: 0.95,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    blendOnColors: false,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
darkTheme: FlexThemeData.dark(
  scheme: FlexScheme.greyLaw,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 30,
  appBarStyle: FlexAppBarStyle.background,
  appBarOpacity: 0.90,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 30,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
themeMode: box.read('darkmode') == false ? ThemeMode.light : ThemeMode.dark,

        initialRoute: onBoarding.read('onBoardingScreen') == 0 || onBoarding.read('onBoardingScreen') == null ? "first"  : "iki",
        routes: {
        'iki': (context) => box.read('userUid') == null ? const MainScreen() : const BottomNavBarPage(),
        "first": (context) => OnBoardingPage(),
      },
      );
    });
  }
}









// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// import 'package:intl/intl.dart';
// void main() {
//   return runApp(_ChartApp());
// }

// class _ChartApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: _MyHomePage(),
//     );
//   }
// }

// class _MyHomePage extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   _MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<_MyHomePage> {
//   DateTime _selectedDate = DateTime.now();
//   List<_SalesData> data = [
//     _SalesData(DateFormat('dd/MM/yyyy').format(DateTime(2016, 03, 12)).toString(), 35),
//     _SalesData(DateFormat('dd/MM/yyyy').format(DateTime(2016, 04, 2)).toString(), 28),
//     _SalesData(DateFormat('dd/MM/yyyy').format(DateTime(2016, 06, 26)).toString(), 34),
//     _SalesData(DateFormat('dd/MM/yyyy').format(DateTime(2016, 07, 30)).toString(), 32),
//     _SalesData(DateFormat('dd/MM/yyyy').format(DateTime(2016, 09, 17)).toString(), 40)
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Syncfusion Flutter chart'),
//         ),
//         body: Column(children: [
//           //Initialize the chart widget
//           SfCartesianChart(
//               primaryXAxis: CategoryAxis(),
//               // Chart title
//               title: ChartTitle(text: 'Half yearly sales analysis'),
//               // Enable legend
//               legend: Legend(isVisible: true),
//               // Enable tooltip
//               tooltipBehavior: TooltipBehavior(enable: true),
//               series: <ChartSeries<_SalesData, String>>[
//                 LineSeries<_SalesData, String>(
//                     dataSource: data,
//                     xValueMapper: (_SalesData sales, _) => sales.year,
//                     yValueMapper: (_SalesData sales, _) => sales.sales,
//                     name: 'Sales',
//                     // Enable data label
//                     dataLabelSettings: DataLabelSettings(isVisible: true))
//               ]),
//         ]));
//   }
// }

// class _SalesData {
//   _SalesData(this.year, this.sales);

//   final String year;
//   final double sales;
// }
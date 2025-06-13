import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tasbih/provider/counter_provider.dart';
import 'package:tasbih/splash/splash.dart';
import 'model/box_model/setting.dart';
import 'model/box_model/tasbih.dart';
import 'model/box_model/wazifa.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TasbihXAdapter());
  Hive.registerAdapter(CounterStateAdapter());
  Hive.registerAdapter(WazifaFavAdapter());
  await Hive.openBox<TasbihX>('tasbih');
  await Hive.openBox<CounterState>('setting');
  await Hive.openBox<WazifaFav>('wazifa');

  // MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(
  //     testDeviceIds: ['96CBD8BD3F59578240C6B3AF16D895BB'], // Your test device ID
  //   ),
  // );



  runApp(ChangeNotifierProvider(create: (context) => CounterProvider(),child: const MyApp(),));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          title: 'Islamic Digital Tasbeeh - dhkir',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 249, 249, 249)),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        )
    );
  }
}


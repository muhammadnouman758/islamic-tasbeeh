import 'package:hive/hive.dart';

import '../model/box_model/setting.dart';

class BoxCounterSetting{
  static Box<CounterState> getData() => Hive.box('setting');
}
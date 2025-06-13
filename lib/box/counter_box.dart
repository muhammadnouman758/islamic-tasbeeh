import 'package:hive/hive.dart';

import '../model/box_model/tasbih.dart';


class BoxTasbih {
  static Box<TasbihX> getData() => Hive.box('tasbih');
}
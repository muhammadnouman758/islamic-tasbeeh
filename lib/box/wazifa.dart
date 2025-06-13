import 'package:hive/hive.dart';

import '../model/box_model/wazifa.dart';



class BoxWazifa{
  static Box<WazifaFav> getData() => Hive.box('wazifa');
}
import 'package:hive/hive.dart';

part 'wazifa.g.dart';

@HiveType(typeId: 2)
class WazifaFav extends HiveObject{
  @HiveField(0)
  final bool fav ;
  @HiveField(1)
  final int index ;
  WazifaFav({required this.fav,required this.index});
}
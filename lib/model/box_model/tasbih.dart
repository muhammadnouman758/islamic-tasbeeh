import 'package:hive/hive.dart';
part 'tasbih.g.dart';
@HiveType(typeId: 3)
class TasbihX extends HiveObject{
  @HiveField(0)
  final int minute ;
  @HiveField(1)
  final int second ;
  @HiveField(2)
  final int count ;
  @HiveField(3)
  final int limit ;
  @HiveField(4)
  final int laps ;
  @HiveField(5)
  final String tasbihText ;
  @HiveField(6)
  final bool isRunning ;

  TasbihX({required this.minute, required this.second, required this.count, required this.limit, required this.laps, required this.tasbihText, required this.isRunning});


}
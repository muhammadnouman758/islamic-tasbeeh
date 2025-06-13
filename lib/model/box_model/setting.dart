import 'package:hive/hive.dart';

part 'setting.g.dart';

@HiveType(typeId: 1)
class CounterState extends HiveObject{
  @HiveField(0)
  final int previous ;
  CounterState({required this.previous});
}
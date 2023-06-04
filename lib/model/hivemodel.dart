import 'package:hive/hive.dart';
part 'hivemodel.g.dart';

@HiveType(typeId: 0)
class HiveModel extends HiveObject {
  @HiveField(0)
  late String sid;

  @HiveField(1)
  late String sname;

  @HiveField(2)
  late String sprice;

  HiveModel({required this.sid, required this.sname, required this.sprice});
}

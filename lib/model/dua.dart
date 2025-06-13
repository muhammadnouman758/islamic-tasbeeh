class DuaModel {
  String? title_ur;
  String? title_en;
  String? name;
  final int count = 100;

  DuaModel({this.title_ur,this.title_en,this.name, });

  DuaModel.fromJson(Map<String, dynamic> json) {
    title_ur = json['title_ur'];
    title_en = json['title_en'];
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title_ur'] = title_ur;
    data['title_en'] = title_en;
    data['name'] = name;
    data['count'] = count;
    return data;
  }

  static List<DuaModel> duaList = [];
}

class DarrodModel {
  String? title_ur;
  String? title_en;
  String? name;
  String? desc_ur;
  String? desc_en;
  int? count;

  DarrodModel({this.title_ur,this.title_en,this.name, this.desc_ur,this.desc_en, this.count});

  DarrodModel.fromJson(Map<String, dynamic> json) {
    title_ur = json['title_ur'];
    title_en = json['title_en'];
    name = json['name'];
    desc_ur = json['desc_ur'];
    desc_en = json['desc_en'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title_ur'] = title_ur;
    data['title_en'] = title_en;
    data['name'] = name;
    data['desc_ur'] = desc_ur;
    data['desc_en'] = desc_en;
    data['count'] = count;
    return data;
  }

  static List<DarrodModel> daroodList = [];
}

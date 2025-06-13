class  Tasbhat {
  String? name;
  String? desc_ur;
  String? desc_en;
  int? count;
  String? benefits_ur;
  String? benefits_en;

  Tasbhat({this.name, this.desc_ur,this.desc_en, this.count , this.benefits_ur,this.benefits_en});

  Tasbhat.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc_ur = json['desc_ur'];
    desc_en = json['desc_en'];
    count = json['count'];
    benefits_ur = json['benefits_ur'];
    benefits_en = json['benefits_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['name'] = name;
    data['desc_ur'] = desc_ur;
    data['desc_en'] = desc_en;
    data['count'] = count;
    data['benefits_ur'] = benefits_ur;
    data['benefits_en'] = benefits_en;
    return data;
  }
  static List<Tasbhat> tasbih = [] ;
}
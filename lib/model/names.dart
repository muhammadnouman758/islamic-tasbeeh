class Muhammad {
  final String name ;
  final int count;
  final String desc_ur;
  final String desc_en;
  const Muhammad(this.name,this.count,this.desc_ur,this.desc_en);

  factory Muhammad.fromMap(Map<dynamic,dynamic> map){
    return Muhammad(
      map['name'],
      map['count'],
      map['desc_ur'],
      map['desc_en'],
    );
  }
  toMap()=> {
    'name' : name ,
    'count':count,
    'desc_ur' : desc_ur,
    'desc_en' : desc_en,
  };
  static List<Muhammad> listMuhammad = [];


}
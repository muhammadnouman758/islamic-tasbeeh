class FamousModel {
  final String name ;
  final int count;
  const FamousModel(this.name,this.count,);

  factory FamousModel.fromMap(Map<dynamic,dynamic> map){
    return FamousModel(
      map['name'],
      map['count'],

    );
  }
  toMap()=> {
    'name' : name ,
    'count':count,

  };
  static List<FamousModel> famousList = [];


}
// class UserModel{

//   String? name;
//   String? id;
//   String? phone;
//   String? childEmail;
//   String? parentEmail;
//    String? type;

//   UserModel({this.name,this.childEmail,this.id,this.parentEmail,this.phone,this.type});
//   Map<String,dynamic> toJson()=>{
//     'name':name,
//     'phone':phone,
//     'id':id,
//     'childEmail':childEmail,
//     'parentEmail':parentEmail,
//     'type':type
//   };



// }

class UserModel {
  String? name;
  String? id;
  String? phone;
  String? childEmail;
  String? parentEmail;
  String? type;
  String? adminEmail;  // Added this field

  UserModel({
    this.name,
    this.id,
    this.phone,
    this.childEmail,
    this.parentEmail,
    this.type,
    this.adminEmail,  // Added this constructor parameter
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'phone': phone,
      'id': id,
      'type': type,
    };

    // Only include childEmail and parentEmail if the type is not 'admin'
    if (type != 'admin') {
      data['childEmail'] = childEmail;
      data['parentEmail'] = parentEmail;
    } else {
      // For admins, include adminEmail instead
      data['adminEmail'] = adminEmail;
    }

    return data;
  }
}

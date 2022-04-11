class User_model {
  bool? status;
  String? message;
  String? name;
  String? email;
  String? uid;

  User_model({this.status, this.message, this.name, this.email, this.uid});

  User_model.fromJson(Map<String?, dynamic> json) {
    status = json['status'];
    message = json['message'];
    name = json['name'];
    email = json['email'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['name'] = name;
    data['email'] = email;
    data['uid'] = uid;
    return data;
  }
}
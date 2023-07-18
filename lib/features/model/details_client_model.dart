import 'box_model.dart';

class Order {
  int? id;
  String? nom;
  String? prenom;
  String? ville;
  String? pays;
  String? telephone;
  String? mail;
  String? reservation;
  int? orderConfirmation;
  Box? box;

  Order({this.id, this.nom, this.prenom, this.ville, this.pays, this.telephone, this.mail, this.box});

 Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    ville = json['ville'];
    pays = json['pays'];
    telephone = json['telephone'];
    mail = json['mail'];
    orderConfirmation = json['order_confirmation'];
    reservation = json['reservation'];
    box = Box.fromJson(json['box']);
  }

  /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['box'] = this.box;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }*/
}
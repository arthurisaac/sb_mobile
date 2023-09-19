class NewOrder {
  String? user;
  String? box;
  String? deliveryPlace;
  String? nomClient;
  String? prenomClient;
  String? villeClient;
  String? paysClient;
  String? telephoneClient;
  String? mailClient;
  String? promoCode;
  String? total;
  String? paymentMethod;
  int? orderConfirmation;
  String? delivreyConfirmation;
  String? trique;
  String? updatedAt;
  String? createdAt;
  int? id;

  NewOrder(
      {this.user,
        this.box,
        this.deliveryPlace,
        this.nomClient,
        this.prenomClient,
        this.villeClient,
        this.paysClient,
        this.telephoneClient,
        this.mailClient,
        this.promoCode,
        this.total,
        this.paymentMethod,
        this.orderConfirmation,
        this.delivreyConfirmation,
        this.trique,
        this.updatedAt,
        this.createdAt,
        this.id});

  NewOrder.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    box = json['box'];
    deliveryPlace = json['delivery_place'];
    nomClient = json['nom_client'];
    prenomClient = json['prenom_client'];
    villeClient = json['ville_client'];
    paysClient = json['pays_client'];
    telephoneClient = json['telephone_client'];
    mailClient = json['mail_client'];
    promoCode = json['promo_code'];
    total = json['total'];
    paymentMethod = json['payment_method'];
    orderConfirmation = json['order_confirmation'];
    delivreyConfirmation = json['delivrey_confirmation'];
    trique = json['trique'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['box'] = this.box;
    data['delivery_place'] = this.deliveryPlace;
    data['nom_client'] = this.nomClient;
    data['prenom_client'] = this.prenomClient;
    data['ville_client'] = this.villeClient;
    data['pays_client'] = this.paysClient;
    data['telephone_client'] = this.telephoneClient;
    data['mail_client'] = this.mailClient;
    data['promo_code'] = this.promoCode;
    data['total'] = this.total;
    data['payment_method'] = this.paymentMethod;
    data['order_confirmation'] = this.orderConfirmation;
    data['delivrey_confirmation'] = this.delivreyConfirmation;
    data['trique'] = this.trique;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

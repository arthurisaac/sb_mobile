class FAQ {
  int? id;
  String? question;
  String? response;
  String? createdAt;
  String? updatedAt;

  FAQ({this.id, this.question, this.response, this.createdAt, this.updatedAt});

  FAQ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    response = json['response'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['response'] = response;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
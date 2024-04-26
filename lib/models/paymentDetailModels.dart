class PaymentDetailApiModel {
  List<PaymentDetailModel>? values;

  PaymentDetailApiModel({this.values});

  PaymentDetailApiModel.fromJson(Map<String, dynamic> json) {
    if (json['values'] != null) {
      values = <PaymentDetailModel>[];
      json['values'].forEach((v) {
        values!.add(PaymentDetailModel.fromJson(v));
      });
    }
  }
}

class PaymentDetailModel {
  String? sId;
  int? rate;
  String? title;
  String? details;
  String? date;

  PaymentDetailModel(
      {this.sId, this.rate, this.title, this.details, this.date});

  PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rate = json['rate'];
    title = json['title'];
    details = json['details'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['rate'] = this.rate;
    data['title'] = this.title;
    data['details'] = this.details;
    data['date'] = this.date;
    return data;
  }
}

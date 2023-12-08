

class ListProducts {
  String?bid;
  String? companyto;
  String? description;
  String? image;
  double? price;
  int? peers;
  String? parabirimi;
  DateTime? datetime;


  ListProducts({this.bid,this.companyto,this.description, this.image, this.price, this.peers,this.parabirimi,this.datetime});

  ListProducts.fromJson(Map<String, dynamic> json) {
    bid= json['bid'];
    companyto = json['companyto'];
    description = json['description'];
    image = json['image'];
    price = json['price']== null ? 0.0 : json['price'].toDouble();
    peers = json['peers']== null ? 0 : json['price'].toInt();
    parabirimi=json['parabirimi'];
    datetime = DateTime.parse(json['datetime'] as String);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bid'] = this.bid;
    data['companyto'] = this.companyto;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['peers'] = this.peers;
    data['parabirimi'] = this.parabirimi;
    data['datetime'] = this.datetime;

    return data;
  }
}
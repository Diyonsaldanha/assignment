class StockDataModel {
  late String s1Symbol;
  late String s2Name;

  StockDataModel({required this.s1Symbol, required this.s2Name});

  StockDataModel.fromJson(Map<String, dynamic> json) {
    s1Symbol = json['1. symbol'];
    s2Name = json['2. name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1. symbol'] = s1Symbol;
    data['2. name'] = s2Name;
    return data;
  }
}

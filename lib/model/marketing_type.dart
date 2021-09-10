class MarketingType {
  final String code;
  final String description;

  const MarketingType(this.code, this.description);

    MarketingType.fromJson(Map<String, dynamic> json)
      :  code = json['code'],
         description = json['description'];
}

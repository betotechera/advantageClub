class DiscountType {
  final String code;
  final String description;

  const DiscountType(this.code, this.description);

   DiscountType.fromJson(Map<String, dynamic> json)
      :  code = json['code'],
         description = json['description'];
}

import 'package:intl/intl.dart';

import 'discount_type.dart';
import 'marketing_type.dart';

class Advantage {
  final String id;
  final String name;
  final String logo;
  final DateTime beginDate;
  final MarketingType marketingType;
  final DateTime endDate;
  final String adhesionContract;
  final String externalLink;
  final List<String> hirers;
  final String email;
  final String cashbackFromPartner;
  final String cashbackToClient;
  final String cashbackToHirer;
  final String call;
  final String callActionImage;
  final String teaser;
  final String functioningDescription;
  final DiscountType discountType;
  final String discountValue;

  const Advantage(
      this.id,
      this.name,
      this.logo,
      this.beginDate,
      this.endDate,
      this.adhesionContract,
      this.externalLink,
      this.hirers,
      this.email,
      this.cashbackFromPartner,
      this.cashbackToClient,
      this.cashbackToHirer,
      this.call,
      this.teaser,
      this.functioningDescription,
      this.discountType,
      this.discountValue,
      this.callActionImage, this.marketingType);

  Advantage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        logo = json['logo'],
        beginDate = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json['beginDate']),
        endDate = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(json['endDate']),
        adhesionContract = json['adhesionContract'],
        externalLink = json['externalLink'],
        hirers = json['hirers'],
        email = json['email'],
        cashbackFromPartner = json['cashbackFromPartner'],
        cashbackToClient = json['cashbackToClient'],
        cashbackToHirer = json['cashbackToHirer'],
        call = json['call'],
        callActionImage = json['callActionImage'],
        teaser = json['teaser'],
        marketingType = MarketingType.fromJson(json['marketingType']),
        functioningDescription = json['functioningDescription'],
        discountType = json['discountType'],
        discountValue = json['discountValue'];
}

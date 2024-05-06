import 'package:firebase_database/firebase_database.dart';

class AccountModel{
  String key,companyName,address,ownershipName,imageUrl;
  AccountModel({
    required this.key,
    required this.companyName,
    required this.address,
    required this.ownershipName,
    required this.imageUrl,
});
}
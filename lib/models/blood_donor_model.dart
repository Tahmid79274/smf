import '../utils/functionalities/functions.dart';

class BloodDonorModel {
  String key,
      name,
      rhFactor,
      bloodGroup,
      dateOfBirth,
      lastDateOfBloodDonated,
      nextDateOfBloodDonated,
      cityName,
      districtName,
      divisionName,
      postCode,
      photoUrl;
  bool isAbleToDonateBlood;

  BloodDonorModel(
      {required this.key,
      required this.name,
      required this.rhFactor,
      required this.bloodGroup,
      required this.dateOfBirth,
      required this.nextDateOfBloodDonated,
      required this.cityName,
      required this.divisionName,
      required this.districtName,
      required this.postCode,
      required this.photoUrl,
      required this.lastDateOfBloodDonated,
      required this.isAbleToDonateBlood
      });
}

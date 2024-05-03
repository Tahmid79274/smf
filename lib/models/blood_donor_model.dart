class BloodDonorModel {
  String key,
      name,
      dateOfBirth,
      bloodGroup,
      rhFactor,
      phoneNumber,
  email,
      cityName,
      districtName,
      divisionName,
      postCode,
      lastDateOfBloodDonated,
      nextDateOfBloodDonated,
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
      required this.isAbleToDonateBlood,
      required this.phoneNumber,
      required this.email,
      });
}

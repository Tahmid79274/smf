class BloodDonorModel {
  String key,
      name,
      dateOfBirth,
      bloodGroup,
      rhFactor,
      phoneNumber,
  address,
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
      required this.address,
      required this.photoUrl,
      required this.lastDateOfBloodDonated,
      required this.isAbleToDonateBlood,
      required this.phoneNumber,
      });
}

class GlobalVar {
  static String customNameEncoder(String name) {
    String encodedName =
        "${name.replaceAll(' ', '_')}?${DateTime.now().toString().replaceAll(' ', '@').replaceAll('.', ':')}";
    return encodedName;
  }

  static String customNameDecoder(String encodedName) {
    String decodedName = encodedName.split('?').first;
    decodedName = decodedName.replaceAll('_', ' ');
    return decodedName;
  }

  static String nextDateToDonateBlood(String lastDateBloodDonated) {
    DateTime nextDate = DateTime.parse(lastDateBloodDonated);
    print('From Function Next Date is $nextDate');
    return nextDate.add(const Duration(days: 90)).toString().split(' ').first;
  }

  static bool bloodDonorStatus(String lastDateBloodDonated) {
    DateTime lastDate = DateTime.parse(lastDateBloodDonated);
    print('Last date frm function:$lastDate');
    print('difference frm function:${lastDate.difference(DateTime.now()).inDays}');
    if (DateTime.now().difference(lastDate).inDays>=90) {
      return true;
    }
    return false;
  }

  static Map<String, String> englishDigitToBengaliDigitMap = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  static String englishNumberToBengali(String digit) {
    String bengaliVersion = '';
    for (int i = 0; i < digit.length; i++) {
      bengaliVersion += englishDigitToBengaliDigitMap[digit[i]]!;
    }
    return bengaliVersion;
  }
}

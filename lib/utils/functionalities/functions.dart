class GlobalVar {
  static String customNameEncoder(String name) {
    String encodedName = "${name.replaceAll(' ', '_')}?${DateTime.now().toString().replaceAll(' ', '@').replaceAll('.', ':')}";
    return encodedName;
  }

  static String customNameDecoder(String encodedName) {
    String decodedName = encodedName.split('?').first;
    decodedName = decodedName.replaceAll('_', ' ');
    return decodedName;
  }
}

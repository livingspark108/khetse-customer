String? validatePhoneNumber(String? value) {
  if (value!.isEmpty) {
    return 'Phone number is required';
  }

  if (RegExp(r'^(\d)\1{9}$').hasMatch(value)) {
    return 'Invalid phone number';
  }

  List<String> blacklisted = [
    '1234567890',
    '0123456789',
    '1111111111',
    '2222222222',
    '3333333333',
    '4444444444',
    '5555555555',
    '6666666666',
    '7777777777',
    '8888888888',
    '9999999999',
    '0000000000',
  ];

  print("VALUE = $value");

  if (blacklisted.contains(value)) {
    return 'Invalid phone number';
  }

  return null;
}

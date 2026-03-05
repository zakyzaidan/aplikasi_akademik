class Validators {
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus diisi';
    }
    return null;
  }

  static String? validateNumerical(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nilai harus diisi';
    }
    try {
      double.parse(value);
      return null;
    } catch (e) {
      return 'Nilai harus berupa angka';
    }
  }

  static String? validateNumericalRange(String? value, double min, double max) {
    if (value == null || value.isEmpty) {
      return 'Nilai harus diisi';
    }
    try {
      double numValue = double.parse(value);
      if (numValue < min || numValue > max) {
        return 'Nilai harus antara $min-$max';
      }
      return null;
    } catch (e) {
      return 'Nilai harus berupa angka';
    }
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return 'Field harus diisi';
    }
    if (value.length < minLength) {
      return 'Minimal $minLength karakter';
    }
    return null;
  }
}

class Validators {
  static String? required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;

  static String? email(String? value) {
    if (required(value) != null) return required(value);
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim())
        ? null
        : 'Please enter a valid email address.';
  }

  static String? confirmPassword(String? value, String password) =>
      required(value) ??
      (value != password ? 'The passwords do not match.' : null);
}

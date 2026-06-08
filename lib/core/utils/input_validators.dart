class InputValidators {
  const InputValidators._();

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email is required';
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    return valid ? null : 'Enter a valid email address';
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.length < 8) return 'Use at least 8 characters';
    return null;
  }

  static String? requiredText(String? value) {
    return (value?.trim().isEmpty ?? true) ? 'This field is required' : null;
  }
}

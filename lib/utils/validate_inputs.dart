String? validateField(String id, String? value, String? validator) {
  if (validator == null) return null;

  final rules = validator.split(',');
  for (var rule in rules) {
    if (rule == 'required' && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    if (rule == 'email' &&
        (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))) {
      return 'Please enter a valid email address';
    }
    if (rule.startsWith('minLength:')) {
      final minLength = int.parse(rule.split(':')[1]);
      if (value == null || value.length < minLength) {
        return 'Minimum length is $minLength';
      }
    }
  }
  return null;
}

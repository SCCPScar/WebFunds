/// Presentation-layer input validation — form-level checks only.
class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Introduz o teu email.';
    }
    if (!_emailPattern.hasMatch(value.trim())) {
      return 'Introduz um email válido.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Introduz a tua palavra-passe.';
    }
    if (value.length < 8) {
      return 'A palavra-passe deve ter pelo menos 8 caracteres.';
    }
    return null;
  }
}
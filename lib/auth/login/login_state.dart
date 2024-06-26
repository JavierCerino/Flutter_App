
import 'package:giusseppe_flut/auth/form_submission_status.dart';

class LoginState {
  final String email;

  bool get isValidUsername => email.length > 3 && _isEmailValid(email);

  bool _isEmailValid(String email) {
    // Utiliza una expresión regular para verificar si el email tiene un formato válido.
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }


  final String password;
  bool get isValidPassword => password.length > 6;

  final FormSubmissionStatus formStatus;

  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
    }
  );

  LoginState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus?? this.formStatus,
    );
  }
}
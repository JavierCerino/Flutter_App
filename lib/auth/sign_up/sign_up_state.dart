
import 'package:giusseppe_flut/auth/form_submission_status.dart';

class SignUpState {
  final String username;
  final String password;
  final String fullname;
  final int age;
  final String phone;
  final String genero;
  final String city;
  final String locality;

  bool get isValidUsername => username.length > 3;

  bool get isValidPassword => password.length > 6;
  
  bool get isValidFullName => fullname.length > 3;

  bool get isValidPhone => phone.length == 10;

  bool get isValidCity => city.length > 3;

  bool get isValidLocality => locality.length > 3;

  final FormSubmissionStatus formStatus;

  SignUpState({
    this.username = '',
    this.password = '',
    this.fullname = '',
    this.age = 0,
    this.phone = '',
    this.genero = '',
    this.city = '',
    this.locality = '',
    this.formStatus = const InitialFormStatus(),
    }
  );

  SignUpState copyWith({
    String? username,
    String? password,
    String? fullname,
    int? age,
    String? phone,
    String? genero,
    String? city,
    String? locality,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
      username: username ?? this.username,
      password: password ?? this.password,
      fullname: fullname ?? this.fullname,
      age: age ?? this.age,
      phone: phone ?? this.phone,
      genero: genero ?? this.genero,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      formStatus: formStatus?? this.formStatus,
    );
  }
}
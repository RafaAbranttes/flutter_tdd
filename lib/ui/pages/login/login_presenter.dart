abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String passworf);

  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isFormValidStream;
}

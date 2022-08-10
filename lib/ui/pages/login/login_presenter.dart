abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String passworf);
  void auth();

  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isFormValidStream;
  Stream get isLoadingController;
}

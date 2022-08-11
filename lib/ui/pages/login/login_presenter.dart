abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String passworf);
  void auth();
  void dispose();

  Stream get emailErrorStream;
  Stream get passwordErrorStream;
  Stream get isFormValidStream;
  Stream get isLoadingController;
  Stream get mainErrorStrem;
}

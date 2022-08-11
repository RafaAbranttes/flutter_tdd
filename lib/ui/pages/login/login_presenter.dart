abstract class LoginPresenter {
  void validateEmail(String email);
  void validatePassword(String passworf);
  void auth();
  void dispose();

  Stream<String> get emailErrorStream;
  Stream<String> get passwordErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingController;
  Stream<String> get mainErrorStrem;
}

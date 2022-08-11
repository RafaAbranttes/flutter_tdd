import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/ui/pages/login/components/components.dart';
import 'package:flutter_tdd_study/ui/pages/login/login_presenter.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;
  const LoginPage({this.presenter, Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingController.listen(
            (isLoading) {
              if (isLoading) {
                showLoading(context);
              } else {
                hideLoading(context);
              }
            },
          );

          widget.presenter.mainErrorStrem.listen((isError) {
            if (isError != null) {
              showErrorMessage(context, isError);
            }
          });
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const HeadLine1(
                  text: 'Login',
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Provider<LoginPresenter>(
                    create: (context) => widget.presenter,
                    child: Form(
                      child: Column(
                        children: [
                          const EmailInput(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 32,
                            ),
                            child: StreamBuilder<String>(
                                stream: widget.presenter.passwordErrorStream,
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    onChanged:
                                        widget.presenter.validatePassword,
                                    decoration: InputDecoration(
                                      errorText: snapshot.data?.isEmpty == true
                                          ? null
                                          : snapshot.data,
                                      labelText: 'Senha',
                                      icon: const Icon(Icons.lock),
                                    ),
                                    obscureText: true,
                                  );
                                }),
                          ),
                          StreamBuilder<bool>(
                              stream: widget.presenter.isFormValidStream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  onPressed: snapshot.data == true
                                      ? widget.presenter.auth
                                      : null,
                                  child: Text(
                                    'Entrar'.toUpperCase(),
                                  ),
                                );
                              }),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person),
                            label: const Text('Criar Conta'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

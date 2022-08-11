import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/ui/pages/login/login_presenter.dart';

import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;
  const LoginPage({this.presenter, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingController.listen(
            (isLoading) {
              if (isLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => SimpleDialog(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Aguarde...",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              }
            },
          );

          presenter.mainErrorStrem.listen((isError) {
            if (isError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[900],
                  content: Text(
                    isError,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
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
                  child: Form(
                    child: Column(
                      children: [
                        StreamBuilder<String>(
                          stream: presenter.emailErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              onChanged: presenter.validateEmail,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                icon: const Icon(Icons.email),
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 32,
                          ),
                          child: StreamBuilder<String>(
                              stream: presenter.passwordErrorStream,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  onChanged: presenter.validatePassword,
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
                            stream: presenter.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? presenter.auth
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
              ],
            ),
          );
        },
      ),
    );
  }
}

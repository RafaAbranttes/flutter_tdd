import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: presenter.validatePassword,
          decoration: InputDecoration(
            errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            labelText: 'Senha',
            icon: const Icon(Icons.lock),
          ),
          obscureText: true,
        );
      },
    );
  }
}

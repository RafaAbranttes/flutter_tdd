import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/domain/entities/account_entity.dart';

abstract class Authentication{

  Future<AccountEntity>  auth({
    @required String email,
    @required String password,
  });

}
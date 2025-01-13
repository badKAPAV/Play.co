import 'package:dartz/dartz.dart';
import 'package:musify/core/usecase/usecase.dart';
import 'package:musify/data/models/auth/create_user_req.dart';
import 'package:musify/domain/repository/auth/auth.dart';
import 'package:musify/service_locator.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq? params}) {
    return sl<AuthRepository>().signup(params!);
  }
}

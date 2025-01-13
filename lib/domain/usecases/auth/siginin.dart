import 'package:dartz/dartz.dart';
import 'package:musify/core/usecase/usecase.dart';
import 'package:musify/data/models/auth/signin_user_req.dart';
import 'package:musify/domain/repository/auth/auth.dart';
import 'package:musify/service_locator.dart';

class SigninUseCase implements UseCase<Either, SigninUserReq> {
  @override
  Future<Either> call({SigninUserReq? params}) {
    return sl<AuthRepository>().signin(params!);
  }
}

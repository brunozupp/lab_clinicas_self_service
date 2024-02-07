import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';

abstract interface class IInformationFormRepository {

  Future<Either<RepositoryException, Unit>> register(SelfServiceModel model);
}
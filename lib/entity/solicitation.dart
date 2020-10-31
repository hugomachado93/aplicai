import 'package:aplicai/entity/demanda.dart';
import 'package:aplicai/entity/user_entity.dart';

class Solicitation {
  String motivationText;
  UserEntity userEntity;
  Demanda demanda;

  Solicitation({this.motivationText, this.userEntity, this.demanda});
}

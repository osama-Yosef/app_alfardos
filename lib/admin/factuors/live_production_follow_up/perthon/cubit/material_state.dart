
import '../../data/model/material_entity _model.dart';

abstract class MaterialState {}

class MaterialLoading extends MaterialState {}

class MaterialLoaded extends MaterialState {
  final List<MaterialEntity> materials;
  MaterialLoaded(this.materials);
}

class MaterialError extends MaterialState {
  final String message;
  MaterialError(this.message);
}

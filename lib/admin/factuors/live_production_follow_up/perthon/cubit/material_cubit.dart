// ===================== material_cubit.dart =====================
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/material_entity _model.dart';
import '../../data/repo/repo.dart';
import 'material_state.dart';

class MaterialCubit extends Cubit<MaterialState> {
  final MaterialRepository repository;
  StreamSubscription? _subscription;

  MaterialCubit(this.repository) : super(MaterialLoading()) {
    _watchMaterials();
  }

  void _watchMaterials() {
    _subscription?.cancel();
    _subscription = repository.watchMaterials().listen(
          (materials) => emit(MaterialLoaded(materials)),
      onError: (e) => emit(MaterialError(e.toString())),
    );
  }

  Future<void> addMaterial(MaterialEntity material) async {
    await repository.addMaterial(material);
  }

  Future<void> deleteMaterial(String id) async {
    await repository.deleteMaterial(id);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'material_state.dart';

class MaterialCubit extends Cubit<MaterialState> {
  MaterialCubit() : super(MaterialInitial());
}

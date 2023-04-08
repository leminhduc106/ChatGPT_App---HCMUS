import 'package:bloc/bloc.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingState(isAutoRead: false));

  void toggleAutoRead() {
    emit(SettingState(isAutoRead: !state.isAutoRead));
  }
}

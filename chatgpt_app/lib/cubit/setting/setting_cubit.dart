import 'package:bloc/bloc.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit()
      : super(SettingState(isAutoRead: false, currentLanguage: 'en-US'));

  void toggleAutoRead() {
    emit(SettingState(
        isAutoRead: !state.isAutoRead, currentLanguage: state.currentLanguage));
  }

  void changeLanguage(String language) {
    emit(SettingState(isAutoRead: state.isAutoRead, currentLanguage: language));
  }
}

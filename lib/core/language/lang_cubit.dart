import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:iot_baby_watch/common/extensions/locale_x.dart';

import '../utils/logger.dart';
import 'lang_repository_interface.dart';

@singleton
class LangCubit extends Cubit<Locale> {
  LangCubit(
    this._repository,
  ) : super(_repository.getLocale());

  final ILangRepository _repository;

  void setLocale(Locale val) async {
    try {
      await _repository.setLocale(val);
      logger.d('currentLocale - ${val.fullLanguageCode}');
      emit(val);
    } catch (error) {
      logger.e(error);
    }
  }
}

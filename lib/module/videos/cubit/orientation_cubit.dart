import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'orientation_state.dart';

class OrientationCubit extends Cubit<OrientationState> {
  OrientationCubit() : super(OrientationPortrait());

  void changeOrientation() {
    if (state is OrientationPortrait) {
      emit(OrientationLandscape());
    } else {
      emit(OrientationPortrait());
    }
  }
}

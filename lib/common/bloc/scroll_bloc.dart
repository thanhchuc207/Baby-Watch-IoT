import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  final ScrollController scrollController;

  ScrollCubit(this.scrollController) : super(ScrollState.middle) {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.offset >=
        scrollController.position.minScrollExtent + 150) {
      emit(ScrollState.top);
    } else if (scrollController.offset >=
        scrollController.position.maxScrollExtent) {
      emit(ScrollState.bottom);
    } else {
      emit(ScrollState.middle);
    }
  }

  @override
  Future<void> close() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    return super.close();
  }
}

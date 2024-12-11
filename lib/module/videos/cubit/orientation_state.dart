part of 'orientation_cubit.dart';

@immutable
abstract class OrientationState extends Equatable {
  const OrientationState();
  @override
  List<Object> get props => [];
}

class OrientationPortrait extends OrientationState {
  const OrientationPortrait();
}

class OrientationLandscape extends OrientationState {
  const OrientationLandscape();
}

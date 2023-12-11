import 'package:equatable/equatable.dart';

abstract class ScannerState extends Equatable {}

class ImageInitialState extends ScannerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ImageLoadedState extends ScannerState {
  final String imageText;

  ImageLoadedState(this.imageText);

  @override
  // TODO: implement props
  List<Object?> get props => [imageText];
}

class ImageErrorState extends ScannerState {
  final String errorMsg;

  ImageErrorState(this.errorMsg);

  @override
  // TODO: implement props
  List<Object?> get props => [errorMsg];
}

class ImageLoadingState extends ScannerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

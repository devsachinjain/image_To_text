import 'package:equatable/equatable.dart';

import '../../model/images_model.dart';

abstract class StorageState extends Equatable {}

class StorageInitialState extends StorageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StorageLoadedState extends StorageState {
  final List<ScannedImageModel> storeImageList;

  StorageLoadedState(this.storeImageList);

  @override
  // TODO: implement props
  List<Object?> get props => [storeImageList];
}

class StorageLoadingState extends StorageState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StorageErrorState extends StorageState {
  final String errorMsg;

  StorageErrorState(this.errorMsg);

  @override
  // TODO: implement props
  List<Object?> get props => [errorMsg];
}

class StorageUpdatingState extends StorageState {
  final List<ScannedImageModel> storeImageList;

  StorageUpdatingState(this.storeImageList);

  @override
  // TODO: implement props
  List<Object?> get props => [storeImageList];
}

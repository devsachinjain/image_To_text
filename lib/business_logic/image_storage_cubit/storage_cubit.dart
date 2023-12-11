import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_to_text_flutter/business_logic/image_storage_cubit/storage_state.dart';
import '../../data/get_stored_data_repository.dart';
import '../../model/images_model.dart';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit(this._dataRepository) : super(StorageInitialState());

  final StoredDataRepository _dataRepository;

  List<ScannedImageModel> storeImageList = [];

  getStorageData() async {
    emit(StorageLoadingState());

    var data = await _dataRepository.getStoredDataList();
    if (data != 'error') {
      storeImageList.clear();
      storeImageList.addAll(data);
      emit(StorageLoadedState(storeImageList));
    } else {
      emit(StorageErrorState('Error in getting data.'));
      debugPrint('Error in getting data.');
    }
  }

  getPinedData() async {
    emit(StorageLoadingState());

    var data = await _dataRepository.getPinedDataList();
    if (data != 'error') {
      storeImageList.clear();
      storeImageList.addAll(data);
      emit(StorageLoadedState(storeImageList));
    } else {
      emit(StorageErrorState('Error in getting data.'));
      debugPrint('Error in getting data.');
    }
  }

  deleteData(
    int id,
    int index,
  ) async {
    emit(StorageUpdatingState(storeImageList));
    bool result = await _dataRepository.deleteImageData(id);
    if (result) {
      storeImageList.removeAt(index);
    } else {
      debugPrint('Error in deleting data.');
    }
    emit(StorageLoadedState(storeImageList));
  }

  updateImageStatus(int id, int index) async {
    emit(StorageUpdatingState(storeImageList));

    bool result = await _dataRepository.updateImageData(
        id, storeImageList[index].bookmark == "1" ? "0" : "1");
    if (result) {
      ScannedImageModel item = storeImageList[index];

      storeImageList[index] = ScannedImageModel.withId(item.id, item.imageText,
          item.imagePath, item.date, item.bookmark == "1" ? "0" : "1");
    } else {
      debugPrint('Error in deleting data.');
    }
    emit(StorageLoadedState(storeImageList));
  }
}

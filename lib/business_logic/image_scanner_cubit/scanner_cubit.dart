import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text_flutter/business_logic/image_scanner_cubit/scanner_state.dart';
import '../../data/text_recognised_text_repository.dart';

class ImageScannerCubit extends Cubit<ScannerState> {
  ImageScannerCubit(this._repository) : super(ImageInitialState());

  XFile? imageFile;

  String scannedText = "";

  final RecognisedTextRepository _repository;

  void onImageSelect(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        emit(ImageLoadingState());
        CroppedFile? croppedFile = await _repository.cropImage(pickedImage);
        imageFile = XFile(croppedFile!.path);
        getRecognisedTextFun(imageFile!);
      }
    } catch (e) {
      imageFile = null;
      scannedText = "Error occurred while scanning";
      emit(ImageErrorState('Error occurred while scanning'));
    }
  }

  void getRecognisedTextFun(XFile image) async {
    scannedText = await _repository.getRecognisedText(image);
    await _repository.saveImage(image, scannedText);
    emit(ImageLoadedState(scannedText));
  }
}

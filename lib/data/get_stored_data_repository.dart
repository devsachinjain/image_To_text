import 'package:flutter/cupertino.dart';
import '../model/images_model.dart';
import '../utils/db_helper.dart';

class StoredDataRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<dynamic> getStoredDataList() async {
    try {
      var dataList = await dbHelper.getAllImagesDate();

      debugPrint('Data List :- ${dataList.length}');

      return dataList
          .map((e) => ScannedImageModel.fromMapObject(e))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return "error";
    }
  }

  Future<dynamic> getPinedDataList() async {
    try {
      var dataList = await dbHelper.getPinedImagesDate();

      debugPrint('Data List :- ${dataList.length}');

      return dataList
          .map((e) => ScannedImageModel.fromMapObject(e))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      return "error";
    }
  }
  Future<bool> deleteImageData(int id) async {
    try {
      int result = await dbHelper.deleteImage(id);
      if(result == 1){
        return true;
      }else{
        return false;
      }

    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateImageData(int id,String status) async {
    try {
      int result = await dbHelper.updateImageData(id,status);
      if(result == 1){
        return true;
      }else{
        return false;
      }

    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

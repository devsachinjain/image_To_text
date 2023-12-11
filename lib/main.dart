import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_text_flutter/business_logic/image_storage_cubit/storage_cubit.dart';
import 'package:image_to_text_flutter/data/get_stored_data_repository.dart';
import 'package:image_to_text_flutter/presentation/screens/home.dart';
import 'package:image_to_text_flutter/utils/apptheme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Mobile App Instance
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StorageCubit(StoredDataRepository())),
      ],
      child: MaterialApp(
        title: 'Text Extractor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme().themeData,
        home: ImageScannedPage(
          key: key,
        ),
      ),
    );
  }
}

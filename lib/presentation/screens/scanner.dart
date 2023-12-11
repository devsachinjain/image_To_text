import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text_flutter/data/text_recognised_text_repository.dart';
import 'package:share_plus/share_plus.dart';
import '../../business_logic/banner_ads_cubit/google_ads_cubit.dart';
import '../../business_logic/banner_ads_cubit/google_ads_state.dart';
import '../../business_logic/image_scanner_cubit/scanner_cubit.dart';
import '../../business_logic/image_scanner_cubit/scanner_state.dart';
import '../../business_logic/image_storage_cubit/storage_cubit.dart';

class Scanner extends StatelessWidget {
  Scanner({Key? key}) : super(key: key);

  final TextEditingController scannedTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ImageScannerCubit(
              RecognisedTextRepository(),
            ),
        child: BlocConsumer<ImageScannerCubit, ScannerState>(
          listener: (blocContext, state) {
            if (state is ImageLoadedState) {
              scannedTextController.text = state.imageText;
              BlocProvider.of<StorageCubit>(context).getStorageData();
            }
          },
          builder: (blocContext, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                actions: [
                  state is ImageLoadedState ?
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () async =>  Share.share(scannedTextController.text),
                  ) : Container(),

                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () => showBottomSheet(context, () {
                      Navigator.pop(context);
                      BlocProvider.of<ImageScannerCubit>(blocContext)
                          .onImageSelect(ImageSource.gallery);
                    }, () {
                      Navigator.pop(context);
                      BlocProvider.of<ImageScannerCubit>(blocContext)
                          .onImageSelect(ImageSource.camera);
                    }),
                  ),

                ],
                title: const Text("Scanned Text"),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state is ImageLoadingState)
                        const CircularProgressIndicator(),
                      if (state is ImageInitialState &&
                          blocContext.read<ImageScannerCubit>().imageFile ==
                              null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DottedBorder(
                            radius: const Radius.circular(12.0),
                            borderType: BorderType.RRect,
                            dashPattern: const [8, 4],
                            color: Theme.of(context).appBarTheme.backgroundColor!,
                            child: Container(
                              margin: const EdgeInsets.only(top: 25,bottom: 25),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        Icons.image,
                                        color: Theme.of(context).highlightColor,
                                        size: 80.0,
                                      ),
                                      onTap: ()=> showBottomSheet(context, () {
                                        Navigator.pop(context);
                                        BlocProvider.of<ImageScannerCubit>(blocContext)
                                            .onImageSelect(ImageSource.gallery);
                                      }, () {
                                        Navigator.pop(context);
                                        BlocProvider.of<ImageScannerCubit>(blocContext)
                                            .onImageSelect(ImageSource.camera);
                                      }),
                                    ),
                                    const SizedBox(height: 24.0),
                                    Text(
                                      'Upload an image to start',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                          color:
                                          Theme.of(context).highlightColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (state is ImageLoadedState)
                        Image.file(
                            File(blocContext
                                .read<ImageScannerCubit>()
                                .imageFile!
                                .path),
                            height: 200),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(thickness: 2,color: Theme.of(context).highlightColor,),
                      const SizedBox(
                        height: 10,
                      ),
                      state is ImageLoadedState
                          ? Card(
                              color: Colors.grey[200],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: scannedTextController,
                                  maxLines: 12, //or null

                                  decoration: InputDecoration(
                                    hintText: 'Recognised Text',
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon:  Icon(
                                        Icons.copy_outlined,
                                        size: 30,
                                        color: Theme.of(context).appBarTheme.backgroundColor,
                                      ),
                                      onPressed: () => Clipboard.setData(
                                          ClipboardData(
                                              text:
                                                  scannedTextController.text)),
                                    ),
                                  ),
                                ),
                              ))
                          : const Card(
                              color: Color(0xFFe9fbf3),
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Your Recognised Text Will Be Display Here.",
                                    style: TextStyle(fontSize: 20),
                                  ))),

                      BlocProvider(
                        create: (context) {
                          final cubit = AdsCubit(InitialAdsState());
                          cubit.initialiseBanner();
                          return cubit;
                        },
                        child: BlocBuilder<AdsCubit, AdsState>(
                            builder: (context, state) {
                              //BlocProvider.of<AdsCubit>(context).initialiseBanner();
                              if (state is LoadedAdsState) {
                                return SizedBox(
                                  height: state.bannerAd.size.height.toDouble(),
                                  width: state.bannerAd.size.width.toDouble(),
                                  child: AdWidget(ad: state.bannerAd),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  showBottomSheet(BuildContext context, VoidCallback galleryImageCallBack,
          VoidCallback cameraImageCallback) =>
      showModalBottomSheet(
        context: context,
        //backgroundColor: Theme.of(context),
        builder: (context) {
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.image,color: Theme.of(context).appBarTheme.backgroundColor,),
                title:  Text('Gallery',style: TextStyle(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),),
                onTap: galleryImageCallBack,
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_sharp,color: Theme.of(context).appBarTheme.backgroundColor,),
                title:  Text('Camera',style: TextStyle(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )),
                onTap: cameraImageCallback,
              ),
            ],
          );
        },
      );
}

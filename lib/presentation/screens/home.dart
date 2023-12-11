import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_to_text_flutter/business_logic/banner_ads_cubit/google_ads_cubit.dart';
import 'package:image_to_text_flutter/business_logic/banner_ads_cubit/google_ads_state.dart';
import 'package:image_to_text_flutter/business_logic/image_storage_cubit/storage_cubit.dart';
import 'package:image_to_text_flutter/business_logic/image_storage_cubit/storage_state.dart';
import 'package:image_to_text_flutter/presentation/screens/scanner_view.dart';
import 'package:share_plus/share_plus.dart';
import 'scanner.dart';

class ImageScannedPage extends StatelessWidget {
  const ImageScannedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 80),
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                        child: Text('RECENT',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Tab(
                        child: Text('PIN',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                )
              ],
            ),
          ),
         /* drawer: HomeDrawer(
            key: key,
          ),*/
          body: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(child: getRecentImagesData(context, 0)),
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
              getRecentImagesData(context, 1)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Scanner())),
            child: const Icon(Icons.camera),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),
        ));
  }

  Widget showLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getRecentImagesData(BuildContext context, int tabBarIndex) {
    return BlocBuilder<StorageCubit, StorageState>(
      builder: (context, state) {
        if (state is StorageInitialState) {
          context.read<StorageCubit>().getStorageData();
          return showLoader();
        } else if (state is StorageLoadedState) {
          if (state.storeImageList.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (state.storeImageList[index].bookmark == '0' &&
                    tabBarIndex == 1) {
                  return Container();
                }
                return Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),

                    // The start action pane is the one at the left or the top side.

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (val) {
                            context.read<StorageCubit>().deleteData(
                                state.storeImageList[index].id!, index);

                            final snackBar = SnackBar(
                              duration: const Duration(seconds: 2),
                              content: const Text('Item is deleted !'),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (val) async {
                            await Share.share(
                                state.storeImageList[index].imageText!);
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScannedImageView(
                                    imageData:
                                        state.storeImageList[index].imagePath!,
                                    text: state.storeImageList[index].imageText!
                                            .isNotEmpty
                                        ? state.storeImageList[index].imageText!
                                        : '---No Text Detected---',
                                  ))),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).highlightColor,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Image.file(
                                        File(state
                                            .storeImageList[index].imagePath!),
                                        height: 80,
                                        fit: BoxFit.cover),
                                    height: 100,
                                    width: 100,
                                  ),
                                  const SizedBox(
                                    width: 27,
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.storeImageList[index].imageText!
                                                  .isNotEmpty
                                              ? state.storeImageList[index]
                                                  .imageText!
                                              : 'No Text Detected.',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 17.0,
                                          ),
                                          maxLines: 4,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.storeImageList[index].date!,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context
                                                .read<StorageCubit>()
                                                .updateImageStatus(
                                                    state.storeImageList[index]
                                                        .id!,
                                                    index);
                                          },
                                          icon: Icon(
                                            state.storeImageList[index]
                                                        .bookmark ==
                                                    "0"
                                                ? Icons.bookmark_border
                                                : Icons.bookmark,
                                            color: Theme.of(context)
                                                .highlightColor,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
              itemCount: state.storeImageList.length,
            );
          } else {
            return const Center(
              child: Text(
                "No Recent Images",
                style: TextStyle(fontSize: 20),
              ),
            );
          }
        } else if (state is StorageUpdatingState) {
          if (state.storeImageList.isNotEmpty) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (state.storeImageList[index].bookmark == '0' &&
                    tabBarIndex == 1) {
                  return Container();
                }
                return Slidable(
                    key: const ValueKey(0),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (val) {
                            context.read<StorageCubit>().deleteData(
                                state.storeImageList[index].id!, index);

                            final snackBar = SnackBar(
                              content: const Text('Item is deleted !'),
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (val) async {
                            await Share.share(
                                state.storeImageList[index].imageText!);
                          },
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScannedImageView(
                                    imageData:
                                        state.storeImageList[index].imagePath!,
                                    text: state.storeImageList[index].imageText!
                                            .isNotEmpty
                                        ? state.storeImageList[index].imageText!
                                        : '---No Text Detected---',
                                  ))),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).highlightColor,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Image.file(
                                        File(state
                                            .storeImageList[index].imagePath!),
                                        height: 80,
                                        fit: BoxFit.cover),
                                    height: 100,
                                    width: 100,
                                  ),
                                  const SizedBox(
                                    width: 27,
                                  ),
                                  Flexible(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.storeImageList[index].imageText!
                                                  .isNotEmpty
                                              ? state.storeImageList[index]
                                                  .imageText!
                                              : 'No Text Detected.',
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 17.0,
                                          ),
                                          maxLines: 4,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.storeImageList[index].date!,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        context
                                            .read<StorageCubit>()
                                            .updateImageStatus(
                                                state.storeImageList[index].id!,
                                                index);
                                      },
                                      icon: Icon(
                                        state.storeImageList[index].bookmark ==
                                                "0"
                                            ? Icons.bookmark_border
                                            : Icons.bookmark,
                                        color: Theme.of(context).highlightColor,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
              itemCount: state.storeImageList.length,
            );
          } else {
            return const Center(
              child: Text(
                "No Recent Images",
                style: TextStyle(fontSize: 20),
              ),
            );
          }
        } else if (state is StorageErrorState) {
          return Center(
            child: Text(
              state.errorMsg,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }

        return showLoader();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ScannedImageView extends StatelessWidget {
  final String text;
  final String imageData;

  const ScannedImageView(
      {Key? key, required this.text, required this.imageData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              TabBar(
                padding: EdgeInsets.symmetric(horizontal: 80),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child: Text('TEXT',style: TextStyle(fontWeight: FontWeight.bold),)),
                  Tab(child: Text('IMAGE',style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [getScannedText(context), getImage(context)],
        ),
      ),
    );
  }

  Widget getScannedText(BuildContext context) => Card(
        margin:  const EdgeInsets.all(10.0),
        color: Colors.white,
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        onPressed: () async =>
                        Share.share(text),
                        icon: const Icon(Icons.share)),
                    IconButton(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                        onPressed: () =>
                            Clipboard.setData(ClipboardData(text: text)),
                        icon: const Icon(Icons.copy_outlined)),
                  ],
                ),
                SelectableText(
                  text,
                  style: const TextStyle(fontSize: 20),
                )
              ],
            )),
      );

  Widget getImage(BuildContext context) => Center(
        child: Image.file(File(imageData), fit: BoxFit.cover),
      );
}

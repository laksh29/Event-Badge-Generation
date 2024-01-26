import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:event_batch/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String eventName = "Devsigner";
  late TextEditingController nameCont;
  final GlobalKey _globalKey = GlobalKey();
  html.FileUploadInputElement? uploadInput;
  String? imageUrl;

  @override
  void initState() {
    nameCont = TextEditingController();
    super.initState();
    uploadInput = html.FileUploadInputElement()..accept = "image/*";
    uploadInput!.onChange.listen((event) {
      final files = uploadInput!.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.onLoadEnd.listen((event) {
          setState(() {
            imageUrl = reader.result as String?;
          });
        });
        reader.readAsDataUrl(file);
      }
    });
  }

  @override
  void dispose() {
    nameCont.dispose();
    super.dispose();
  }

  Future<Uint8List> screenshot() async {
    try {
      log("Screenshot process - started");

      RenderRepaintBoundary renderer = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await renderer.toImage(pixelRatio: 3.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      Uint8List png = byteData!.buffer.asUint8List();

      log("Screenshot - created");

      return png;
    } catch (e) {
      log("Error caught: $e");
      return Uint8List(0);
    }
  }

  Future saveBadge(Uint8List imageData) async {
    log("Image Saving - started");
    final blob = html.Blob([imageData]);

    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "${nameCont.text}_${eventName}_ Badge.png")
      ..click();

    html.Url.revokeObjectUrl(url);

    log("Image - Saved");
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Event Badge Demo"),
          elevation: 5.0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                buildHeight(20.0),
                BadgeWidget(
                  globalKey: _globalKey,
                  nameCont: nameCont,
                  profileImage: imageUrl,
                ),
                buildHeight(50.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: nameCont,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "Enter your Name",
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                buildHeight(50.0),
                Wrap(
                  spacing: 20.0,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        uploadInput!.click();

                        log("User Image - Uploaded");
                      },
                      child: const Text("Upload Image"),
                    ),
                    // buildWidth(20.0),
                    ElevatedButton(
                      onPressed: () async {
                        Uint8List image = await screenshot();

                        if (image != Uint8List(0)) {
                          saveBadge(image);
                        }

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Badge Saved")));
                        }
                      },
                      child: const Text("Download Badge"),
                    ),
                  ],
                ),
                buildHeight(100.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

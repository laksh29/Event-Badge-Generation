import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart';

import '../constants.dart';
import 'flutter_pulse_badge_widget.dart';

class FlutterPulsePage extends StatefulWidget {
  const FlutterPulsePage({Key? key}) : super(key: key);

  @override
  State<FlutterPulsePage> createState() => _FlutterPulsePageState();
}

class _FlutterPulsePageState extends State<FlutterPulsePage> {
  static const String eventName = "flutter-pulse";
  late TextEditingController nameCont;
  final GlobalKey _globalKey = GlobalKey();
  FileUploadInputElement? uploadInput;
  String? imageUrl;

  @override
  void initState() {
    nameCont = TextEditingController();
    super.initState();
    uploadInput = FileUploadInputElement()..accept = "image/*";
    uploadInput!.onChange.listen((event) {
      final files = uploadInput!.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = FileReader();
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
    final blob = Blob([imageData]);

    final url = Url.createObjectUrlFromBlob(blob);

    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "${nameCont.text}_${eventName}_ Badge.png")
      ..click();

    Url.revokeObjectUrl(url);

    log("Image - Saved");
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Pulse Badge"),
          elevation: 5.0,
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1)),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  buildHeight(20.0),
                  FlutterPulseBadgeWidget(
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
                  //! flutter build web --web-renderer canvaskit --release
                  const Text(
                    "Web Renderer - Canvas Kit",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

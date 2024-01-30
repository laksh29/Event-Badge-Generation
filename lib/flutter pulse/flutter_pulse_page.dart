import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:universal_html/html.dart' as html;

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
  html.FileUploadInputElement? uploadInput;
  String? imageUrl;

  final encodedText = Uri.encodeComponent(
      "I have registered for #FlutterPulse by #FlutterNagpur to #learnfromexperts and network to grab opportunities. ✨ \n\nHave you registered? \nIf not,  Register Now: lu.ma/Flutter-Pulse. 🚀 \n\nSee you on 24 Feb, 2024 🥳\n\n@FlutterNagpur @FlutterDev ");

  String debugText = "";
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

  void _launchUrl(String urlLink) {
    html.window.open(urlLink, '_blank');
  }

  SnackBar showSnackBar(String textContent) => SnackBar(
        content: Text(textContent),
      );

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Pulse Badge"),
          elevation: 5.0,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return Future.delayed(const Duration(seconds: 1));
          },
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: nameCont.text == ""
                              ? Theme.of(context).colorScheme.errorContainer
                              : Theme.of(context).colorScheme.surface,
                        ),
                        onPressed: () async {
                          Uint8List image = await screenshot();

                          if (image != Uint8List(0) && nameCont.text != "") {
                            saveBadge(image);
                          }

                          if (context.mounted) {
                            if (nameCont.text == "") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  showSnackBar("Please Enter your Name!"));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(showSnackBar("Badge Saved!"));
                            }
                          }
                        },
                        child: const Text("Download Badge"),
                      ),
                      ElevatedButton(
                        onPressed: () => _launchUrl(
                            "https://twitter.com/intent/tweet?text=$encodedText&url= "),
                        child: const Text("Tweet"),
                      ),
                    ],
                  ),
                  buildHeight(100.0),
                  Text(debugText),
                  const Text(
                    "Web Renderer - Canvas Kit: modified - 30-1-24:4:19",
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

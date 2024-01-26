import 'package:flutter/material.dart';

class FlutterPulseBadgeWidget extends StatelessWidget {
  const FlutterPulseBadgeWidget({
    super.key,
    required GlobalKey<State<StatefulWidget>> globalKey,
    required this.nameCont,
    required this.profileImage,
  }) : _globalKey = globalKey;

  final GlobalKey<State<StatefulWidget>> _globalKey;
  final TextEditingController nameCont;
  final String? profileImage;

  final String badgeAsset = "assets/flutter-pulse-badge.png";
  final Color nameColor = const Color(0xff043249);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: SizedBox(
        height: 500,
        child: AspectRatio(
          aspectRatio: 0.58,
          child: Stack(children: [
            Positioned(
              left: 70,
              top: 70,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      profileImage ??
                          "https://placehold.co/400x400/043249/FFFFFF/png?text=profile%20image",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(badgeAsset),
                ),
              ),
            ),
            Positioned.fill(
              top: 240,
              child: Text(
                nameCont.text,
                style: TextStyle(
                  color: nameColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

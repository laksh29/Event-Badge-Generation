import 'package:flutter/material.dart';

class DemoBadgeWidget extends StatelessWidget {
  const DemoBadgeWidget({
    super.key,
    required GlobalKey<State<StatefulWidget>> globalKey,
    required this.nameCont,
    required this.profileImage,
  }) : _globalKey = globalKey;

  final GlobalKey<State<StatefulWidget>> _globalKey;
  final TextEditingController nameCont;
  final String? profileImage;

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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/devsigner.png"),
                ),
              ),
            ),
            Positioned.fill(
              top: 250,
              child: Text(
                nameCont.text,
                style: const TextStyle(
                    color: Color(0xff043249),
                    fontSize: 25,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

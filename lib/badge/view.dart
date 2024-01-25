import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_extensions/super_extensions.dart';

import 'bloc/badge_bloc.dart';
import 'constants/button.dart';
import 'constants/text_fields.dart';

class BadgeView extends StatelessWidget {
  const BadgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.select((BadgeBloc bloc) => bloc.state.name);
    final GlobalKey controller = GlobalKey();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: const Color(0xff052D57),
          appBar: AppBar(
            backgroundColor: const Color(0xff052D57),
            elevation: 0,
            toolbarHeight: 100,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Flutter Conf India 2023 ',
                    style: TextStyle(
                      fontSize: context.isDesktop
                          ? constraints.maxWidth * 0.02
                          : constraints.maxWidth * 0.04,
                      fontFamily: "ClashDisplay",
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Badge',
                    style: TextStyle(
                      fontSize: context.isDesktop
                          ? constraints.maxWidth * 0.02
                          : constraints.maxWidth * 0.04,
                      fontFamily: "ClashDisplay",
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: context.isDesktop ? 20 : 5),
                  Image.asset(
                    'assets/devsigner.png',
                    height: context.isDesktop
                        ? constraints.maxWidth * 0.03
                        : constraints.maxWidth * 0.08,
                  )
                ],
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: IconButton(
                onPressed: () {
                  // GoRouter.of(context).go(home);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: context.isDesktop ? 40.0 : 0, horizontal: 10),
            child: context.isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TextField(width: context.screenWidth / 3),
                          const SizedBox(height: 20),
                          FlutterConfButton(
                            constraints: constraints,
                            text: 'Tweet',
                            fontSize: 14,
                            onPressed: () {
                              // GoRouter.of(context).go(tweet);
                            },
                          ),
                        ],
                      ),
                      _ImageWithDownloadButton(
                        controller: controller,
                        name: name,
                        constraints: constraints,
                        showButton: true,
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: _ImageWithDownloadButton(
                            controller: controller,
                            name: name,
                            constraints: constraints,
                            showButton: false,
                          ),
                        ),
                        _TextField(width: context.screenWidth),
                        const SizedBox(
                          height: 20,
                        ),
                        if (name.isNotEmpty)
                          Column(
                            children: [
                              FlutterConfButton(
                                constraints: constraints,
                                text: 'Download',
                                fontSize: 14,
                                onPressed: () {
                                  context.read<BadgeBloc>().add(
                                        BadgeDownloadRequestedEvent(
                                          controller: controller,
                                        ),
                                      );
                                },
                              ),
                              const SizedBox(height: 10),
                              FlutterConfButton(
                                constraints: constraints,
                                text: 'Tweet',
                                fontSize: 14,
                                onPressed: () {
                                  // GoRouter.of(context).go(tweet);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _ImageWithDownloadButton extends StatelessWidget {
  const _ImageWithDownloadButton({
    required this.controller,
    required this.name,
    required this.constraints,
    required this.showButton,
  });

  final GlobalKey<State<StatefulWidget>> controller;
  final String name;
  final BoxConstraints constraints;
  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: controller,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Material(
                elevation: 20,
                color: Colors.transparent,
                child: Image.asset(
                  'assets/devsigner.png',
                  height: context.screenHeight / 1.5,
                ),
              ),
              SizedBox(
                width: 200,
                child: Center(
                  child: AutoSizeText(
                    name,
                    maxLines: 2,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        if (name.isNotEmpty && showButton)
          FlutterConfButton(
            constraints: constraints,
            text: 'Download',
            fontSize: 14,
            onPressed: () {
              context.read<BadgeBloc>().add(
                    BadgeDownloadRequestedEvent(
                      controller: controller,
                    ),
                  );
            },
          ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: StunningTextField(
        onChanged: (value) {
          context.read<BadgeBloc>().add(ChangeNameEvent(name: value));
        },
      ),
    );
  }
}

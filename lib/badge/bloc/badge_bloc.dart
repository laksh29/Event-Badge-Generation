import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_html/html.dart';

part 'badge_event.dart';
part 'badge_state.dart';

class BadgeBloc extends Bloc<BadgeEvent, BadgeState> {
  BadgeBloc() : super(BadgeState.initial()) {
    on<BadgeDownloadRequestedEvent>(_onBadgeDownloadRequestedEvent);
    on<ChangeNameEvent>(_onChangeNameEvent);
  }

  void _onChangeNameEvent(
    ChangeNameEvent event,
    Emitter<BadgeState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onBadgeDownloadRequestedEvent(
    BadgeDownloadRequestedEvent event,
    Emitter<BadgeState> emit,
  ) async {
    log('inside capture');
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // ignore: use_build_context_synchronously
    final RenderRepaintBoundary? boundary = event.controller.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;
    final ui.Image image = await boundary!.toImage(pixelRatio: 3);

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    final base64 = base64Encode(pngBytes);

    AnchorElement(
        href: "data:application/octet-stream;charset=utf-16le;base64,$base64")
      ..setAttribute(
          "download", '${state.name.trim().replaceAll(' ', '_')}.png')
      ..click();

    log('capture done');
  }
}

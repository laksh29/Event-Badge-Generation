part of 'badge_bloc.dart';

abstract class BadgeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BadgeDownloadRequestedEvent extends BadgeEvent {
  final GlobalKey controller;

  BadgeDownloadRequestedEvent({required this.controller});

  @override
  List<Object?> get props => [controller];
}

class ChangeNameEvent extends BadgeEvent {
  final String name;

  ChangeNameEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

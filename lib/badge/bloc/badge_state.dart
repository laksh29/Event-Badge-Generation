part of 'badge_bloc.dart';

class BadgeState extends Equatable {
  const BadgeState({required this.name});

  final String name;

  factory BadgeState.initial() => const BadgeState(name: '');

  BadgeState copyWith({String? name}) {
    return BadgeState(name: name ?? this.name);
  }

  @override
  List<Object?> get props => [name];
}

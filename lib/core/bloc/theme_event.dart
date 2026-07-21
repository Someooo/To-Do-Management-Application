import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeLoadStarted extends ThemeEvent {
  const ThemeLoadStarted();
}

class ThemeThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeThemeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

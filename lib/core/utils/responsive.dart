import 'package:flutter/widgets.dart';

class Responsive {
  static const double _tabletBreakpoint = 600;
  static const double _desktopBreakpoint = 1024;

  static double get _logicalWidth {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final physicalSize = view.physicalSize;
    final devicePixelRatio = view.devicePixelRatio;
    return physicalSize.width / devicePixelRatio;
  }

  static bool get isMobile => _logicalWidth < _tabletBreakpoint;

  static bool get isTablet =>
      _logicalWidth >= _tabletBreakpoint && _logicalWidth < _desktopBreakpoint;

  static bool get isDesktop => _logicalWidth >= _desktopBreakpoint;
}

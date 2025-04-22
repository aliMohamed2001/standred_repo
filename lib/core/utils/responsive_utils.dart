import 'dart:ui';

import 'package:flutter/material.dart';

class ResponsiveUtils {
  MediaQueryData mediaQuery;
  final bool isDarkMode;
  final Color primaryColor;
  final Color backgroundColor;
  final bool isRTL;
  late bool _isSmallMobile;
  late bool _isMediumMobile;
  late bool _isMobile;
  late bool _isTablet;
  late bool _isLargeTablet;
  late bool _isDesktop;
  late bool _isLargeDesktop;
  late double _shortestSide;
  late double _screenWidth;
  late double _screenHeight;
  late Orientation _orientation;
  late bool _isPortrait;
  late bool _isLandscape;
  late double _aspectRatio;

  ResponsiveUtils(
    this.mediaQuery, {
    required this.isDarkMode,
    required this.primaryColor,
    required this.backgroundColor,
    required this.isRTL,
  }) {
    _updateCachedValues();
  }

  void update(MediaQueryData newMediaQuery) {
    mediaQuery = newMediaQuery;
    _updateCachedValues();
  }

  void _updateCachedValues() {
    _shortestSide = mediaQuery.size.shortestSide;
    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;
    _isSmallMobile = _shortestSide < 400;
    _isMediumMobile = _shortestSide >= 400 && _shortestSide < 600;
    _isMobile = _shortestSide < 600;
    _isTablet = _shortestSide >= 600 && _shortestSide < 900;
    _isLargeTablet = _shortestSide >= 900 && _shortestSide < 1200;
    _isDesktop = _shortestSide >= 900;
    _isLargeDesktop = _shortestSide >= 1200;
    _orientation = mediaQuery.orientation;
    _isPortrait = _orientation == Orientation.portrait;
    _isLandscape = _orientation == Orientation.landscape;
    _aspectRatio = _screenHeight > 0 ? _screenWidth / _screenHeight : 1.0; 
  }

  double get shortestSide => _shortestSide;
  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;
  bool get isSmallMobile => _isSmallMobile;
  bool get isMediumMobile => _isMediumMobile;
  bool get isMobile => _isMobile;
  bool get isTablet => _isTablet;
  bool get isLargeTablet => _isLargeTablet;
  bool get isDesktop => _isDesktop;
  bool get isLargeDesktop => _isLargeDesktop;
  Orientation get orientation => _orientation;
  bool get isPortrait => _isPortrait;
  bool get isLandscape => _isLandscape;
  double get aspectRatio => _aspectRatio;

  List<DisplayFeature> get displayFeatures => mediaQuery.displayFeatures;
  bool get hasFold => displayFeatures.any((feature) => feature.type == DisplayFeatureType.fold);
  bool get hasHinge => displayFeatures.any((feature) => feature.type == DisplayFeatureType.hinge);
  Rect get foldBounds {
    final foldFeature = displayFeatures.firstWhere(
      (feature) => feature.type == DisplayFeatureType.fold || feature.type == DisplayFeatureType.hinge,
      orElse: () => const DisplayFeature(
        bounds: Rect.zero,
        type: DisplayFeatureType.unknown,
        state: DisplayFeatureState.unknown,
      ),
    );
    return foldFeature.bounds;
  }
  bool isInFoldableArea(double position, {bool isVertical = true}) {
    if (!hasFold && !hasHinge) return false;
    final bounds = foldBounds;
    return isVertical
        ? position >= bounds.top && position <= bounds.bottom
        : position >= bounds.left && position <= bounds.right;
  }
  List<Rect> splitScreenByFold({bool isVertical = true}) {
    if (!hasFold && !hasHinge) return [Rect.fromLTWH(0, 0, screenWidth, screenHeight)];
    final bounds = foldBounds;
    if (isVertical) {
      return [
        Rect.fromLTWH(0, 0, screenWidth, bounds.top),
        Rect.fromLTWH(0, bounds.bottom, screenWidth, screenHeight - bounds.bottom),
      ];
    } else {
      return [
        Rect.fromLTWH(0, 0, bounds.left, screenHeight),
        Rect.fromLTWH(bounds.right, 0, screenWidth - bounds.right, screenHeight),
      ];
    }
  }

  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  double get devicePixelRatio => mediaQuery.devicePixelRatio;
  double widthPercentage(double percentage) => screenWidth * (percentage / 100);
  double heightPercentage(double percentage) => screenHeight * (percentage / 100);
  double scaleBySize(double baseSize) {
    return baseSize * (shortestSide / 400);
  }
  double scaleByDensity(double baseSize) => baseSize * devicePixelRatio;
  double responsiveAspectRatio(double baseAspectRatio) {
    if (isLargeDesktop) return baseAspectRatio * 1.2;
    if (isDesktop) return baseAspectRatio * 1.1;
    if (isTablet) return baseAspectRatio * 1.0;
    return baseAspectRatio * 0.9;
  }
  double responsiveTextScale(double baseFontSize) {
    final systemTextScale = mediaQuery.textScaler.scale(1.0);
    final deviceScale = isLargeDesktop
        ? 1.3
        : isDesktop
            ? 1.2
            : isTablet
                ? 1.0
                : isMediumMobile
                    ? 0.9
                    : 0.8;
    return baseFontSize * deviceScale * systemTextScale;
  }
  Text responsiveText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: style ?? const TextStyle(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textScaler: TextScaler.linear(
        isLargeDesktop ? 1.3 : isDesktop ? 1.2 : isTablet ? 1.0 : 0.9,
      ),
    );
  }
  TextStyle responsiveTextStyle(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontSize: responsiveTextScale(baseStyle.fontSize ?? 14),
      color: baseStyle.color ?? (isDarkMode ? Colors.white : Colors.black),
      fontWeight: isLargeDesktop
          ? FontWeight.w500
          : isDesktop
              ? FontWeight.w400
              : FontWeight.normal,
      letterSpacing: isMobile ? 0.5 : 1.0,
    );
  }
  double responsiveImageSize(double baseSize) {
    if (isLargeDesktop) return baseSize * 1.6;
    if (isDesktop) return baseSize * 1.5;
    if (isTablet) return baseSize * 1.2;
    return baseSize;
  }
  double responsiveIconSize(double baseSize) {
    if (isLargeDesktop) return baseSize * 1.6;
    if (isDesktop) return baseSize * 1.5;
    if (isTablet) return baseSize * 1.2;
    return baseSize;
  }
  Icon responsiveIcon(
    IconData icon, {
    Color? color,
    double? baseSize,
  }) {
    return Icon(
      icon,
      size: responsiveIconSize(baseSize ?? 24),
      color: color ?? (isDarkMode ? Colors.white : Colors.black),
    );
  }
  BorderRadius responsiveBorderRadius(double baseRadius) {
    double scale = isLargeDesktop ? 1.6 : isDesktop ? 1.5 : isTablet ? 1.2 : 1.0;
    return BorderRadius.circular(baseRadius * scale);
  }
  double responsiveAppBarHeight() {
    return isLargeDesktop
        ? 80
        : isDesktop
            ? 70
            : isTablet
                ? 60
                : 56;
  }
  double responsiveElementHeight(double baseHeight) {
    if (isLargeDesktop) return baseHeight * 1.3;
    if (isDesktop) return baseHeight * 1.2;
    if (isTablet) return baseHeight * 1.1;
    return baseHeight;
  }
  double responsiveElementWidth(double baseWidth) {
    if (isLargeDesktop) return baseWidth * 1.3;
    if (isDesktop) return baseWidth * 1.2;
    if (isTablet) return baseWidth * 1.1;
    return baseWidth;
  }
  EdgeInsets safePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    double scale = isLargeDesktop ? 1.6 : isDesktop ? 1.5 : isTablet ? 1.2 : 1.0;
    final safePadding = safeAreaPadding;
    return EdgeInsets.only(
      top: (top ?? vertical ?? all ?? 0) * scale + safePadding.top,
      bottom: (bottom ?? vertical ?? all ?? 0) * scale + safePadding.bottom,
      left: (left ?? horizontal ?? all ?? 0) * scale + safePadding.left,
      right: (right ?? horizontal ?? all ?? 0) * scale + safePadding.right,
    );
  }
  EdgeInsets responsivePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    double scale = isLargeDesktop ? 1.6 : isDesktop ? 1.5 : isTablet ? 1.2 : 1.0;
    return EdgeInsets.only(
      top: (top ?? vertical ?? all ?? 0) * scale,
      bottom: (bottom ?? vertical ?? all ?? 0) * scale,
      left: (left ?? horizontal ?? all ?? 0) * scale,
      right: (right ?? horizontal ?? all ?? 0) * scale,
    );
  }
  EdgeInsets responsiveMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    double scale = isLargeDesktop ? 1.6 : isDesktop ? 1.5 : isTablet ? 1.2 : 1.0;
    return EdgeInsets.only(
      top: (top ?? vertical ?? all ?? 0) * scale,
      bottom: (bottom ?? vertical ?? all ?? 0) * scale,
      left: (left ?? horizontal ?? all ?? 0) * scale,
      right: (right ?? horizontal ?? all ?? 0) * scale,
    );
  }
  Alignment responsiveAlignment() {
    return isRTL ? Alignment.centerRight : Alignment.centerLeft;
  }
  BoxShadow responsiveBoxShadow({
    Color? color,
    double? blurRadius,
    double? spreadRadius,
    Offset? offset,
  }) {
    double scale = isLargeDesktop ? 1.6 : isDesktop ? 1.5 : isTablet ? 1.2 : 1.0;
    return BoxShadow(
      color: color ?? Colors.black.withOpacity(0.2),
      blurRadius: (blurRadius ?? 4) * scale,
      spreadRadius: (spreadRadius ?? 1) * scale,
      offset: offset ?? const Offset(0, 2),
    );
  }
  Widget responsiveContainer({
    required Widget child,
    double? widthPercentage,
    double? heightPercentage,
    Color? color,
    double? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      width: widthPercentage != null ? this.widthPercentage(widthPercentage) : null,
      height: heightPercentage != null ? this.heightPercentage(heightPercentage) : null,
      padding: padding ?? responsivePadding(all: 8),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? backgroundColor,
        borderRadius: borderRadius != null ? responsiveBorderRadius(borderRadius) : null,
        boxShadow: boxShadow ?? [responsiveBoxShadow()],
      ),
      child: child,
    );
  }
  Widget responsiveButton({
    required VoidCallback onPressed,
    required String text,
    double? baseFontSize,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? textColor,
    EdgeInsets? padding,
    double? elevation,
    Size? minimumSize,
    Size? maximumSize,
    BorderSide? side,
    void Function(bool)? onHover,
    void Function(bool)? onFocusChange,
    VoidCallback? onLongPress,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      onHover: onHover,
      onFocusChange: onFocusChange,
      onLongPress: onLongPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? primaryColor,
        foregroundColor: foregroundColor ?? primaryColor.withOpacity(0.8),
        padding: padding ?? responsivePadding(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: responsiveBorderRadius(8),
          side: side ?? BorderSide.none,
        ),
        elevation: elevation ?? (isMobile ? 2 : 4),
        minimumSize: minimumSize,
        maximumSize: maximumSize,
      ),
      child: responsiveText(
        text,
        style: TextStyle(
          fontSize: baseFontSize ?? 16,
          color: textColor ?? (isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
  Widget responsiveTextButton({
    required VoidCallback onPressed,
    required String text,
    double? baseFontSize,
    Color? textColor,
    void Function(bool)? onHover,
    void Function(bool)? onFocusChange,
  }) {
    return TextButton(
      onPressed: onPressed,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: TextButton.styleFrom(
        padding: responsivePadding(horizontal: 16, vertical: 8),
      ),
      child: responsiveText(
        text,
        style: TextStyle(
          fontSize: baseFontSize ?? 16,
          color: textColor ?? primaryColor,
        ),
      ),
    );
  }
  Widget responsiveOutlinedButton({
    required VoidCallback onPressed,
    required String text,
    double? baseFontSize,
    Color? textColor,
    Color? borderColor,
    void Function(bool)? onHover,
    void Function(bool)? onFocusChange,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: OutlinedButton.styleFrom(
        padding: responsivePadding(horizontal: 16, vertical: 8),
        side: BorderSide(
          color: borderColor ?? primaryColor,
          width: isMobile ? 1 : 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: responsiveBorderRadius(8),
        ),
      ),
      child: responsiveText(
        text,
        style: TextStyle(
          fontSize: baseFontSize ?? 16,
          color: textColor ?? (isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
  int gridColumns() {
    if (isLargeDesktop) return 5;
    if (isDesktop) return 4;
    if (isTablet) return 3;
    if (isMediumMobile) return 2;
    return 1;
  }
  double responsiveGridSpacing() {
    if (isLargeDesktop) return 16;
    if (isDesktop) return 12;
    if (isTablet) return 8;
    return 4;
  }
  SliverGridDelegate responsiveGridDelegate({
    double childAspectRatio = 1.0,
    double? crossAxisSpacing,
    double? mainAxisSpacing,
  }) {
    final spacing = responsiveGridSpacing();
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: gridColumns(),
      childAspectRatio: responsiveAspectRatio(childAspectRatio),
      crossAxisSpacing: crossAxisSpacing ?? spacing,
      mainAxisSpacing: mainAxisSpacing ?? spacing,
    );
  }
  double get smallSpace => heightPercentage(isMobile ? 1 : 0.8);
  double get mediumSpace => heightPercentage(isMobile ? 2 : 1.5);
  double get largeSpace => heightPercentage(isMobile ? 4 : 3);
  Widget verticalSpace(double percentage) => SizedBox(height: heightPercentage(percentage));
  Widget horizontalSpace(double percentage) => SizedBox(width: widthPercentage(percentage));
  double responsiveAnimationDuration() {
    return isMobile ? 200 : 300;
  }
  double responsiveAnimationScale(double baseScale) {
    return baseScale * (isLargeDesktop ? 1.3 : isDesktop ? 1.2 : isTablet ? 1.1 : 1.0);
  }
}
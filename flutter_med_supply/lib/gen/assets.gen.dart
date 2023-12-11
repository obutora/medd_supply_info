/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsImageGen {
  const $AssetsImageGen();

  /// File path: assets/image/M-512.png
  AssetGenImage get m512 => const AssetGenImage('assets/image/M-512.png');

  /// File path: assets/image/M_1024.png
  AssetGenImage get m1024 => const AssetGenImage('assets/image/M_1024.png');

  /// File path: assets/image/company.svg
  SvgGenImage get company => const SvgGenImage('assets/image/company.svg');

  /// File path: assets/image/down.svg
  SvgGenImage get down => const SvgGenImage('assets/image/down.svg');

  /// File path: assets/image/face_bad.png
  AssetGenImage get faceBad => const AssetGenImage('assets/image/face_bad.png');

  /// File path: assets/image/face_down.png
  AssetGenImage get faceDown =>
      const AssetGenImage('assets/image/face_down.png');

  /// File path: assets/image/face_good.png
  AssetGenImage get faceGood =>
      const AssetGenImage('assets/image/face_good.png');

  /// File path: assets/image/face_normal.png
  AssetGenImage get faceNormal =>
      const AssetGenImage('assets/image/face_normal.png');

  /// File path: assets/image/note.png
  AssetGenImage get note => const AssetGenImage('assets/image/note.png');

  /// File path: assets/image/pie.svg
  SvgGenImage get pie => const SvgGenImage('assets/image/pie.svg');

  /// File path: assets/image/recept.svg
  SvgGenImage get recept => const SvgGenImage('assets/image/recept.svg');

  /// File path: assets/image/shield.svg
  SvgGenImage get shield => const SvgGenImage('assets/image/shield.svg');

  /// File path: assets/image/skelton.png
  AssetGenImage get skelton => const AssetGenImage('assets/image/skelton.png');

  /// File path: assets/image/up.svg
  SvgGenImage get up => const SvgGenImage('assets/image/up.svg');

  /// List of all assets
  List<dynamic> get values => [
        m512,
        m1024,
        company,
        down,
        faceBad,
        faceDown,
        faceGood,
        faceNormal,
        note,
        pie,
        recept,
        shield,
        skelton,
        up
      ];
}

class Assets {
  Assets._();

  static const $AssetsImageGen image = $AssetsImageGen();
  static const String med = 'assets/med.db';

  /// List of all assets
  List<String> get values => [med];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

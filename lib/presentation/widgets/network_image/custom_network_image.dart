// ignore_for_file: deprecated_member_use

import 'package:flutter/rendering.dart';
import 'package:youtube_clone/presentation/widgets/network_image/image_replacement.dart';
import '_custom_network_image_io.dart' as custom_network_image;
import '_retry.dart';

abstract class CustomNetworkImage extends ImageProvider<CustomNetworkImage> {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The [scale] argument is the linear scale factor for drawing this image at
  /// its intended size. See [ImageInfo.scale] for more information.
  const factory CustomNetworkImage(
    String url, {
    double scale,
    ImageReplacement? replacement,
    Map<String, String>? headers,
    Retry? retry,
  }) = custom_network_image.CustomNetworkImage;

  /// The URL from which the image will be fetched.
  String get url;

  /// The scale to place in the [ImageInfo] object of the image.
  double get scale;

  /// Uses image replacement when network failed
  ImageReplacement? get replacement;

  Retry? get retry;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  ///
  /// When running Flutter on the web, headers are not used.
  Map<String, String>? get headers;

  @override
  ImageStreamCompleter loadBuffer(
    CustomNetworkImage key,
    DecoderBufferCallback decode,
  );

  @override
  ImageStreamCompleter loadImage(
    CustomNetworkImage key,
    ImageDecoderCallback decode,
  );
}

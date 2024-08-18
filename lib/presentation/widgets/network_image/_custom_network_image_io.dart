// Copied from Flutter ImageProvider

// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '_retry.dart';
import 'custom_network_image.dart' as image_provider;
import 'image_replacement.dart';

// Method signature for _loadAsync decode callbacks.

/// The dart:io implementation of [image_provider.CustomNetworkImage].
@immutable
class CustomNetworkImage
    extends ImageProvider<image_provider.CustomNetworkImage>
    implements image_provider.CustomNetworkImage {
  /// Creates an object that fetches the image at the given URL.
  const CustomNetworkImage(
    this.url, {
    this.scale = 1.0,
    this.headers,
    this.replacement,
    this.retry,
  });

  @override
  final String url;

  @override
  final double scale;

  @override
  final Map<String, String>? headers;

  @override
  final ImageReplacement? replacement;

  @override
  final Retry? retry;

  @override
  Future<CustomNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CustomNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadBuffer(
    image_provider.CustomNetworkImage key,
    DecoderBufferCallback decode,
  ) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key as CustomNetworkImage, chunkEvents, decode: decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<image_provider.CustomNetworkImage>(
          'Image key',
          key,
        ),
      ],
    );
  }

  @override
  ImageStreamCompleter loadImage(
    image_provider.CustomNetworkImage key,
    ImageDecoderCallback decode,
  ) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    Future<Codec> fetchCodec() {
      if (retry != null) {
        return retry!.retry(
          () => _loadAsync(
            key as CustomNetworkImage,
            chunkEvents,
            decode: decode,
          ),
        );
      } else {
        return _loadAsync(
          key as CustomNetworkImage,
          chunkEvents,
          decode: decode,
        );
      }
    }

    return MultiFrameImageStreamCompleter(
      codec: fetchCodec(),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<image_provider.CustomNetworkImage>(
          'Image key',
          key,
        ),
      ],
    );
  }

  // Do not access this field directly; use [_httpClient] instead.
  // We set `autoUncompress` to false to ensure that we can trust the value of
  // the `Content-Length` HTTP header. We automatically uncompress the content
  // in our call to [consolidateHttpClientResponseBytes].
  static final HttpClient _sharedHttpClient = HttpClient()
    ..autoUncompress = false;

  static HttpClient get _httpClient {
    HttpClient? client;
    assert(() {
      if (debugNetworkImageHttpClientProvider != null) {
        client = debugNetworkImageHttpClientProvider!();
      }
      return true;
    }());
    return client ?? _sharedHttpClient;
  }

  Future<ui.Codec> _loadAsync(
    CustomNetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents, {
    required Future<ui.Codec> Function(ui.ImmutableBuffer) decode,
  }) async {
    Uint8List? bytes;
    try {
      assert(key == this);
      final Uri resolved = Uri.base.resolve(key.url);

      final HttpClientRequest request = await _httpClient.getUrl(resolved);

      headers?.forEach((String name, String value) {
        request.headers.add(name, value);
      });
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        // The network may be only temporarily unavailable, or the file will be
        // added on the server later. Avoid having future calls to resolve
        // fail to check the network again.
        await response.drain<List<int>>(<int>[]);
        // TODO(josh4500): Instead of throwing an exception, retry
        if (replacement != null) {
          bytes = await replacement?.create();
        } else {
          throw NetworkImageLoadException(
            statusCode: response.statusCode,
            uri: resolved,
          );
        }
      }

      bytes ??= await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (int cumulative, int? total) {
          chunkEvents.add(
            ImageChunkEvent(
              cumulativeBytesLoaded: cumulative,
              expectedTotalBytes: total,
            ),
          );
        },
      );
      if (bytes.lengthInBytes == 0) {
        throw Exception('CustomNetworkImage is an empty file: $resolved');
      }

      return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    } catch (e) {
      if (replacement != null) {
        bytes = await replacement?.create();
      }
      if (bytes == null) {
        // Depending on where the exception was thrown, the image cache may not
        // have had a chance to track the key in the cache at all.
        // Schedule a microtask to give the cache a chance to add the key.
        scheduleMicrotask(() {
          PaintingBinding.instance.imageCache.evict(key);
        });
        rethrow;
      } else {
        return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
      }
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CustomNetworkImage &&
        other.url == url &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'CustomNetworkImage')}("$url", scale: ${scale.toStringAsFixed(1)})';
}

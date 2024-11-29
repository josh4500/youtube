import 'package:photo_manager/photo_manager.dart';

enum MediaType {
  images,
  video,
  audio,
}

extension MediaTypeExtension on List<MediaType> {
  RequestType get toRequestType {
    return switch (this) {
      [MediaType.audio] => RequestType.audio,
      [MediaType.images] => RequestType.image,
      [MediaType.video] => RequestType.image,
      _ => RequestType.common,
    };
  }
}

class MediaAlbum extends AssetPathEntity {
  MediaAlbum({
    required this.count,
    required this.videoCount,
    required this.thumbAsset,
    required super.id,
    required super.name,
    super.albumType,
    super.lastModified,
    super.type,
    super.isAll,
    super.filterOption,
    super.darwinSubtype,
    super.darwinType,
    super.albumTypeEx,
  });

  final int count;
  final MediaFile thumbAsset;
  final int videoCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAlbum &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          count == other.count &&
          thumbAsset == other.thumbAsset;

  @override
  int get hashCode => name.hashCode ^ count.hashCode ^ thumbAsset.hashCode;
}

class MediaFile extends AssetEntity {
  const MediaFile({
    required super.id,
    required super.typeInt,
    required super.width,
    required super.height,
    super.duration,
    super.orientation,
    super.isFavorite,
    super.title,
    super.createDateSecond,
    super.modifiedDateSecond,
    super.relativePath,
    super.latitude,
    super.longitude,
    super.mimeType,
    super.subtype,
  });

  static MediaFile fromAssetEntity(AssetEntity entity) {
    return MediaFile(
      id: entity.id,
      typeInt: entity.typeInt,
      width: entity.width,
      height: entity.height,
      duration: entity.duration,
      orientation: entity.orientation,
      isFavorite: entity.isFavorite,
      title: entity.title,
      createDateSecond: entity.createDateSecond,
      modifiedDateSecond: entity.modifiedDateSecond,
      relativePath: entity.relativePath,
      latitude: entity.latitude,
      longitude: entity.longitude,
      mimeType: entity.mimeType,
      subtype: entity.subtype,
    );
  }
}

class MediaFileQueryResult {
  MediaFileQueryResult({required this.files, required this.hasMore});

  final List<MediaFile> files;
  final bool hasMore;
}

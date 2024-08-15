import 'package:photo_manager/photo_manager.dart';
import 'package:youtube_clone/infrastructure/services/media/media.dart';

class MediaDiscovery {
  factory MediaDiscovery() {
    return _instance;
  }
  MediaDiscovery._();

  static final MediaDiscovery _instance = MediaDiscovery._();
  static MediaDiscovery get instance => _instance;

  void initialize() {}

  static Future<List<MediaAlbum>> getAlbums(List<MediaType> types) async {
    final paths = await PhotoManager.getAssetPathList(
      type: types.toRequestType,
    );
    return <MediaAlbum>[
      for (final path in paths)
        MediaAlbum(
          id: path.id,
          name: path.name,
          type: path.type,
          albumType: path.albumType,
          albumTypeEx: path.albumTypeEx,
          // darwinSubtype: path.darwinSubtype,
          // darwinType: path.darwinType,
          filterOption: path.filterOption,
          isAll: path.isAll,
          lastModified: path.lastModified,
          count: await path.assetCountAsync,
          thumbAsset: MediaFile.fromAssetEntity(
            (await path.getAssetListRange(start: 0, end: 1)).first,
          ),
        ),
    ];
  }

  static Future<MediaFileQueryResult> getAlbumsFiles(
    MediaAlbum album, {
    int page = 0,
    int offset = 1000,
  }) async {
    final List<AssetEntity> entities = await album.getAssetListPaged(
      page: page,
      size: offset,
    );
    return Future.value(
      MediaFileQueryResult(
        files: entities.map(MediaFile.fromAssetEntity).toList(),
        hasMore: false,
      ),
    );
  }
}

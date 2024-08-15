import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'media_album_state.dart';

part 'media_files_state.g.dart';

@riverpod
class MediaFilesState extends _$MediaFilesState {
  @override
  Future<List<MediaFile>> build() async {
    return [];
  }

  Future<void> loadAlbumFiles(MediaAlbum album) async {
    // TODO(josh4500): Avoid reloading same album
    MediaDiscovery.getAlbumsFiles(album).then((MediaFileQueryResult result) {
      ref.read(mediaAlbumStateProvider.notifier).loadAlbum(album);
      state = AsyncData<List<MediaFile>>(result.files);
    });
  }
}

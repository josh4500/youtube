import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/screens/create/provider/media_files_state.dart';

part 'media_album_state.g.dart';

class MediaAlbumSelector {
  MediaAlbumSelector({required this.albums, required this.selected});

  final List<MediaAlbum> albums;
  final MediaAlbum? selected;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MediaAlbumSelector &&
          runtimeType == other.runtimeType &&
          albums == other.albums &&
          selected == other.selected;

  @override
  int get hashCode => albums.hashCode ^ selected.hashCode;
}

@riverpod
class MediaAlbumState extends _$MediaAlbumState {
  final cacheProvider = HiveCacheProvider<MediaAlbum>('media_album_state');

  @override
  Future<MediaAlbumSelector> build() async {
    state = const AsyncLoading<MediaAlbumSelector>();
    final selected = cacheProvider.read('selected');

    MediaDiscovery.getAlbums([MediaType.video, MediaType.images]).then(
      (List<MediaAlbum> albums) {
        if (albums.isNotEmpty) {
          state = AsyncData(
            MediaAlbumSelector(
              albums: albums,
              selected: selected ?? albums.first,
            ),
          );
          ref.read(mediaFilesStateProvider.notifier).loadAlbumFiles(
                selected ?? albums.first,
              );
          // for (final album in albums) {
          //   cacheProvider.write(album.id, album);
          // }
        }
      },
    );

    final albums = cacheProvider.values.toList();
    if (albums.isNotEmpty) {
      return MediaAlbumSelector(
        albums: albums,
        selected: selected ?? albums.first,
      );
    }

    return MediaAlbumSelector(albums: [], selected: null);
  }

  void loadAlbum(MediaAlbum album) {
    state = AsyncData(
      MediaAlbumSelector(
        albums: state.value!.albums,
        selected: album,
      ),
    );
  }
}

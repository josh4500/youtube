import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:youtube_clone/infrastructure.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../../provider/media_files_state.dart';
import '../album_selector.dart';
import '../create_close_button.dart';
import 'media_thumbnail.dart';

class MediaSelector extends StatefulWidget {
  const MediaSelector({
    super.key,
    this.videoOnly = true,
    this.multipleSelector = false,
  });
  final bool videoOnly;
  final bool multipleSelector;

  @override
  State<MediaSelector> createState() => _MediaSelectorState();
}

class _MediaSelectorState extends State<MediaSelector> {
  late final selectableNotifier = ValueNotifier<bool>(
    widget.multipleSelector,
  );

  final selectedNotifier = ValueNotifier<List<MediaFile>>(
    [],
  );

  @override
  void dispose() {
    selectedNotifier.dispose();
    selectableNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: AlbumSelectorButton(videoOnly: widget.videoOnly),
              ),
              SizedBox(width: 24.w),
              const CreateCloseButton(),
            ],
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: const OverScrollGlowBehavior(enabled: false),
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? _) {
                var files = ref.watch(mediaFilesStateProvider).value;
                if (files == null) return const SizedBox();

                // TODO(josh4500): Maybe put in isolate, maybe tens of thousands of files
                if (widget.videoOnly) {
                  files = files
                      .where((file) => file.type == AssetType.video)
                      .toList();
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: widget.multipleSelector ? 2 : 0,
                    crossAxisSpacing: widget.multipleSelector ? 2 : 0,
                    childAspectRatio: widget.multipleSelector ? 9 / 16 : 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final mediaFile = files![index];

                    return ListenableBuilder(
                      listenable: Listenable.merge(
                        [selectableNotifier, selectedNotifier],
                      ),
                      builder: (
                        BuildContext context,
                        Widget? _,
                      ) {
                        int? selectedIndex = selectedNotifier.value.indexWhere(
                          (file) => file.id == mediaFile.id,
                        );
                        if (selectedIndex >= 0) {
                          selectedIndex++;
                        } else {
                          selectedIndex = null;
                        }
                        return MediaThumbnail(
                          media: mediaFile,
                          index: selectedIndex,
                          onSelect: (MediaFile file) {
                            if (selectedIndex == null) {
                              selectedNotifier.value = [
                                ...selectedNotifier.value,
                                file,
                              ];
                            } else {
                              final selected = selectedNotifier.value;
                              selected.removeWhere(
                                (file) => file.id == mediaFile.id,
                              );
                              selectedNotifier.value = [...selected];
                            }
                          },
                          selectable: selectableNotifier.value,
                        );
                      },
                    );
                  },
                  itemCount: files.length,
                );
              },
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: selectedNotifier,
          builder: (
            BuildContext context,
            List<MediaFile> selected,
            Widget? _,
          ) {
            if (selected.isEmpty) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8.0,
              ),
              child: SizedBox(
                height: 34,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: AssetEntityImage(
                          selected[index],
                          width: 34,
                          height: 34,
                          fit: BoxFit.cover,
                          isOriginal: false,
                        ),
                      ),
                    );
                  },
                  itemCount: selected.length,
                ),
              ),
            );
          },
        ),
        if (widget.multipleSelector)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectableNotifier,
                      builder: (
                        BuildContext context,
                        bool selectable,
                        Widget? _,
                      ) {
                        return Checkbox(
                          value: selectable,
                          checkColor: Colors.black,
                          activeColor: Colors.white,
                          visualDensity: VisualDensity.compact,
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          onChanged: (bool? value) {
                            selectableNotifier.value = value ?? true;
                            if (!(value ?? true)) {
                              selectedNotifier.value = [];
                            }
                          },
                        );
                      },
                    ),
                    const Text(
                      'Select multiple',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ValueListenableBuilder(
                  valueListenable: selectedNotifier,
                  builder: (
                    BuildContext context,
                    List<MediaFile> selected,
                    Widget? _,
                  ) {
                    return AnimatedOpacity(
                      opacity: selected.isEmpty ? 0.5 : 1,
                      duration: Durations.short2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}

void showMediaSelector(BuildContext context, {bool videoOnly = true}) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.black,
    constraints: const BoxConstraints.expand(),
    sheetAnimationStyle: AnimationStyle(
      curve: Curves.easeInCubic,
      duration: const Duration(milliseconds: 300),
    ),
    builder: (BuildContext context) {
      return MediaSelector(
        videoOnly: videoOnly,
        multipleSelector: true,
      );
    },
  );
}

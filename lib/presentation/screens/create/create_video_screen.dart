import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import 'widgets/check_permission.dart';
import 'widgets/create_close_button.dart';
import 'widgets/create_permission_reason.dart';
import 'widgets/media/media_selector.dart';

Future<bool> _checkMediaStoragePerm() async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  return ps.isAuth;
}

class CreateVideoScreen extends StatefulWidget {
  const CreateVideoScreen({super.key});

  @override
  State<CreateVideoScreen> createState() => _CreateVideoScreenState();
}

class _CreateVideoScreenState extends State<CreateVideoScreen> {
  final completer = Completer<bool>();

  @override
  void initState() {
    super.initState();
    completer.complete(_checkMediaStoragePerm());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: FutureBuilder<bool>(
        initialData: false,
        future: completer.future,
        builder: (
          BuildContext context,
          AsyncSnapshot<bool> snapshot,
        ) {
          final bool hasPermissions = snapshot.data!;
          return ModelBinding<bool>(
            model: hasPermissions,
            child: Builder(
              builder: (BuildContext context) {
                if (hasPermissions) {
                  return const MediaSelector();
                }

                return MediaStoragePermissionRequest(
                  checking: snapshot.connectionState == ConnectionState.waiting,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MediaStoragePermissionRequest extends StatelessWidget {
  const MediaStoragePermissionRequest({
    super.key,
    this.checking = true,
  });

  final bool checking;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        image: checking
            ? null
            : const DecorationImage(
                image: CustomNetworkImage(
                  'https://images.pexels.com/photos/26221937/pexels-photo-26221937/free-photo-of-a-woman-taking-a-photo.jpeg?auto=compress&cs=tinysrgb&w=600',
                ),
                fit: BoxFit.cover,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CreateCloseButton(),
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (checking) {
                  return const CheckingPermission();
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(YTIcons.image_outlined, size: 48),
                              SizedBox(height: 48),
                              Text(
                                'Let YouTube access your photos and videos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              CreatePermissionReason(
                                icon: YTIcons.info_outlined,
                                title: 'Why is this needed?',
                                subtitle:
                                    'So you can import photos and videos from your gallery',
                              ),
                              SizedBox(height: 12),
                              CreatePermissionReason(
                                icon: YTIcons.settings_outlined,
                                title: 'How to enable permission?',
                                subtitle:
                                    'Open settings, go to permissions and allow access to photos and videos',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer(
                          builder: (context, ref, child) {
                            return GestureDetector(
                              onTap: () async {
                                final allowed = await _checkMediaStoragePerm();
                                if (context.mounted) {
                                  ModelBinding.update<bool>(
                                    context,
                                    (_) => allowed,
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

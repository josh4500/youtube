import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/models.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets.dart';

import '../check_permission.dart';
import '../create_close_button.dart';
import '../create_permission_reason.dart';

class CaptureShortsPermissionRequest extends StatelessWidget {
  const CaptureShortsPermissionRequest({
    super.key,
    this.checking = true,
  });

  final bool checking;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
                    return const SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(YTIcons.shorts_outline_outlined, size: 48),
                                SizedBox(height: 48),
                                Text(
                                  'To record, let YouTube access your camera and microphone',
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
                                      'So you can take photos, record videos, and preview effects',
                                ),
                                SizedBox(height: 12),
                                CreatePermissionReason(
                                  icon: YTIcons.settings_outlined,
                                  title: 'You are in control',
                                  subtitle:
                                      'Change your permissions any time in Settings',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          PermissionRequestButton(),
                          SizedBox(height: 12),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionRequestButton extends StatelessWidget {
  const PermissionRequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ModelBinding.of<CreateCameraState>(context);
    return GestureDetector(
      onTap: () async {
        if (state.permissionsDenied == false) {
          final state = await CreateCameraState.requestCamera();
          if (context.mounted) {
            ModelBinding.update<CreateCameraState>(context, (_) => state);
          }
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
        child: Text(
          state.permissionsDenied ? 'Open settings' : 'Continue',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

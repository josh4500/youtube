import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_clone/presentation/themes.dart';
import 'package:youtube_clone/presentation/widgets/sheet_drag_indicator.dart';

class FilterSelector extends StatelessWidget {
  const FilterSelector({super.key, this.isEditing = false});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEditing ? Colors.black : AppPalette.black,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEditing) ...[
              const SizedBox(height: 8),
              const SheetDragIndicator(),
            ],
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: isEditing ? 2 : 8,
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  if (isEditing)
                    GestureDetector(
                      onTap: context.pop,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(YTIcons.check_outlined),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: context.pop,
                      child: Text(
                        'DONE',
                        style: TextStyle(
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      const SizedBox(height: 4),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            YTIcons.not_interested_outlined,
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'No filter',
                        style: TextStyle(fontSize: 10.5),
                      ),
                    ],
                  );
                },
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

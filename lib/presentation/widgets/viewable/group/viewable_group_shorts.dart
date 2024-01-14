// MIT License
//
// Copyright (c) 2024 Ajibola Akinmosin (https://github.com/josh4500)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets/viewable/group/viewable_group_layout.dart';

import '../viewable_shorts_content.dart';

class ViewableGroupShorts extends StatelessWidget {
  final ViewableGroupLayout layout;
  // TODO: Add how the different layouts should be built
  const ViewableGroupShorts({
    super.key,
    this.layout = ViewableGroupLayout.list,
  });

  @override
  Widget build(BuildContext context) {
    if (layout == ViewableGroupLayout.grid) {}

    return Column(
      children: [
        const Divider(thickness: 1.5, height: 0),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.adb_sharp,
                size: 36,
                color: Colors.red,
              ),
              SizedBox(width: 16),
              Text(
                'Shorts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 286,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return ViewableShortsContent(
                width: 180,
                margin: const EdgeInsets.all(4),
                borderRadius: BorderRadius.circular(8),
              );
            },
            itemCount: 10,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

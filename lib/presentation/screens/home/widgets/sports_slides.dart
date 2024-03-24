import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_clone/presentation/widgets.dart';

class SportSlides extends StatefulWidget {
  const SportSlides({super.key});

  @override
  State<SportSlides> createState() => _SportSlidesState();
}

class _SportSlidesState extends State<SportSlides> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  bool _enablePreviewMode = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Simulate previewing slides
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_enablePreviewMode) {
        _onPagePreviewEnd();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Callback to go to the next page when done previewing current page
  Future<void> _onPagePreviewEnd() async {
    if (_currentPage != 4) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInCubic,
      );
    } else {
      await _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        SizedBox(
          height: 415,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollStartNotification) {
                // TODO(Josh): Detect this was caused by the user
                // _enablePreviewMode = false;
              }
              return true;
            },
            child: ScrollConfiguration(
              behavior: const OverScrollGlowBehavior(enabled: false),
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage('https://picsum.photos/500/500'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF656565),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.black45,
                              Colors.black26,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black,
                            ],
                            stops: [0.003, 0.08, 0.15, 0.2, 0.3, 0.55, 1.0],
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              Text(
                                'One Sports . 877k views . 13 hours ago',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Bangladesh vs Sri Lanka Highlights | 1st Test | Day 2 Something',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(width: 50),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: 5,
                onPageChanged: (int index) => _currentPage = index,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListenableBuilder(
            listenable: _pageController,
            builder: (BuildContext context, Widget? child) {
              return SlidesIndicator(
                pageCount: 5,
                currentPage: _currentPage,
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reader_bloc.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen(
      {required this.comicId, required this.chapterId, super.key});

  final String comicId;
  final String chapterId;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context
        .read<ReaderBloc>()
        .add(ReaderOpened(widget.comicId, widget.chapterId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReaderBloc, ReaderState>(
      builder: (context, state) {
        final background = state.nightMode
            ? Colors.black
            : Theme.of(context).scaffoldBackgroundColor;
        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: Text(state.chapter?.title ?? 'Reader'),
            actions: [
              IconButton(
                  onPressed: () => context
                      .read<ReaderBloc>()
                      .add(ReaderModeChanged(!state.isVertical)),
                  icon: Icon(state.isVertical
                      ? Icons.swap_horiz_rounded
                      : Icons.swap_vert_rounded)),
              IconButton(
                  onPressed: () =>
                      context.read<ReaderBloc>().add(ReaderNightModeToggled()),
                  icon: Icon(state.nightMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined)),
            ],
          ),
          body: state.chapter == null
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: [
                    LinearProgressIndicator(
                        value: (state.currentPage + 1) /
                            state.chapter!.pages.length),
                    Expanded(
                      child: state.isVertical
                          ? ListView.builder(
                              itemCount: state.chapter!.pages.length,
                              itemBuilder: (context, index) => _ZoomablePage(
                                  url: state.chapter!.pages[index],
                                  onVisible: () => context
                                      .read<ReaderBloc>()
                                      .add(ReaderPageChanged(index))),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: state.chapter!.pages.length,
                              onPageChanged: (page) => context
                                  .read<ReaderBloc>()
                                  .add(ReaderPageChanged(page)),
                              itemBuilder: (context, index) => _ZoomablePage(
                                  url: state.chapter!.pages[index]),
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ZoomablePage extends StatelessWidget {
  const _ZoomablePage({required this.url, this.onVisible});

  final String url;
  final VoidCallback? onVisible;

  @override
  Widget build(BuildContext context) {
    onVisible?.call();
    return GestureDetector(
      onDoubleTap: () {},
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: CachedNetworkImage(
          imageUrl: url,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          placeholder: (_, __) => const AspectRatio(
              aspectRatio: .7,
              child: Center(child: CircularProgressIndicator.adaptive())),
          errorWidget: (_, __, ___) => const AspectRatio(
              aspectRatio: .7, child: Icon(Icons.broken_image_outlined)),
        ),
      ),
    );
  }
}

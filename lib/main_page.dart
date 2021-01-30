import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main_controller.dart';
import 'painter.dart';

final mainProvider = ChangeNotifierProvider.autoDispose<MainController>(
  (ref) => MainController(),
);

class MainPage extends ConsumerWidget {
  const MainPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _provider = watch(mainProvider);
    return Scaffold(
      backgroundColor: Colors.lightBlue[900],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_provider.isPlaying) {
            _provider.isPlaying = false;
            _provider.editable = true;
          } else {
            _provider.isPlaying = true;
            _provider.editable = false;
            _provider.mainLoop();
          }
        },
        child: _provider.isPlaying
            ? Icon(Icons.stop_rounded)
            : Icon(Icons.play_arrow_rounded),
      ),
      body: Stack(
        children: [
          CustomPaint(
            painter: Painter(
              basicLength: _provider.baseLength,
              height: _provider.height,
              width: _provider.width,
              cells: _provider.cellList,
            ),
          ),
          GestureDetector(
            dragStartBehavior: DragStartBehavior.down,
            onTapDown: (details) {
              if (_provider.editable) {
                _provider.ivertCells(
                  _provider.positionToIndex(details.localPosition),
                );
              }
            },
            onPanUpdate: (detail) {
              _provider.generateCells(
                _provider.positionToIndex(detail.localPosition),
              );
            },
          )
        ],
      ),
    );
  }
}

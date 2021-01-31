import 'dart:ui';

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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Generations: ${_provider.generations}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 80,
                child: Slider(
                  value: _provider.waitTimeMS.toDouble(),
                  onChanged: (newWaitTimeMS) {
                    _provider.waitTimeMS = newWaitTimeMS.toInt();
                  },
                  min: 10,
                  max: 1500,
                ),
              ),
              FloatingActionButton(
                backgroundColor:
                    _provider.isPlaying ? Colors.grey : Colors.blue,
                onPressed: () {
                  if (!_provider.isPlaying) {
                    _provider.clearCells();
                  }
                },
                child: const Icon(Icons.cleaning_services_rounded),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                backgroundColor:
                    _provider.isPlaying ? Colors.red : Colors.green,
                onPressed: () async {
                  if (_provider.isPlaying) {
                    _provider
                      ..start = false
                      ..editable = true;
                  } else {
                    _provider
                      ..start = true
                      ..editable = false
                      ..mainLoop();
                  }
                },
                child: _provider.isPlaying
                    ? const Icon(Icons.stop_rounded)
                    : const Icon(Icons.play_arrow_rounded),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _provider.width * _provider.baseLength,
            height: _provider.height * _provider.baseLength,
            child: Stack(
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
                      _provider
                        ..setCellListWhenTapDown()
                        ..ivertCells(
                          _provider.positionToIndex(details.localPosition),
                        );
                    }
                  },
                  onPanUpdate: (details) {
                    if (_provider.editable) {
                      _provider.ivertCells(
                        _provider.positionToIndex(details.localPosition),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      body: Stack(
        children: [
          CustomPaint(
            painter: Painter(
              basicLength: _provider.baseLength,
              height: _provider.height,
              width: _provider.width,
              cells: _provider.cells,
            ),
          ),
          GestureDetector(
            onTapDown: (details) {
              _provider.ivertCells(
                _provider.positionToIndex(details.localPosition),
              );
            },
          )
        ],
      ),
    );
    // body: Column(
    //   children: [
    //     for (var y = 0; y < _height; y++)
    //       Row(
    //         children: [
    //           for (var x = 0; x < _width; x++)
    //             InkWell(
    //               onTap: () {
    //                 _provider.ivertCells(y * _width + x);
    //               },
    //               child: Container(
    //                 height: 10,
    //                 width: 10,
    //                 color: _provider.cells[y * _width + x]
    //                     ? Colors.yellow
    //                     : Colors.white,
    //               ),
    //             )
    //         ],
    //       ),
    //   ],
    // ),
    //   body: GridView.builder(
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         childAspectRatio: 1 / 1, crossAxisCount: _provider.width),
    //     itemCount: _provider.width * _provider.height,
    //     itemBuilder: (context, index) {
    //       return InkWell(
    //         onTap: () {
    //           if (_provider.editable) {
    //             _provider.ivertCells(index);
    //           }
    //         },
    //         child: Container(
    //           width: 5,
    //           height: 5,
    //           decoration: BoxDecoration(
    //             border: Border.all(
    //               color: Colors.black,
    //               width: 0.2,
    //             ),
    //             color:
    //                 _provider.cells[index] ? Colors.yellow : Colors.transparent,
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}

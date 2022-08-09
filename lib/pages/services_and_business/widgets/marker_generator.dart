import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

/// This just adds overlay and builds [_MarkerHelper] on that overlay.
/// [_MarkerHelper] does all the heavy work of creating and getting bitmaps
class MarkerGenerator {
  MarkerGenerator(this.markerWidgets, this.callback);

  final Function(List<Uint8List>) callback;
  final List<Widget> markerWidgets;

  void generate(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context) {
    addOverlay(context);
  }

  void addOverlay(BuildContext context) {
    final OverlayState? overlayState = Overlay.of(context);

    final OverlayEntry entry = OverlayEntry(
        builder: (context) {
          return _MarkerHelper(
            markerWidgets: markerWidgets,
            callback: callback,
          );
        },
        maintainState: true);

    overlayState!.insert(entry);
  }
}

class _MarkerHelper extends StatefulWidget {
  const _MarkerHelper({Key? key, required this.markerWidgets, required this.callback}) : super(key: key);

  final List<Widget> markerWidgets;
  final Function(List<Uint8List>) callback;

  @override
  _MarkerHelperState createState() => _MarkerHelperState();
}

class _MarkerHelperState extends State<_MarkerHelper> with AfterLayoutMixin {
  List<GlobalKey> globalKeys = <GlobalKey>[];

  @override
  void afterFirstLayout(BuildContext context) {
    _getBitmaps(context).then((list) {
      widget.callback(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width, 0),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: widget.markerWidgets.map((i) {
            final markerKey = GlobalKey();
            globalKeys.add(markerKey);
            return RepaintBoundary(
              key: markerKey,
              child: i,
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<List<Uint8List>> _getBitmaps(BuildContext context) async {
    final futures = globalKeys.map((key) => _getUint8List(key));
    return Future.wait(futures);
  }

  Future<Uint8List> _getUint8List(GlobalKey markerKey) async {
    final RenderRepaintBoundary boundary = markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 4.0);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

/// AfterLayoutMixin
mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context);
}

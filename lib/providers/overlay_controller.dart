import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'overlay_controller.g.dart';

@Riverpod(keepAlive: true)
class OverlayController extends _$OverlayController {
  @override
  bool build() => false;

  void switchOverlayMode() {
    state = !state;
  }
}

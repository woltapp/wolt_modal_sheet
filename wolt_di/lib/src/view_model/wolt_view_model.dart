import 'package:flutter/widgets.dart';

abstract class WoltViewModel {
  /// Discards any resources used by the view model classes. This method should called in the
  /// dispose method of the [StatefulWidget]. After this is called, the object is not in a usable
  /// state.
  void dispose();
}

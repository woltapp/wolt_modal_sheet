const defaultModalTypeBreakPoint = 768.0;

abstract class WoltModalSheetDelegate {
  WoltModalType getWoltModalSheetType(double deviceWidth);
}

/// Default implementation of the [WoltModalSheetDelegate].
/// This class determines the type of ModalSheet to be used based on the device
/// size.
class DefaultWoltModalSheetDelegate  implements WoltModalSheetDelegate{
  const DefaultWoltModalSheetDelegate();

  @override
  WoltModalType getWoltModalSheetType(double deviceWidth) {
    if (deviceWidth < defaultModalTypeBreakPoint) {
      return WoltModalType.bottomSheet;
    } else {
      return WoltModalType.dialog;
    }
  }
}

/// Enum representing the type of the modal.
enum WoltModalType {
  bottomSheet,
  dialog;
}

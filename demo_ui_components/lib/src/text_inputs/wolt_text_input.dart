import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FocusListener = void Function(bool hasFocus);

class WoltTextInput extends StatefulWidget {
  const WoltTextInput({
    this.labelText,
    this.obscureText = false,
    this.autocorrect = true,
    this.containsError = false,
    this.textInputAction,
    this.controller,
    this.textInputType,
    this.focusListener,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.suffix,
    this.focusNode,
    this.scrollPadding,
    this.maxLines = 1,
    this.onEditingComplete,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.inputFormatters,
    this.autofillHints,
    super.key,
  })  : assert(
          (obscureText && !autocorrect) || !obscureText,
          'If obscureText defined, ensure autocorrect is disabled',
        ),
        assert(
          (obscureText && !(maxLines == null || maxLines > 1)) || !obscureText,
          'If obscureText defined, max lines must be 1',
        );

  final bool autocorrect;
  final FocusListener? focusListener;
  final String? labelText;
  final bool containsError;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final FocusNode? focusNode;
  final EdgeInsets? scrollPadding;
  final int? maxLines;
  final FloatingLabelBehavior floatingLabelBehavior;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  static const double woltTextInputHeight = 56;

  @override
  State<StatefulWidget> createState() => _WoltTextInputState();
}

class _WoltTextInputState extends State<WoltTextInput> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  IconButton? clearButton;

  bool get _hasFocus => _focusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() {
        final focusListener = widget.focusListener;
        if (focusListener != null) {
          focusListener(_focusNode.hasFocus);
        }
        if (_focusNode.hasFocus) {
          clearButton = IconButton(
            onPressed: () => _controller.clear(),
            icon: const Icon(Icons.cancel_outlined, color: WoltColors.black48),
          );
        } else {
          clearButton = null;
        }
      });
    });
  }

  Color get borderColor {
    if (widget.containsError) {
      return WoltColors.red;
    } else if (_hasFocus) {
      return WoltColors.blue;
    } else {
      return WoltColors.black16;
    }
  }

  Color get labelTextColor {
    if (widget.containsError) {
      return WoltColors.red64;
    } else if (_hasFocus) {
      return WoltColors.blue;
    } else {
      return WoltColors.black64;
    }
  }

  Color get textColor {
    if (widget.containsError) {
      return WoltColors.red64;
    } else if (_hasFocus) {
      return WoltColors.blue;
    } else {
      return WoltColors.black64;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxLines = widget.maxLines;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: WoltTextInput.woltTextInputHeight,
          maxHeight:
              maxLines == null ? double.infinity : maxLines * WoltTextInput.woltTextInputHeight,
        ),
        child: TextFormField(
          autofocus: widget.focusNode == null,
          textAlignVertical: TextAlignVertical.center,
          focusNode: _focusNode,
          controller: _controller,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          onFieldSubmitted: widget.onSubmitted,
          cursorColor: widget.containsError ? WoltColors.red : WoltColors.blue,
          validator: widget.validator,
          onChanged: widget.onChanged,
          scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20),
          style: Theme.of(context).textTheme.bodyMedium,
          minLines: 1,
          onEditingComplete: widget.onEditingComplete,
          maxLines: widget.obscureText ? 1 : maxLines,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          decoration: InputDecoration(
            labelText: widget.labelText,
            floatingLabelBehavior: widget.floatingLabelBehavior,
            suffixIcon: !_hasFocus ? widget.suffix : clearButton,
            contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
            labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: labelTextColor),
            border: const UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}

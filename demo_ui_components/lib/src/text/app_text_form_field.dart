import 'package:demo_ui_components/demo_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FocusListener = ValueChanged<bool>;

class AppTextFormField extends StatefulWidget {
  final bool autocorrect;
  final FocusListener? onFocusChanged;
  final String labelText;
  final bool invalid;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final bool enabled;
  final FormFieldValidator<String>? onValidate;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final EdgeInsets? scrollPadding;
  final int? maxLines;
  final FloatingLabelBehavior floatingLabelBehavior;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autoValidateMode;
  final bool enableSuggestions;

  const AppTextFormField({
    required this.labelText,
    this.obscureText = false,
    this.autocorrect = true,
    this.invalid = false,
    this.textInputAction,
    this.controller,
    this.enabled = true,
    this.textInputType,
    this.onFocusChanged,
    this.onValidate,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.scrollPadding,
    this.maxLines = 1,
    this.onEditingComplete,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.inputFormatters,
    this.autofillHints,
    this.autoValidateMode,
    this.enableSuggestions = true,
    super.key,
  })  : assert(
          (obscureText && !autocorrect) || !obscureText,
          'If obscureText defined, ensure autocorrect is disabled',
        ),
        assert(
          (obscureText && !(maxLines == null || maxLines > 1)) || !obscureText,
          'If obscureText defined, max lines must be 1',
        );

  @override
  State<StatefulWidget> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _isTextEmpty = true;

  bool get _hasFocus => _focusNode.hasFocus;
  String errorText = '';

  bool get _invalid => widget.invalid || errorText.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocus);

    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocus);

    if (widget.focusNode == null) {
      _focusNode.dispose();
    }

    _controller.removeListener(_onTextChanged);

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextEmpty = _controller.text.isEmpty;
    });
  }

  void _onFocus() {
    setState(() {
      final focusListener = widget.onFocusChanged;
      if (focusListener != null) {
        focusListener(_hasFocus);
      }
    });
  }

  // we don't want to return use the built in error message but the function must have this type
  // ignore: function-always-returns-null
  String? _validator(String? value) {
    String? result = widget.onValidate?.call(value);
    setState(() {
      errorText = result ?? '';
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final maxLines = widget.maxLines;
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: widget.enabled ? null : WoltColors.black48,
            border: Border.all(
              color: _containerBorderColor(
                hasFocus: _focusNode.hasFocus,
                invalid: _invalid,
              ),
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _textFieldHeight,
              maxHeight: maxLines == null
                  ? double.infinity
                  : maxLines * _textFieldHeight,
            ),
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: _labelStyle(
                  context: context,
                  enabled: widget.enabled,
                  invalid: _invalid,
                  hasFocus: _hasFocus,
                ),
                floatingLabelBehavior: widget.floatingLabelBehavior,
                contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                suffixIcon: _suffixIcon(
                  hasFocus: _hasFocus,
                  enabled: !_isTextEmpty,
                  controller: _controller,
                ),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              enabled: widget.enabled,
              keyboardType: widget.textInputType,
              textInputAction: widget.textInputAction,
              style: widget.enabled
                  ? textStyle
                  : textStyle.copyWith(color: WoltColors.black48),
              textAlignVertical: TextAlignVertical.center,
              obscureText: widget.obscureText,
              autocorrect: widget.autocorrect,
              maxLines: widget.obscureText ? 1 : maxLines,
              minLines: 1,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              onFieldSubmitted: widget.onSubmitted,
              validator: _validator,
              inputFormatters: widget.inputFormatters,
              cursorColor: _cursorColor(_invalid),
              scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20),
              autofillHints: widget.autofillHints,
              autovalidateMode: widget.autoValidateMode,
              enableSuggestions: widget.enableSuggestions,
            ),
          ),
        ),
        if (errorText.isNotEmpty) ...[
          const SizedBox(height: 12),
          _FormFieldError(errorText)
        ],
      ],
    );
  }
}

const _textFieldHeight = 56.0;

TextStyle _labelStyleNoError(BuildContext context, bool hasFocus) {
  final style = Theme.of(context).textTheme.bodyMedium!;
  if (hasFocus) {
    return style.copyWith(color: WoltColors.blue);
  }
  return style;
}

TextStyle _errorLabelStyle(BuildContext context) {
  return Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(color: WoltColors.red);
}

TextStyle _labelStyle({
  required BuildContext context,
  required bool enabled,
  required bool invalid,
  required bool hasFocus,
}) {
  if (!enabled) {
    return Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: WoltColors.black48);
  }

  if (invalid) {
    return _errorLabelStyle(context);
  }
  return _labelStyleNoError(context, hasFocus);
}

Color _cursorColor(bool invalid) {
  return invalid ? WoltColors.red : WoltColors.blue;
}

Color _containerBorderColor({
  required bool hasFocus,
  required bool invalid,
}) {
  if (invalid) {
    return WoltColors.red64;
  }

  return hasFocus ? WoltColors.blue : WoltColors.black16;
}

IconButton? _suffixIcon({
  required bool hasFocus,
  required bool enabled,
  required TextEditingController controller,
}) {
  if (!hasFocus) {
    return null;
  }

  return (enabled)
      ? IconButton(
          onPressed: () => controller.clear(),
          icon: const Icon(Icons.cancel),
        )
      : const IconButton(
          onPressed: null,
          icon: Icon(Icons.cancel_outlined, color: WoltColors.black48),
        );
}

class _FormFieldError extends StatelessWidget {
  final String child;

  const _FormFieldError(this.child);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.cancel, color: WoltColors.red, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(child, style: Theme.of(context).textTheme.labelSmall),
        ),
      ],
    );
  }
}

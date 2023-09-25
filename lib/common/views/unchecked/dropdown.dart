import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef GetTitle<T> = String Function(T);

class DropDownItemType<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> options;
  final Function(T?) onChanged;
  final GetTitle<T>? getItemTitle;

  const DropDownItemType({
    Key? key,
    required this.options,
    required this.onChanged,
    this.value,
    required this.hint,
    this.getItemTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropDownType<T>(
      initialOption: value,
      options: options,
      onChanged: onChanged,
      mapTitleKey: getItemTitle,
      height: 52,
      textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                // color: Theme.of(context).colorScheme.primary,
              ) ??
          const TextStyle(),
      hint: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: hint,
              style: DefaultTextStyle.of(context).style.copyWith(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
      // fillColor: Theme.of(context).colorScheme.background,
      elevation: 2,
      borderColor: Colors.black,
      borderWidth: 1,
      borderRadius: 8,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 4, 0, 4),
      hidesUnderline: true,
    );
  }
}

class DropDownType<T> extends StatefulWidget {
  const DropDownType({
    Key? key,
    this.initialOption,
    this.hint,
    required this.options,
    required this.onChanged,
    this.icon,
    this.width,
    this.height,
    this.fillColor,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    required this.margin,
    this.hidesUnderline = false,
    this.mapTitleKey,
  }) : super(key: key);

  final T? initialOption;
  final Widget? hint;
  final List<T> options;
  final Function(T?) onChanged;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color? fillColor;
  final TextStyle textStyle;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry margin;
  final bool hidesUnderline;
  final GetTitle<T>? mapTitleKey;

  @override
  State<DropDownType<T>> createState() => _DropDownTypeState<T>();
}

class _DropDownTypeState<T> extends State<DropDownType<T>> {
  T? dropDownValue;

  @override
  void initState() {
    super.initState();
    dropDownValue = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    final dropdownWidget = DropdownButton<T>(
      value: dropDownValue,
      hint: widget.hint,
      borderRadius: BorderRadius.circular(8),
      items: widget.options
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  widget.mapTitleKey != null ? widget.mapTitleKey!(e) : e.toString(),
                  style: widget.textStyle,
                ),
              ))
          .toList(),
      elevation: widget.elevation.toInt(),
      onChanged: (value) {
        FocusScope.of(context).unfocus();
        dropDownValue = value;
        widget.onChanged(value);
      },
      icon: widget.icon,
      isExpanded: true,
      dropdownColor: widget.fillColor,
      focusColor: Colors.transparent,
    );
    final childWidget = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        color: widget.fillColor,
      ),
      child: Padding(
        padding: widget.margin,
        child: widget.hidesUnderline ? DropdownButtonHideUnderline(child: dropdownWidget) : dropdownWidget,
      ),
    );
    if (widget.height != null || widget.width != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: childWidget,
      );
    }
    return childWidget;
  }
}

class DropDownItem extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> options;
  final Function(String?) onChanged;

  const DropDownItem({
    Key? key,
    required this.options,
    required this.onChanged,
    this.value,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropDown(
      initialOption: value,
      options: options,
      onChanged: onChanged,
      height: 52,
      textStyle: GoogleFonts.getFont(
        "Poppins",
        fontSize: 16,
        fontWeight: FontWeight.w500,
        // color: Theme.of(context).colorScheme.primary,
      ),
      hint: Text.rich(TextSpan(children: <InlineSpan>[
        TextSpan(
          text: hint,
          style: GoogleFonts.getFont(
            "Poppins",
            color: Colors.grey.shade400,
            fontSize: 16,
            // fontWeight: FontWeight.w500,
          ),
        )
      ])),
      // fillColor: Theme.of(context).colorScheme.background,
      elevation: 2,
      borderColor: Colors.black,
      borderWidth: 1,
      borderRadius: 8,
      margin: const EdgeInsetsDirectional.fromSTEB(8, 4, 0, 4),
      hidesUnderline: true,
    );
  }
}

class DropDown extends StatefulWidget {
  const DropDown({
    Key? key,
    this.initialOption,
    this.hint,
    required this.options,
    required this.onChanged,
    this.icon,
    this.width,
    this.height,
    this.fillColor,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    required this.margin,
    this.hidesUnderline = false,
  }) : super(key: key);

  final String? initialOption;
  final Widget? hint;
  final List<String> options;
  final Function(String?) onChanged;
  final Widget? icon;
  final double? width;
  final double? height;
  final Color? fillColor;
  final TextStyle textStyle;
  final double elevation;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsetsGeometry margin;
  final bool hidesUnderline;

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String? dropDownValue;

  List<String> get effectiveOptions => widget.options.isEmpty ? ['[Option]'] : widget.options;

  @override
  void initState() {
    super.initState();
    dropDownValue = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    final dropdownWidget = DropdownButton<String>(
      value: effectiveOptions.contains(dropDownValue) ? dropDownValue : null,
      hint: widget.hint,
      borderRadius: BorderRadius.circular(8),
      items: effectiveOptions
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: widget.textStyle),
              ))
          .toList(),
      elevation: widget.elevation.toInt(),
      onChanged: (value) {
        FocusScope.of(context).unfocus();
        dropDownValue = value;
        widget.onChanged(value);
      },
      icon: widget.icon,
      isExpanded: true,
      dropdownColor: widget.fillColor,
      focusColor: Colors.transparent,
    );
    final childWidget = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
        color: widget.fillColor,
      ),
      child: Padding(
        padding: widget.margin,
        child: widget.hidesUnderline ? DropdownButtonHideUnderline(child: dropdownWidget) : dropdownWidget,
      ),
    );
    if (widget.height != null || widget.width != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: childWidget,
      );
    }
    return childWidget;
  }
}

import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// https://stackoverflow.com/a/60094773/9444743
class MaskedTextInputController extends TextEditingController {
  final Map<String, RegExp> translator = MaskedTextInputController.getDefaultTranslator();
  String mask;

  bool _skipEvent = false;

  MaskedTextInputController({String text = "", this.mask = '(000) 000-0000'}) : super(text: text) {
    addListener(() {
      if (Platform.isIOS) {
        /*
        in ios, sometimes this event is being called multiple times for same text,
        this is a hot-fix for that.
        Issue #51 on github repo.
        Issue: While pressing 'back' button on soft keyboard, cursor jumps on wrong positions.
         */

        if (_lastUpdatedText == this.text) {
          // event triggered when text input is focused for the first time
          return;
        }

        if (_skipEvent) {
          // event triggered because extra mask characters were added
          // see line::152 in _applyMask method.
          _skipEvent = false;
          return;
        }
      }

      var previous = _lastUpdatedText;
      if (beforeChange(previous, this.text)) {
        updateText(this.text);
        afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    String newText = "";
    if (text != "") {
      newText = _applyMask(mask, text);
    }

    int currentOffset = selection.base.offset;
    if (currentOffset == 4 && newText.length == 5) {
      currentOffset++;
    }

    if (currentOffset == 8 && newText.length == 9) {
      currentOffset++;
    }

    if (currentOffset > newText.length) {
      currentOffset = newText.length;
    }

    bool isTextSelected = (value.selection.end - value.selection.start) > 1;

    value = TextEditingValue(
      text: newText,
      selection: isTextSelected
          ? value.selection
          : TextSelection.fromPosition(
              TextPosition(offset: currentOffset),
            ),
    );

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    var text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: (text).length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {'A': RegExp(r'[A-Za-z]'), '0': RegExp(r'[0-9]'), '@': RegExp(r'[A-Za-z0-9]'), '*': RegExp(r'.*')};
  }

  String _applyMask(String mask, String value) {
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]?.hasMatch(valueChar) ?? false) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      _skipEvent = true;
      continue;
    }

    return result;
  }
}

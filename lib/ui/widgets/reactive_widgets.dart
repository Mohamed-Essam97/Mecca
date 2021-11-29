import 'package:Mecca/core/services/preference/preference.dart';
import 'package:Mecca/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../core/services/localization/localization.dart';

enum ReactiveFields {
  TEXT,
  HUGE_TEXT,
  DROP_DOWN,
  PASSWORD,
  DATE_PICKER,
  DATE_PICKER_FIELD,
  CHECKBOX_LISTTILE,
  RADIO_LISTTILE
}

class ReactiveField extends StatelessWidget {
  @required
  final ReactiveFields type;
  @required
  final String controllerName;
  final int maxLines;
  final double width;
  final Map<String, String> validationMesseges;
  final TextInputType keyboardType;
  final InputDecoration decoration;
  final String hint, radioTitle, radioVal;
  final Color borderColor, hintColor, textColor, fillColor, enabledBorderColor;
  final bool secure, autoFocus, readOnly, filled;
  final List<dynamic> items;
  final BuildContext context;
  final String label;
  final InkWell inkWell;
  final Icon prefixicon;
  final Function onChange;
  final Icon suffixicon;
  final String label_text_date;
  const ReactiveField(
      {this.type,
      this.controllerName,
      this.validationMesseges,
      this.hint,
      this.width = double.infinity,
      this.keyboardType = TextInputType.emailAddress,
      this.secure = false,
      this.autoFocus = false,
      this.readOnly = false,
      this.label,
      this.onChange,
      this.radioTitle = '',
      this.borderColor = Colors.grey,
      this.hintColor = Colors.black,
      this.textColor = Colors.black,
      this.fillColor = Colors.transparent,
      this.enabledBorderColor = Colors.white,
      this.maxLines = 1,
      this.filled = false,
      this.radioVal = '',
      this.items,
      this.context,
      this.inkWell,
      this.prefixicon,
      this.suffixicon,
      this.label_text_date,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    bool isDark = Preference.getBool(PrefKeys.isDark);
    return Container(
      width: width,
      child: buildReactiveField(locale, isDark),
    );
  }

  buildReactiveField(locale, bool isDark) {
    var validationM = validationMesseges ??
        {
          'required': locale.get("Required") ?? "Required",
          'pattern': locale.get("Enter Valid E-mail or Phone") ??
              "Enter Valid E-mail or Phone",
          'minLength': locale.get("Password must exceed 8 characters") ??
              "Password must exceed 8 characters",
          'mustMatch': locale.get("Passwords doesn't match") ??
              "Passwords doesn't match",
          'email': locale.get("Please enter valid email") ??
              "Please enter valid email"
        };

    switch (type) {
      case ReactiveFields.HUGE_TEXT:
        return ReactiveTextField(
          minLines: 9,
          formControlName: controllerName,
          validationMessages: (controller) => validationM,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          maxLines: 15,
          decoration: decoration != null
              ? decoration
              : InputDecoration(
                  prefixIcon: prefixicon,
                  // suffixIcon: suffixicon,
                  labelStyle: TextStyle(color: AppColors.getDarkLightColor()),
                  filled: true,
                  fillColor: isDark ? Color(0xff141D26) : fillColor,
                  focusedBorder: !isDark
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: borderColor,
                          ),
                        )
                      : null,

                  enabledBorder: !isDark
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: enabledBorderColor,
                            width: 1.0,
                          ),
                        )
                      : null,
                  labelText: label,
                  hintText: hint,

                  // fillColor: Colors.grey,

                  // labelStyle: TextStyle(color: textColor),
                  // hintStyle: TextStyle(color: hintColor),

                  // fillColor: Colors.white,
                ),
          autofocus: autoFocus,
          readOnly: readOnly,
          obscureText: secure,
        );
        break;
      case ReactiveFields.TEXT:
        return ReactiveTextField(
          formControlName: controllerName,
          validationMessages: (controller) => validationM,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          maxLines: maxLines,
          decoration: decoration != null
              ? decoration
              : InputDecoration(
                  disabledBorder: InputBorder.none,

                  prefixIcon: prefixicon,
                  suffixIcon: suffixicon,
                  labelStyle: TextStyle(color: AppColors.getDarkLightColor()),
                  filled: true,
                  fillColor: isDark ? Color(0xff141D26) : fillColor,
                  focusedBorder: !isDark
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            width: 1.0,
                            color: borderColor,
                          ),
                        )
                      : null,

                  enabledBorder: !isDark
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: enabledBorderColor,
                            width: 1.0,
                          ),
                        )
                      : null,
                  labelText: label,
                  hintText: hint,
                  // fillColor: Colors.grey,

                  hintStyle: TextStyle(color: hintColor),

                  // fillColor: Colors.white,
                ),
          autofocus: autoFocus,
          readOnly: readOnly,
          obscureText: secure,
        );
        break;
      case ReactiveFields.PASSWORD:
        return ReactiveTextField(
          formControlName: controllerName,
          validationMessages: (controller) => validationM,
          keyboardType: TextInputType.visiblePassword,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: decoration != null
              ? decoration
              : InputDecoration(
                  suffixIcon: inkWell,
                  // labelStyle: TextStyle(color: Colors.blue),
                  // filled: filled,
                  // fillColor: fillColor,
                  focusedBorder: !isDark? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ):null,
                  enabledBorder: !isDark? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: 1.0,
                    ),
                  ):null,
                  labelText: label,
                  hintText: hint,

                  labelStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  hintStyle: TextStyle(color: hintColor),
                  // fillColor: Colors.grey,

                  // fillColor: Colors.white,
                ),
          autofocus: autoFocus,
          readOnly: readOnly,
          obscureText: secure,
        );
        break;
      case ReactiveFields.DROP_DOWN:
        return ReactiveDropdownField(
          hint: Text(hint ?? ""),
          items: items
              .map((item) => DropdownMenuItem<dynamic>(
                    value: item.sId,
                    child: new Text(
                      item.name,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ))
              .toList(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: decoration != null
              ? decoration
              : InputDecoration(
                  // labelStyle: TextStyle(color: Colors.blue),
                  // filled: filled,
                  // fillColor: fillColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: borderColor,
                      width: 1.0,
                    ),
                  ),

                  labelText: label,
                  hintText: hint,

                  labelStyle: TextStyle(color: textColor),
                  hintStyle: TextStyle(color: hintColor),

                  // fillColor: Colors.white,
                ),
          readOnly: readOnly,
          formControlName: controllerName,
          onChanged: onChange,
          // style: TextStyle(color: textColor),
        );
        break;
      case ReactiveFields.DATE_PICKER:
        return ReactiveDatePicker(
          formControlName: controllerName,
          builder: (context, picker, child) {
            return IconButton(
              onPressed: picker.showPicker,
              icon: Icon(Icons.date_range),
            );
          },
          firstDate: DateTime(1985),
          lastDate: DateTime(2030),
        );
        break;

      case ReactiveFields.DATE_PICKER_FIELD:
        return ReactiveTextField(
          formControlName: controllerName,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label_text_date,
            suffixIcon: ReactiveDatePicker(
              formControlName: controllerName,
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
              builder: (context, picker, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.amber,
                  ),
                  child: IconButton(
                    onPressed: picker.showPicker,
                    icon: Icon(Icons.date_range),
                  ),
                );
              },
            ),
          ),
        );
        break;

      case ReactiveFields.CHECKBOX_LISTTILE:
        return ReactiveCheckboxListTile();
        break;
      case ReactiveFields.RADIO_LISTTILE:
        return ReactiveRadioListTile(
            formControlName: controllerName,
            title: Text(radioTitle),
            value: radioVal);
        break;
    }
  }
}

import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

//Create generic dialog to be customized
//for different dialogs within the application
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showCustomDialog<void>(
    context: context,
    title: 'An error occured',
    content: text,
    optionsBuilder: () => {
      "Ok": null,
    },
  );
}

Future<bool> showRegistrationSuccessDialog(BuildContext context) {
  return showCustomDialog<bool>(
    context: context,
    title: 'Congratulations',
    content: 'Your profile has been created',
    optionsBuilder: () => {"Login": true, "Cancel": false},
  ).then((value) => value ?? false);
}


// Future<bool> showLogoutDialog(BuildContext context) {
//   return showCustomDialog<bool>(
//     context: context,
//     title: context.loc.logout_button,
//     content: context.loc.logout_dialog_prompt,
//     optionsBuilder: () => {
//       context.loc.cancel: false,
//       context.loc.logout_button: true,
//     },
//     //return false if the value is null
//   ).then((value) => value ?? false);
// }




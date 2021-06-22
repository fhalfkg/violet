// This source code is a part of Project Violet.
// Copyright (C) 2020-2021.violet-team. Licensed under the Apache-2.0 License.

import 'package:flutter/material.dart';
import 'package:violet/locale/locale.dart';
import 'package:violet/other/dialogs.dart';
import 'package:violet/settings/settings.dart';

class GroupModifyPage extends StatelessWidget {
  TextEditingController nameController;
  TextEditingController descController;

  final String name;
  final String desc;

  GroupModifyPage({this.name, this.desc}) {
    nameController = TextEditingController(text: name);
    descController = TextEditingController(text: desc);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Translations.of(context).trans('modifygroupinfo')),
      contentPadding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(children: [
            Text('${Translations.of(context).trans('name')}: '),
            Expanded(
              child: TextField(
                controller: nameController,
              ),
            ),
          ]),
          Row(children: [
            Text('${Translations.of(context).trans('desc')}: '),
            Expanded(
              child: TextField(
                controller: descController,
              ),
            ),
          ]),
          Container(
            height: 16,
          ),
          Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text(Translations.of(context).trans('delete')),
                onPressed: () async {
                  if (await showYesNoDialog(
                      context,
                      Translations.of(context).trans('deletegroupmsg'),
                      Translations.of(context).trans('bookmark')))
                    Navigator.pop(context, [2]);
                },
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Settings.majorColor,
                ),
                child: Text(Translations.of(context).trans('ok')),
                onPressed: () {
                  Navigator.pop(context, [
                    1,
                    nameController.text,
                    descController.text,
                  ]);
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Settings.majorColor,
                ),
                child: Text(Translations.of(context).trans('cancel')),
                onPressed: () {
                  Navigator.pop(context, [0]);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

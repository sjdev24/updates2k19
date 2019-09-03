import 'package:flutter/material.dart';
import 'package:updates_2k19/screens/components/transparent_parent.dart';
import 'package:updates_2k19/settings/colors.dart';

class DismissibleDialog extends StatelessWidget {
  final String message;

  DismissibleDialog({this.message});

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return TransparentParent(
      child: Center(
        child: Card(
          child: SizedBox(
            width: _size.width - 50,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message,
                    style: Theme.of(context).textTheme.display1,
                  ),
                  Divider(
                    height: 4.0,
                    color: kColorDivider,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'DISMISS',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

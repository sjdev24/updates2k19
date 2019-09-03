import 'package:flutter/material.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/utilities/asset_helper.dart';

class SponsorsScreen extends StatelessWidget {
  final List<String> sponsors = [
    'D\' Kitchen',
    'ForeFront Infotech',
    'D\'s Jewellery',
    'Aspirations Infinite',
    'Mission Paritran',
    'Premvati Gold',
    'Mr. Café',
    'Vijay Garments',
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.separated(
          physics: PageScrollPhysics(),
          itemCount: 8,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(0),
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox();
          },
          itemBuilder: (BuildContext context, int index) {
            return _getSponsorCard(constraints, context, index);
          },
        );
      },
    );
  }

  Widget _getSponsorCard(
      BoxConstraints constraints, BuildContext context, int index) {
    return Container(
      constraints: BoxConstraints.expand(width: constraints.maxWidth),
      child: Card(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 48.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Image(
                      image: AssetImage(
                          '${AssetHelper.SPONSORS_LOGO}s${index + 1}.jpg'),
                      fit: BoxFit.fitWidth,
                      width: constraints.maxWidth - 100,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                    )),
                SizedBox(
                  height: 24,
                ),
                Text(
                  sponsors[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display1.copyWith(
                        color: kColorTextPrimaryDark,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

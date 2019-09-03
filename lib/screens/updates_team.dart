import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatesTeam extends StatelessWidget {
  List<dynamic> _teamData = [
    {
      'name': "Kartik Gondaliya",
      'number': '9106360330',
      'branch': "CO-M/Batch 2021",
    },
    {
      'name': "Sahil Shingala",
      'number': '9925829140',
      'branch': "CO-M/Batch 2021",
    },
    {
      'name': "Mayank Goyani",
      'number': '9825696900',
      'branch': "CO-E/Batch 2021",
    },
    {
      'name': "Rishika Jain",
      'number': '9824138031',
      'branch': "CO-E/Batch 2021",
    },
  ];

  List<String> _facultyTeam = [
    'Prof. Dhatri Pandya',
    'Prof. Rachana Oza',
    'Prof. Urvashi Mistry',
    'Prof. Pratik Sailor'
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox();
          },
          itemBuilder: (BuildContext context, int index) {
            return _getDeveloperCard(context, index, constraints);
          },
          itemCount: _teamData.length,
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget _getDeveloperCard(
      BuildContext context, int index, BoxConstraints constraints) {
    ThemeData base = Theme.of(context);
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Name
                  Text(
                    _teamData[index]['name'],
                    style: base.textTheme.caption.copyWith(fontSize: 24),
                  ),

                  SizedBox(
                    height: 4.0,
                  ),

                  // Branch
                  Text(
                    'Updates2k19 Student Coordinator'.toUpperCase(),
                    style: base.textTheme.subhead.copyWith(fontSize: 12),
                  ),

                  // Branch
                  Text(
                    (_teamData[index]['branch'] as String).toUpperCase(),
                    style: base.textTheme.subhead.copyWith(fontSize: 12),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.phone,
                  color: Colors.lightGreenAccent,
                  size: 32,
                ),
                onPressed: () => _launchURL(
                  'tel:+91${_teamData[index]['number']}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

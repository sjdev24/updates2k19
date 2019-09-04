import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  final String linkedIn = 'https://www.linkedin.com/in/';
  final String github = 'https://github.com/';
  final String twitter = 'https://twitter.com/';
  final String instagram = 'https://www.instagram.com/';

  List<dynamic> _developerData = [
    {
      'name': "Smit Jivani",
      'branch': "CO-E/Batch 2020",
      'linkedin': "smitjivani",
      'github': "sjdev24",
      'twitter': "smit_jivani",
      'insta': 'smitjivani'
    },
    {
      'name': "Denish Chovatiya",
      'branch': "CO-M/Batch 2021",
      'linkedin': "denish-chovatiya",
      'github': "dgchovatiya",
      'twitter': "ChovatiyaDenish",
      'insta': 'denish__chovatiya'
    },
    {
      'name': "Nirav Limbani",
      'branch': "CO-M/Batch 2021",
      'linkedin': "nplimbani",
      'github': "nplimbani",
      'twitter': "np_limbani",
      'insta': 'nplimbani'
    },
    {
      'name': "Parth Roy",
      'branch': "CO-M/Batch 2020",
      'linkedin': "royaldream20",
      'github': "royaldream",
      'twitter': "parthroy1",
      'insta': 'parth_roy_20'
    },
    {
      'name': "Abhi Sondagar",
      'branch': "CO-M/Batch 2021",
      'linkedin': "",
      'github': "abhisondagar605",
      'twitter': "AbhiSondagar",
      'insta': 'abhi_sondagar_'
    },
    {
      'name': "Yagnik Beladiya",
      'branch': "CO-E/Batch 2021",
      'linkedin': "Yagnik-Beladiya-b30887162",
      'github': "ykbeladiya",
      'twitter': "beladiya_yagnik",
      'insta': 'beladiyayagnik'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        _developerData.shuffle();
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox();
          },
          itemBuilder: (BuildContext context, int index) {
            return _getDeveloperCard(context, index, constraints);
          },
          itemCount: _developerData.length,
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: <Widget>[
              // Name
              Text(
                _developerData[index]['name'],
                style: base.textTheme.caption.copyWith(fontSize: 24),
              ),

              SizedBox(
                height: 4.0,
              ),

              // Branch
              Text(
                (_developerData[index]['branch'] as String).toUpperCase(),
                style: base.textTheme.subhead.copyWith(fontSize: 12),
              ),

              // profile Buttons
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // linkedIn
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.white,
                    ),
                    onPressed: () => _launchURL(
                      '$linkedIn${_developerData[index]['linkedin']}',
                    ),
                  ),

                  // GitHub
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.github,
                      color: Colors.white,
                    ),
                    onPressed: () => _launchURL(
                      '$github${_developerData[index]['github']}',
                    ),
                  ),

                  // twitter
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.white,
                    ),
                    onPressed: () => _launchURL(
                      '$twitter${_developerData[index]['twitter']}',
                    ),
                  ),

                  // instagram
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.instagram,
                      color: Colors.white,
                    ),
                    onPressed: () => _launchURL(
                      '$instagram${_developerData[index]['insta']}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

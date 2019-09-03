import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:updates_2k19/blocs/all_events_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/screens/event_screen.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/settings/constants.dart';
import 'package:updates_2k19/utilities/asset_helper.dart';

class AllEventsScreen extends StatefulWidget {
  static const String ROUTE_NAME = "/AllEventsScreen";

  @override
  _AllEventsScreenState createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  AllEventsBloc allEventsBloc;
  ScrollController _scrollController = ScrollController();

  double _cardWidth;
  int _currentItem;
  int _totalItems;

  @override
  void initState() {
    allEventsBloc = AllEventsBloc();
    super.initState();
  }

  Widget _getEventCard(Event event, BoxConstraints constraints, int tag) {
    int attachTag = tag;
    var base = Theme.of(context);
    String imagePath =
        '${AssetHelper.EVENTS_LOGO}${event.event_name.toLowerCase().replaceAll(' ', '_')}.png';
    return Container(
      constraints: BoxConstraints.expand(width: constraints.maxWidth),
      child: Stack(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.zero)),
            elevation: 0.0,
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    AutoSizeText(
                      event.ln_hindi,
                      style: kTextStyleTitleHindi(base.textTheme.display3),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      child: Image(
                        width: constraints.maxWidth - 150,
                        height: constraints.maxWidth - 150,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(imagePath),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.0),
                      ),
                    ),
                    AutoSizeText(
                      '${event.team_size > 1 ? 'Team' : 'Individual'} Event',
                      textAlign: TextAlign.center,
                      style: base.textTheme.display3.copyWith(fontSize: 48),
                      maxLines: 1,
                    ),
                    event.team_size > 1
                        ? Text(
                            'Team Size: ${event.team_size}',
                            textAlign: TextAlign.center,
                            style: base.textTheme.display1,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 24.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventScreen(event),
                          ),
                        );
                      },
                      child: Text(
                        'TAP HERE TO KNOW MORE',
                        style: base.textTheme.display2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: RawMaterialButton(
                textStyle: base.textTheme.button.copyWith(
                  color: kColorPrimary,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'NEXT',
                    ),
                    Icon(Icons.navigate_next),
                  ],
                ),
                fillColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18.0))),
                onPressed: () {
                  _scrollToNextItem(attachTag);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: allEventsBloc.eventsData,
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (snapshot.hasData) _totalItems = snapshot.data.length;
          return !snapshot.hasData
              ? Center(
                  child: Text(
                    'No Data',
                  ),
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.all(0.0),
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    _currentItem = index;
                    _cardWidth = constraints.maxWidth;
                    return _getEventCard(
                        snapshot.data.elementAt(index), constraints, index);
                  },
                );
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    allEventsBloc.dispose();
  }

  void _scrollToNextItem(int item) {
    var t = 0.0;
    if (item < (_totalItems - 1))
      t = _cardWidth * (item + 1);
    else
      t = -(_cardWidth * _totalItems);
    _scrollController.animateTo(t,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }
}

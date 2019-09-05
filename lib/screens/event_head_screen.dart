import 'package:flutter/material.dart';
import 'package:updates_2k19/blocs/event_head_screen_bloc.dart';
import 'package:updates_2k19/models/event.dart';
import 'package:updates_2k19/settings/colors.dart';
import 'package:updates_2k19/utilities/connectivity_helper.dart';

class EventHeadScreen extends StatefulWidget {
  @override
  _EventHeadScreenState createState() => _EventHeadScreenState();
}

class _EventHeadScreenState extends State<EventHeadScreen> {
  EventHeadScreenBloc _bloc = EventHeadScreenBloc();

  List<Event> _events;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
        stream: _bloc.eventData,
        builder: (context, snapshot) {
          if (snapshot == null ||
              !snapshot.hasData ||
              snapshot.data.length == 0)
            return Center(
              child: CircularProgressIndicator(
                value: null,
              ),
            );
          _events = _bloc.eventData.value;
          return ListView.separated(
            itemCount: snapshot.data.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox();
            },
            itemBuilder: (BuildContext context, int index) {
              return _getListTile(context, index);
            },
          );
        });
  }

  Widget _getListTile(BuildContext context, int index) {
    return ListTile(
      title: Text(_events[index].event_name.toUpperCase()),
      trailing: Switch(
        onChanged: (bool value) async {
          var x = await ConnectivityHelper.checkConnection(context: context);
          if (x == false) return;
          setState(() {
            _bloc.toggleEventAttendanceAllowance(index);
          });
        },
        value: _events[index].allow_attendance,
        activeColor: Colors.lightGreenAccent,
        inactiveThumbColor: kColorTextPrimaryDark,
        inactiveTrackColor: kColorSurface,
      ),
    );
  }
}

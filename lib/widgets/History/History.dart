import 'package:flutter/material.dart';

class History extends StatelessWidget {
  final List<String> history;
  final int selectedIdx;
  final void Function(String content, int index) onTapTile;

  History({Key key, this.history, this.selectedIdx, this.onTapTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasHistory = history.length != 0;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22, bottom: 22),
                child: Text(
                  'History',
                  style: TextStyle(color: Colors.green, fontSize: 28),
                ),
              ),
            ),
            Expanded(
              child: hasHistory
                  ? ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: history.length,
                      itemBuilder: (BuildContext context, int index) {
                        final content = history[index];

                        return ListTile(
                          key: Key(content),
                          title: Text(content),
                          onTap: () => onTapTile(content, index),
                          trailing: selectedIdx != index
                              ? null
                              : Text(
                                  'Copied',
                                  style: TextStyle(color: Colors.green),
                                ),
                        );
                      },
                    )
                  : Text(
                      "History is empty...",
                      style: TextStyle(color: Colors.grey),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

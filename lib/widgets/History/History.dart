import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final List<String> history;
  final int selectedIdx;
  final void Function(String content, int index) onTapTile;
  final Future<void> Function(int index) onDelete;
  final GlobalKey<AnimatedListState> listKey;

  History({
    Key key,
    @required this.listKey,
    this.history,
    this.selectedIdx,
    this.onTapTile,
    this.onDelete,
  }) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  void _onDismissed(index) async {
    await widget.onDelete(index);

    widget.listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) =>
          _itemBuilder(context, index, animation),
      duration: Duration.zero,
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final content = widget.history[index];

    return SizeTransition(
      key: Key(content),
      axis: Axis.vertical,
      sizeFactor: animation,
      child: Dismissible(
        key: Key(content),
        onDismissed: (_) => _onDismissed(index),
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        child: ListTile(
          key: Key(content),
          title: Text(content),
          onTap: () => widget.onTapTile(content, index),
          trailing: widget.selectedIdx != index
              ? null
              : Text(
                  'Copied',
                  style: TextStyle(color: Colors.green),
                ),
        ),
      ),
    );
  }

  Widget _listBuilder() {
    return AnimatedList(
      key: widget.listKey,
      padding: const EdgeInsets.all(8),
      initialItemCount: widget.history.length,
      itemBuilder: (
        BuildContext context,
        int index,
        Animation<double> animation,
      ) =>
          _itemBuilder(context, index, animation),
    );
  }

  Widget _emptyTipBuilder() {
    return Text(
      "History is empty...",
      style: TextStyle(color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasHistory = widget.history.length != 0;

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
            Expanded(child: hasHistory ? _listBuilder() : _emptyTipBuilder()),
          ],
        ),
      ),
    );
  }
}

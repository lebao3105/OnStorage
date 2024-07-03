import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show AppBar, Scaffold;
import 'package:onstorage/Utilities.dart';

enum QueueType {
	Copy,
	Delete,
	Move
}

class _QueueList extends State<QueueList>
{
	late final QueueType type;
	_QueueList({required this.type});

	List<String> findTarget() {
		switch (type) {
			case QueueType.Copy:
		    	return copyQueue;
			case QueueType.Delete:
				return delQueue;
			case QueueType.Move:
				return moveQueue;
		}
	}

	@override
	Widget build(BuildContext context)
	{
		final targetList = findTarget();

		return Scaffold(
			appBar: AppBar(title: createBoldText(type.name, null)),
			body:
				Expanded(
					child: targetList.isEmpty ? emptyList() : ListView.builder(
						shrinkWrap: true,
						itemCount: targetList.length,
						itemBuilder: (ctxt, idx) {
							final item = targetList[idx];

							return ListTile.selectable(
								selected: false,
								selectionMode: ListTileSelectionMode.multiple,
								title: Text(item)
							);
						}
					)
				)
		);
	}
}

class QueueList extends StatefulWidget
{
	final QueueType type;
	const QueueList({required this.type});

	@override
	_QueueList createState() => _QueueList(type: type);
}
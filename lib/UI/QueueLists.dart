import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show AppBar, Scaffold;
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';

enum QueueType {
	Blank,
	Copy,
	Delete,
	Move;

	static QueueType getByString(String what)
	{
		final ret = {
			"blank": Blank,
			"copy": Copy,
			"delete": Delete,
			"trash": Delete,
			"move": Move
		}[what];

		if (ret == null) {
			throw Exception(
				['Invalid query list type: must be one of copy, delete, trash, move.',
				 'Got $what.']
			);
		}

		return ret;
	}
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
			case QueueType.Blank:
				return [];
		}
	}

	@override
	Widget build(BuildContext context)
	{
		final targetList = findTarget();

		return Scaffold(
			appBar: AppBar(title: createBoldText(type.name)),
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
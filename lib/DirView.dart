import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Tooltip, Text, ListTile, ListView;
import 'package:onstorage/UI/Utilities.dart';
import 'package:path/path.dart' as p;
import 'package:onstorage/Utilities.dart';

class DirTreeItem extends TreeViewItem
{
	final String where;
	DirTreeItem({required this.where})
		: super(content: Text(p.basename(where)), lazy: true,
				onExpandToggle: (item, getsExpanded) async {
					if (item.children.isNotEmpty) return;
					if (await pathIsDir(where)) return;

					final contents = await getDirContent(where);
					item.children.addAll(contents.map((e) => DirTreeItem(where: e)));
				});
}

class _DirView extends State<DirView>
{
	var _breadcrumbItems = <BreadcrumbItem<int>>[];
	var _list_items = <ListTile>[];
	var _tree_items = <DirTreeItem>[];
	var _selectedItems = [];

	final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

	@override
	void initState() {
		super.initState();
		_setupItems();
	}

	void _setupItems() async
	{
		var num = 0;
		_breadcrumbItems =
			p.split(changes.currDir).map((name) {
				num++;
				return BreadcrumbItem(label: createText(name), value: num - 1);
			}).toList();

		final dirItems = await getDirContent(changes.currDir);
		
		_list_items = dirItems.map((entity) {
			return ListTile.selectable(
				title: createText(entity),
				selected: _selectedItems.contains(entity),
				selectionMode: ListTileSelectionMode.multiple,
				onPressed: () => setState(() {changes.currDir = entity; _setupItems();}), trailing: const Icon(FluentIcons.arrow_up_right),
				leading: const Icon(FluentIcons.file_image));
		}).toList();

		_tree_items = dirItems.map((entity) {
			return DirTreeItem(where: entity);
		}).toList();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title:
					BreadcrumbBar<int>(
						items: _breadcrumbItems,
						onItemPressed: (item) {
							setState(() {
								final idx = item.value;
								String newpath = "";

								_breadcrumbItems.removeRange(idx + 1, _breadcrumbItems.length);

								for (var item in _breadcrumbItems) {
									newpath = p.join(newpath, (item.label as Text).data);
								}
								changes.currDir = newpath;

								_setupItems();
							});
						}
					)
			),
			body:
				RefreshIndicator(
					key: _refreshIndicatorKey,
					child:  _tree_items.isEmpty ? emptyList() : ( // we can use _tree_items or _list_items for empty check
							changes.isUsingTree ? TreeView(items: _tree_items, shrinkWrap: true, selectionMode: TreeViewSelectionMode.multiple)
									: ListView.builder(
											shrinkWrap: true,
											itemCount: _list_items.length,
											itemBuilder: (ctx, idx) {
												return _list_items[idx];
											}
										)
						
					),
					onRefresh: () async { await Future.delayed(const Duration(seconds: 3)); setState(() {}); },
				),
			floatingActionButton:
				FloatingActionButton.extended(
					onPressed: () => _refreshIndicatorKey.currentState?.show(),
					icon: const Icon(FluentIcons.action_center),
					label: const Text('Actions')
				),
		);
	}
}

class DirView extends StatefulWidget
{
	final String where;
	const DirView({super.key, required this.where});

	@override
	_DirView createState() => _DirView();
}
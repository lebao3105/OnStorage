import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Tooltip, Text, ListTile, ListView;
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

					// c++ helper supported platforms
					// todo: ios and android
					if (!(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
						final dir = Directory(where);

						item.children.addAll(
							await dir.list().map((entity) {
								return DirTreeItem(where: entity.path);
							}).toList()
						);
					}
					else {
						final process = await Process.start(helperPath, ['list', where]);
						stdardout.clear();
						await process.stdout.transform(utf8.decoder).forEach((path) {
								item.children.add(
									DirTreeItem(where: path)
								);
							}
						);
					}
				});
}

class _DirView extends State<DirView>
{
	var _breadcrumbItems = <BreadcrumbItem<int>>[];
	var _list_items = <ListTile>[];
	var _tree_items = <DirTreeItem>[];

	final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

	_DirView() { _setupItems(); }

	void _setupItems() async {
		var num = 0;
		_breadcrumbItems =
			p.split(currDir).map((name) {
				num++;
				return BreadcrumbItem(label: createText(name), value: num - 1);
			}).toList();

		final dir = Directory(currDir);
		
		_list_items = await dir.list().map((entity) {
			return ListTile.selectable(title: createText(p.basename(entity.path)), selected: false,
									   selectionMode: ListTileSelectionMode.multiple,
									   onPressed: () => setState(() {currDir = entity.path; _setupItems();}), trailing: const Icon(FluentIcons.arrow_up_right),
									   leading: const Icon(FluentIcons.file_image));
		}).toList();

		_tree_items = await dir.list().map((entity) {
			return DirTreeItem(where: entity.path);
		}).toList();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: BreadcrumbBar<int>(
						items: _breadcrumbItems,
						onItemPressed: (item) {
							setState(() {
								final idx = item.value;
								String newpath = "";

								_breadcrumbItems.removeRange(idx, _breadcrumbItems.length);

								for (var item in _breadcrumbItems) {
									p.join(newpath, (item.label as Text).data);
								}
								currDir = newpath;
								_setupItems();
							});
						}
					)
			),
			body:
				RefreshIndicator(
					key: _refreshIndicatorKey,
					child:  _tree_items.isEmpty ? emptyList() : ( // we can use _tree_items or _list_items for empty check
							isUsingTree ? TreeView(items: _tree_items, shrinkWrap: true, selectionMode: TreeViewSelectionMode.multiple)
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
	const DirView({super.key});

	@override
	_DirView createState() => _DirView();
}
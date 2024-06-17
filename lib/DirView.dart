import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Tooltip, Text, ListTile, ListView;
import 'package:path/path.dart' as p;
import 'package:swifile/Utilities.dart';

class DirTreeItem extends TreeViewItem
{
	final String where;
	DirTreeItem({required this.where})
		: super(content: Text(p.basename(where)), lazy: true,
				onExpandToggle: (item, getsExpanded) async {
					if (item.children.isNotEmpty) return;
					if (await pathIsDir(where)) return;

					final dir = Directory(where);

					item.children.addAll(
						await dir.list().map((entity) {
							return DirTreeItem(where: entity.path);
						}).toList()
					);
				});
}

class DirListItem extends ListTile
{
	final String path;

	DirListItem({required this.path})
		: super.selectable(title: Text(p.basename(path)), selected: false,
						   selectionMode: ListTileSelectionMode.multiple,
						   onSelectionChange: (_) {}, trailing: const Icon(FluentIcons.arrow_up_right),
						   leading: const Icon(FluentIcons.file_image));
}

class _DirView extends State<DirView>
{
	String path;
	var _breadcrumbItems = <BreadcrumbItem<int>>[];
	var _list_items = <DirListItem>[];
	var _tree_items = <DirTreeItem>[];
	var useTree = false;

	_DirView({required this.path})
	{
		var num = 0;
		_breadcrumbItems =
			p.split(path).map((name) {
				num++;
				return BreadcrumbItem(label: Text(name), value: num - 1);
			}).toList();
		_setupItems();
	}

	void _setupItems() async {
		final dir = Directory(path);
		
		_list_items = await dir.list().map((entity) {
			return DirListItem(path: entity.path);
		}).toList();

		_tree_items = await dir.list().map((entity) {
			return DirTreeItem(where: entity.path);
		}).toList();
	}

	@override
	Widget build(BuildContext context) {
		return ScaffoldPage.scrollable(
			header: AppBar(
				title: Column( // is this the longest title bar ever?
					children: [
						BreadcrumbBar<int>(
							items: _breadcrumbItems,
							onItemPressed: (item) {
								setState(() {
									final idx = _breadcrumbItems.indexOf(item);
									String newpath = "";

									_breadcrumbItems.removeRange(idx + 1, _breadcrumbItems.length);

									for (var item in _breadcrumbItems) {
										p.join(newpath, (item.label as Text).data);
									}
									path = newpath;
									_setupItems();
								});
							}
						),

						CommandBar(
							overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
							primaryItems: [
								CommandBarBuilderItem(
									builder: (context, mode, w) => Tooltip(
										message: "Create something new!",
										child: w
									),
									wrappedItem: CommandBarButton(
										icon: const Icon(FluentIcons.add),
										onPressed: () {},
									)
								),

								CommandBarBuilderItem(
									builder: (context, mode, w) => Tooltip(
										message: "Delete what is/are currently selected!",
										child: w
									),
									wrappedItem: CommandBarButton(
										icon: const Icon(FluentIcons.delete),
										onPressed: () {},
									)
								),
								
								const CommandBarSeparator(),

								CommandBarBuilderItem(
									builder: (context, mode, w) => Tooltip(
										message: "Add to Copy queue",
										child: w
									),
									wrappedItem: CommandBarButton(
										icon: const Icon(FluentIcons.copy),
										onPressed: () {}
									)
								),
								CommandBarBuilderItem(
									builder: (context, mode, w) => Tooltip(
										message: "Add to Paste queue",
										child: w
									),
									wrappedItem: CommandBarButton(
										icon: const Icon(FluentIcons.paste),
										onPressed: () {}
									)
								),
								
								const CommandBarSeparator(),

								CommandBarButton(
									icon: const Icon(FluentIcons.move),
									onPressed: () {}
								),
								CommandBarButton(
									icon: const Icon(FluentIcons.archive),
									onPressed: () {}
								),
								
								const CommandBarSeparator(),

								CommandBarBuilderItem(
									builder: (ctx, mode, w) => Tooltip(
										message: "Item listing option (currently is ${useTree ? 'tree' : 'list'})",
										child: w
									),
									wrappedItem: CommandBarButton(
										icon: Icon(useTree ? FluentIcons.bulleted_tree_list : FluentIcons.list),
										label: const Text('Listing'),
										onPressed: () => setState(() {useTree = !useTree;})
									)
								)
							]
						)
					]
				)
			),
			children: [
				Expanded(
					child: _tree_items.isEmpty ? emptyList() : ( // we can use _tree_items or _list_items for empty check
						useTree ? TreeView(items: _tree_items, shrinkWrap: true, selectionMode: TreeViewSelectionMode.multiple)
								   : ListView.builder(
										shrinkWrap: true,
										itemCount: _list_items.length,
										itemBuilder: (ctx, idx) {
											return _list_items[idx];
										}
									)
					)
				)
			]
		);
	}
}

class DirView extends StatefulWidget
{
	final String path;
	const DirView({super.key, required this.path});

	@override
	_DirView createState() => _DirView(path: path);
}
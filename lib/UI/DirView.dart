import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Tooltip, Text, ListTile, ListView;
import 'package:onstorage/UI/Utilities.dart';
import 'package:path/path.dart' as p;
import 'package:onstorage/Utilities.dart';

class DirViewItem
{
	final String itemName;
	late final ListTile listItem;
	late final TreeViewItem treeItem;

	DirViewItem({required this.itemName, bool showListItemFirst = true})
	{
		final crafted = p.join(changes.currDir, itemName);
		final isDir = pathIsDir(crafted);

		listItem = ListTile(
			title: createText(itemName),
			onPressed: () => changes.currDir = crafted,
			leading: Icon(
				isDir ? FluentIcons.folder : FluentIcons.page
			),
		);

		treeItem = createTreeItem(crafted);
	}

	TreeViewItem createTreeItem(String fullPath)
	=> TreeViewItem(
		content: createText(itemName),
		lazy: true,
		onExpandToggle: (item, getsExpanded) async {
			if (item.children.isNotEmpty || !pathIsDir(fullPath)) return;

			item.children.addAll(
				getDirContent(fullPath).map((e) => createTreeItem(p.join(fullPath, e)))
			);
		}
	);
}

class _DirView extends State<DirView>
{
	var _breadcrumbItems = <BreadcrumbItem<int>>[];
	List<DirViewItem> items = [];
	var _selectedItems = [];

	final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

	@override
	void initState()
	{
		super.initState();
		_setupItems();
		// TO BE FIXED
		// changes.addListener(_setupItems);
	}

	void _setupItems() async
	{
		var num = 0;
		_breadcrumbItems =
			p.split(changes.currDir).map(
				(name) => BreadcrumbItem(label: createText(name), value: num++)
			).toList();

		final dirItems = getDirContent(changes.currDir);
		
		items = dirItems.map(
			(e) => DirViewItem(itemName: e)
		).toList();
		setState(() {});
	}

	@override
	Widget build(BuildContext context)
	{
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
			
			/// End appBar - Start body
			
			body:
				RefreshIndicator(
					key: _refreshIndicatorKey,
					child:
						items.isEmpty ? emptyList() : (
							changes.isUsingTree
								?
									TreeView(
										items: items.map((e) => e.treeItem).toList(),
										shrinkWrap: true,
										selectionMode: TreeViewSelectionMode.multiple
									)
								:
									ListView.builder(
										shrinkWrap: true,
										itemCount: items.length,
										itemBuilder: (ctx, idx) => items[idx].listItem
									)
						),
					onRefresh: () async { _setupItems(); },
				),
			
			/// End body - start floatingActionButton
			
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
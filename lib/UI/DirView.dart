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
	late final GestureDetector listItem;
	late final TreeViewItem treeItem;

	DirViewItem({required this.itemName, bool showListItemFirst = true})
	{
		final crafted = p.join(changes.currDir, itemName);
		final isDir = pathIsDir(crafted);

		listItem = createWidgetWithGestures(
			ListTile(
				title: createText(itemName),
				onPressed: () => changes.currDir = crafted,
				leading: Icon(
					isDir ? FluentIcons.folder : FluentIcons.page
				),
			)
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

	GestureDetector createWidgetWithGestures(Widget child)
	{
		final contextController = FlyoutController();
		final contextAttatchKey = GlobalKey();
		final crafted = p.join(changes.currDir, itemName);

		return GestureDetector(
			onSecondaryTapUp: (d) {
				contextController.showFlyout(
					builder:
						(ctxt) => FlyoutContent(
							child: CommandBar(
								primaryItems: [
									CommandBarButton(
										icon: const Icon(FluentIcons.add_favorite),
										label: const Text('Add to Favourites'),
										onPressed: () => favourites.add(crafted)
									),
									CommandBarButton(
										icon: const Icon(FluentIcons.copy),
										label: const Text('Copy'),
										onPressed: () => copyQueue.add(crafted)
									),
									CommandBarButton(
										icon: const Icon(FluentIcons.paste),
										label: const Text('Paste'),
										onPressed: () {}
									),
									CommandBarButton(
										icon: const Icon(FluentIcons.cut),
										label: const Text('Cut'),
										onPressed: () {}
									),
									CommandBarButton(
										icon: const Icon(FluentIcons.open_with),
										label: const Text('Open with'),
										onPressed: () {}
									),
									CommandBarButton(
										icon: const Icon(FluentIcons.entitlement_policy),
										label: const Text('Properties'),
										onPressed: () {}
									)
								],
							)
						)
				);
			},
			child: FlyoutTarget(
				key: contextAttatchKey,
				controller: contextController,
				child: child
			)
		);
	}
}

class _DirView extends State<DirView>
{
	var _breadcrumbItems = <BreadcrumbItem<int>>[];
	List<DirViewItem> items = [];
	var _selectedItems = [];

	final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

	@override
	void initState()
	{
		super.initState();
		_setupItems();
		changes.addListener(_setupItems);
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
			appBar:
				AppBar(
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
			
			body: ListenableBuilder(
				listenable: changes,
				builder: (ctxt, _)
				=> RefreshIndicator(
					key: _refreshIndicatorKey,
					child:
						items.isEmpty ? emptyList() : (
							changes.isUsingTree
								?
									TreeView(
										items: items.map((e) { return e.treeItem; }).toList(),
										shrinkWrap: true,
										selectionMode: TreeViewSelectionMode.multiple,
										onSelectionChanged: (selectedItems) async {
											// Item content (which is a Text)'s data
											// should not be null.
											_selectedItems = selectedItems.map(
												(e) => (e.content as Text).data
											).toList();
										},
									)
								:
									ListView.builder(
										shrinkWrap: true,
										itemCount: items.length,
										itemBuilder: (ctx, idx) => items[idx].listItem
									)
						),
					onRefresh: () async { _setupItems(); },
				)
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
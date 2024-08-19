import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show AppBar, Scaffold;
import 'package:go_router/go_router.dart';

import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';

class FavouritesList extends StatefulWidget
{
	@override
  State<StatefulWidget> createState() => _FavouritesList();
}

class _FavouritesList extends State<FavouritesList>
{
	List<String> selected = [];

	@override
  Widget build(BuildContext context)
	{
		return Scaffold(
			appBar:
				AppBar(
					title: createBoldText('Favourites'),
					actions: [
						IconButton(
							icon: Icon(FluentIcons.delete),
							onPressed: () =>
								setState(() => selected.forEach(favourites.remove))
						),

						IconButton(
							icon: Icon(FluentIcons.add_favorite),
							onPressed: () {
								final controller = TextEditingController();
								createDialog(
									context, 'Add to favourites',
									Center(
										child:
											TextBox(placeholder: 'Full path',
															controller: controller)
									),
									[Button(child: createText('Add'),
													 onPressed: () => setState(() => favourites.add(controller.text))),
									 Button(child: createText('Cancel'),
													 onPressed: () => context.pop())]
								);
							},
						)
					]
				),
			body:
				favourites.isEmpty
					? emptyList()
					: ListView.builder(
							itemCount: favourites.length,
							itemBuilder: (context, index) {
								final fullpath = favourites.elementAt(index);

								return ListTile.selectable(
									title: createText(fullpath),
									leading:
										Icon(
											pathIsDir(fullpath)
												? FluentIcons.folder_horizontal
												: FluentIcons.page
										),
									selectionMode: ListTileSelectionMode.multiple,
									onSelectionChange: (state) {
										state ? selected.add(fullpath) : selected.remove(fullpath);
									},
								);
							}
						)
		);
	}
}
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:go_router/go_router.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';

import 'package:path/path.dart' as p;

class ItemProperties extends StatefulWidget
{
	final String path;

	ItemProperties({required this.path})
		: assert (pathIsDir(path));

	@override
  State<StatefulWidget> createState() => _ItemProperties();
}

class _ItemProperties extends State<ItemProperties>
{
	@override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: AppBar(
				title: createBoldText(p.basename(widget.path)),
				actions: [
					IconButton(
						icon: Icon(FluentIcons.chrome_close),
						onPressed: () => context.pop(),
					)
				]
			),

			body:
				Column(
					children: [
						// To be filled...
					]
				)
		);
  }
}
import 'dart:io';

import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:onstorage/Utilities.dart';
import 'package:path/path.dart' as p;

class DirButton extends StatelessWidget {
	final String path;
	final String iconName;

	const DirButton({required this.path, required this.iconName});

	@override
	Widget build(BuildContext context) {
		return Button(
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: [
					Icon(FluentIcons.allIcons[iconName], size: 27),
					Column(
						mainAxisAlignment: MainAxisAlignment.spaceEvenly,
						children: [
							createBoldText(p.basename(path), null),
							const SizedBox(width: 10),
							createText('Pinned', null)
						]
					)
				]
			),
			onPressed: () {}
		);
	}
}

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
	bool ePane_isExpanded = false;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: createBoldText('Home', null)),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						const Text(
							'Welcome to Swifile',
							style: TextStyle(
								fontWeight: FontWeight.bold,
								fontFamily: 'UbuntuMono',
								fontSize: 27
							)
						),

						Expander(
							header: const Text('Pinned'),
							content: Flexible(
								child: SingleChildScrollView( // fix overflow on window resize / so many items
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceEvenly,
										children:
											(pinned + favourites).map((item) {
												return DirButton(path: item, iconName: 'folder');
											}).toList() +

											() {
												List<DirButton> ret = [];
												availableHomeDirs().forEach(
													(path, ico) {
														ret.add(DirButton(path: path, iconName: ico));
													}
												);
												return ret;
											}()
									)
								)
							)
						),

						const Expander(
							header: Text('Drivers'),
							content: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: [
									// DirButton(path: )
								]
							)
						)
					]
				)
			)
		);
	}
}

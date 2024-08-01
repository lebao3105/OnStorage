import 'dart:io';

import 'package:disks_desktop/disks_desktop.dart';
import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:onstorage/DirView.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/Utilities.dart';
import 'package:path/path.dart' as p;

class DirButton extends StatefulWidget
{
	final String path;
	final String iconName;

	const DirButton({required this.path, required this.iconName});

	@override
	_DirButton createState() => _DirButton(path: path, iconName: iconName);
}

class _DirButton extends State<DirButton> {
	final String path;
	final String iconName;

	_DirButton({required this.path, required this.iconName});

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
							createBoldText(p.basename(path)),
							const SizedBox(width: 10),
							createText('Pinned')
						]
					)
				]
			),
			onPressed: () { changes.currDir = path; changes.navSelectedIdx = 1; changes.showDirBar = true; }
		);
	}
}

class HomePage extends StatefulWidget {
	@override
	_HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: createBoldText('Home')),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						const Text(
							'Welcome to OnStorage!',
							style: TextStyle( fontWeight: FontWeight.bold, fontFamily: 'UbuntuMono', fontSize: 27 )
						),

						Expander(
							header: const Text('Pinned'),
							content:
								SingleChildScrollView(
									scrollDirection: Axis.horizontal,
									child:
										Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
						),

						const Expander(
							header: Text('Drivers'),
							content: Row(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: []
							)
						)
					]
				)
			)
		);
	}
}

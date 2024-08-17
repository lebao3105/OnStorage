import 'dart:io';

import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import 'DirView.dart';
import 'Utilities.dart';
import '../Utilities.dart';
import '../main.dart';

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
			onPressed: () => context.go('/view?where=$path')
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

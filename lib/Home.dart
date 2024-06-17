import 'package:flutter/material.dart' show Scaffold, AppBar;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:swifile/Utilities.dart';

class HomePage extends StatelessWidget
{
	const HomePage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: createText('Home')),
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
							),
						),

						Row(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: [
								Button(
									child: Column(
										mainAxisAlignment: MainAxisAlignment.spaceEvenly,
										children: [
											const Icon(FluentIcons.offline_storage),
											createText('Internal storage')
										]
									),
									onPressed: () {},
								),

								Button(
									child: Column(
										children: [
											const Icon(FluentIcons.s_d_card),
											createText('SD Card')
										]
									),
									onPressed: () {},
								)
							]
						)
						
					]
				)
			)
		);
	}
}
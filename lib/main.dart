import 'dart:io';
import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:system_theme/system_theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:onstorage/Home.dart';
import 'package:onstorage/QueueLists.dart';
import 'package:onstorage/Settings.dart';
import 'package:onstorage/DirView.dart';
import 'package:onstorage/Utilities.dart';


final _router = GoRouter(
	routes: [
		GoRoute(
			path: '/',
			builder: (ctxt, state) => const NavView()
		),
		GoRoute(
			path: '/settings',
			builder: (ctxt, state) => SettingsPage()
		),
		GoRoute(
			path: '/settings/languages',
			builder: (ctxt, state) => LanguagesPage()
		)
	]
);

class MainApp extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		if (kIsWeb) {
			showDialog(
				context: context,
				builder: (ctx) => ContentDialog(
					title: const Text('Ain\'t no way'),
					content: const Text(
						'We found you running this application in a browser. You won\'t have any practical things doing that. Understand?'
					),
					actions: [
						Button(
							child: const Text('Ok, just let me go around'),
							onPressed: () { ctx.pop(); }
						),
						Button(
							child: const Text('Quit'),
							onPressed: () { exit(0); }
						)
					]
				)
			);
		}

		final accolor = SystemTheme.accentColor.accent.toAccentColor();
	
		return FluentApp.router(
			title: "OnStorage",
			debugShowCheckedModeBanner: true,
			routerConfig: _router,
			
			themeMode: ThemeMode.system,
			theme: FluentThemeData(fontFamily: 'Ubuntu', accentColor: accolor),
			darkTheme: FluentThemeData(fontFamily: 'Ubuntu', accentColor: accolor, brightness: Brightness.dark),

			builder: (ctx, w) => Directionality(
				textDirection: TextDirection.ltr,
				child: w!
			),
			localizationsDelegates: const [
				AppLocalizations.delegate,
				GlobalMaterialLocalizations.delegate,
				GlobalWidgetsLocalizations.delegate,
				FluentLocalizations.delegate
			],
			supportedLocales: AppLocalizations.supportedLocales
		);
	}
}


class _NavView extends State<NavView>
{

	@override
	Widget build(BuildContext context)
	{
		final loc = AppLocalizations.of(context)!;

		final footerItems = [
			PaneItem(
				icon: const Icon(FluentIcons.settings),
				title: createText(loc.settings),
				body: SettingsPage()
			)
		];

		final navItems = [
			PaneItem(
				icon: const Icon(FluentIcons.home),
				title: createText(loc.home),
				body: HomePage()
			),
			PaneItem(
				icon: const Icon(FluentIcons.folder),
				title: createText('Folder'),
				body: const DirView()
			),
			PaneItemHeader(header: createText(loc.queue)),
			PaneItem(
				icon: const Icon(FluentIcons.copy),
				title: createText(loc.copy),
				body: const QueueList(type: QueueType.Copy),
				infoBadge: InfoBadge(source: Text(copyQueue.length.toString()))
			),

			PaneItem(
				icon: const Icon(FluentIcons.move),
				title: createText(loc.move),
				body: const QueueList(type: QueueType.Move),
				infoBadge: InfoBadge(source: Text(moveQueue.length.toString()))
			),

			PaneItem(
				icon: const Icon(FluentIcons.delete),
				title: createText(loc.trash),
				body: const QueueList(type: QueueType.Delete),
				infoBadge: InfoBadge(source: Text(delQueue.length.toString()))
			)
		];

		return NavigationView(
			appBar: NavigationAppBar(
				title: Column( // is this the longest title bar ever?
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						showDirBar ? CommandBar(
							overflowBehavior: CommandBarOverflowBehavior.dynamicOverflow,
							primaryItems: [
								CommandBarBuilderItem(
									builder: (context, mode, w) => Tooltip(
										message: "Create something new!",
										child: w
									),
									wrappedItem: CommandBarButton(
										icon: const Icon(FluentIcons.add),
										onPressed: () async {
											await showDialog(
												context: context,
												builder: (_) => ContentDialog(
													title: createText('Create a new thing'),
													content: Column(
														mainAxisSize: MainAxisSize.min,
														children: [
															InfoLabel(
																label: 'Enter the name or relative path of new item you want to create.',
																child: const TextBox(
																	placeholder: 'Just not a full path... and it must not exist',
																	expands: false
																)
															)
														],
													),
													actions: [
														Button(
															child: createText('New file'),
															onPressed: () {},
														),
														Button(
															child: createText('New folder'),
															onPressed: () {},
														),
														FilledButton(child: createText('Cancel'), onPressed: () => context.pop())
													]
												)
											);
											setState(() {});
										},
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
										message: "Item listing option (currently is ${isUsingTree ? 'tree' : 'list'})",
										child: w
									),
									wrappedItem: CommandBarButton(
										icon: Icon(isUsingTree ? FluentIcons.bulleted_tree_list : FluentIcons.list),
										label: const Text('Listing'),
										onPressed: () => setState(() {isUsingTree = !isUsingTree;})
									)
								)
							]
						) : const SizedBox.shrink()
					]
				)
			),
			pane: NavigationPane(
				displayMode: PaneDisplayMode.auto,
				footerItems: footerItems,
				items: navItems,
				selected: navSelectedIdx,
				onChanged: (index) { setState(() => navSelectedIdx = index); }
			)
		);
	}
}

class NavView extends StatefulWidget
{
	const NavView({super.key});

	@override
	State<StatefulWidget> createState() => _NavView();
}

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	SystemTheme.accentColor.load();

	final process = await Process.start(helperPath, []);
	await process.stdout.transform(utf8.decoder).forEach(stdardout.add);

	print(stdardout.join('\n'));
	stdardout.clear();
	
	// ask for storage permission
	await Permission.storage.request();
	await Permission.manageExternalStorage.request();
	
	prefs = await SharedPreferences.getInstance();
	selectedLanguage = (prefs.getInt('selectedLanguage') ?? 0);
	pinned = (prefs.getStringList('pinned') ?? []);
	favourites = (prefs.getStringList('favourites') ?? []);

	await SystemTheme.accentColor.load();

	runApp(MainApp());
}
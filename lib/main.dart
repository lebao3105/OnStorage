import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart' show GoRoute, GoRouter, GoRouterHelper;

import 'package:swifile/Home.dart';
import 'package:swifile/QueueLists.dart';
import 'package:swifile/Settings.dart';
import 'package:swifile/DirView.dart';
import 'package:swifile/Utilities.dart';


class _MainApp extends State<MainApp> {

	final _router = GoRouter(
		routes: [
			GoRoute(
				path: '/',
				builder: (ctxt, state) => const NavView()
			),
			GoRoute(
				path: '/settings',
				builder: (ctxt, state) => const SettingsPage()
			),
			GoRoute(
				path: '/settings/languages',
				builder: (ctxt, state) => LanguagesPage()
			)
		]
	);

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

		return FluentApp.router(
			title: "Swifile",
			debugShowCheckedModeBanner: true,
			routerConfig: _router,
			
			themeMode: ThemeMode.system,
			theme: FluentThemeData(fontFamily: 'Ubuntu'),
			darkTheme: FluentThemeData(fontFamily: 'Ubuntu'),

			builder: (ctx, w) => Directionality(
				textDirection: TextDirection.ltr,
				child: w!
			),
			// localizationsDelegates: const [
			// 	AppLocalizations.delegate,
			// 	GlobalMaterialLocalizations.delegate
			// ],
			// supportedLocales: AppLocalizations.supportedLocales
		);
	}
}


class _NavView extends State<NavView>
{
	
	final footerItems = [
		PaneItem(
			icon: const Icon(FluentIcons.settings),
			title: const Text('Settings'),
			body: const SettingsPage()
		)
	];

	final navItems = [
		PaneItem(
			icon: const Icon(FluentIcons.home),
			title: const Text('Home'),
			body: const HomePage()
		),
		PaneItem(
			icon: const Icon(FluentIcons.folder),
			title: const Text('Folder'),
			body: const DirView(path: 'C:\\Users\\lebao3105\\')
		),
		PaneItemHeader(header: const Text('Queue lists')),
		PaneItem(
			icon: const Icon(FluentIcons.copy),
			title: const Text('Copy'),
			body: const QueueList(type: QueueType.Copy),
			infoBadge: InfoBadge(source: Text(copyQueue.length.toString()))
		),

		PaneItem(
			icon: const Icon(FluentIcons.move),
			title: const Text('Move'),
			body: const QueueList(type: QueueType.Move),
			infoBadge: InfoBadge(source: Text(moveQueue.length.toString()))
		),

		PaneItem(
			icon: const Icon(FluentIcons.delete),
			title: const Text('Delete'),
			body: const QueueList(type: QueueType.Delete),
			infoBadge: InfoBadge(source: Text(delQueue.length.toString()))
		)
	];

	int selectedIdx = 0;

	@override
	Widget build(BuildContext context)
	{
		return NavigationView(
			appBar: const NavigationAppBar(title: Text('Swifile')),
			pane: NavigationPane(
				displayMode: PaneDisplayMode.auto,
				footerItems: footerItems,
				items: navItems,
				selected: selectedIdx,
				onChanged: (index) {
					setState(() => selectedIdx = index);
				}
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

class MainApp extends StatefulWidget
{
  const MainApp({super.key});

  @override
  _MainApp createState() => _MainApp();
}

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	
	// ask for storage permission
	await Permission.storage.request();
	await Permission.manageExternalStorage.request();
	
	prefs = await SharedPreferences.getInstance();
	selectedLanguage = (prefs.getInt('selectedLanguage') ?? 0);

	runApp(const MainApp());
}
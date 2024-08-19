import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:onstorage/UI/SettingPages/PersonalizationsView.dart';
import 'package:system_theme/system_theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import 'package:onstorage/UI/AboutView.dart';
import 'package:onstorage/UI/Favourites.dart';
import 'package:onstorage/UI/SettingPages/LanguagesView.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:onstorage/UI/Home.dart';
import 'package:onstorage/UI/QueueLists.dart';
import 'package:onstorage/UI/Settings.dart';
import 'package:onstorage/UI/DirView.dart';
import 'package:onstorage/Utilities.dart';


final shellNavKey = GlobalKey<NavigatorState>();
final rootNavKey = GlobalKey<NavigatorState>();
final _router = GoRouter(
	navigatorKey: rootNavKey,
	initialLocation: '/',
	// TODO: Rearrange
	routes: [
		StatefulShellRoute.indexedStack(
			builder: (_, __, child) => NavView(child: child),
			// navigatorKey: shellNavKey,
			branches: [
				StatefulShellBranch(
					routes: [
						GoRoute(
							path: '/',
							builder: (ctxt, state) => HomePage()
						),
					]
				),
				StatefulShellBranch(
					routes: [
						GoRoute(
							path: '/view',
							builder: (_, state) {
								return DirView(where: state.uri.queryParameters['where'] ?? homePath() ?? '/');
							}
						),
					]
				),
				StatefulShellBranch(
					routes: [
						GoRoute(
							path: '/favourites',
							builder: (_, __) => FavouritesList()
						),
					]
				),
				StatefulShellBranch(
					routes:
						QueueType.values.map(
							(e) => GoRoute(
								path: '/queue/${e.name.toLowerCase()}',
								builder: (_, __) => QueueList(type: e))
						).toList()
				),
				StatefulShellBranch(
					routes: [
						GoRoute(
							path: '/settings',
							builder: (ctxt, state) => SettingsPage(),
							routes: [
								GoRoute(
									path: 'languages',
									builder: (ctxt, state) => LanguagesPage()
								),
								GoRoute(
									path: 'personalizations',
									builder: (_, __) => PersonalizationsPage()
								)
							]
						),
					]
				),
				StatefulShellBranch(
					routes: [
						GoRoute(
							path: '/about',
							builder: (_, __) => AboutPage()
						)
					]
				),
			],
		)
	]
);

class MainApp extends StatelessWidget {

	@override
	Widget build(BuildContext context) {
		if (kIsWeb) {
			createDialog(
				context, 'Ain\'t no way',
				const Text(
					'We found you running this application in a browser. '
					'This application is not made to be used here yet.'
				),
				[
					Button(
						child: const Text('Ok, just let me go around'),
						onPressed: () => context.pop()
					),
					Button(
						child: const Text('Quit'),
						onPressed: () => exit(0)
					)
				]
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
			supportedLocales: AppLocalizations.supportedLocales,
			locale: Locale(selectedLanguage)
		);
	}
}

class NavView extends StatefulWidget
{
	const NavView({super.key, required this.child});

	final StatefulNavigationShell child;

	@override
	State<StatefulWidget> createState() => _NavView();
}

class _NavView extends State<NavView>
{

	late final loc = AppLocalizations.of(context)!;

	/// Creates a navigation pane item
	/// Additional callback will be called
	/// after this.context goes to the target path.
	PaneItem createNavPaneItem(
		String title, IconData icon, String path,
		{Function? additionalCallback, InfoBadge? badge})
	{
		return PaneItem(
			key: Key(path),
			title: createText(title),
			icon: Icon(icon),
			body: const SizedBox.shrink(),
			onTap: () {
				if (GoRouterState.of(context).uri.toString() != path)
					{ context.go(path); }
				additionalCallback?.call();
			},
			infoBadge: badge
		);
	}

	/// Finds the current pane index, using the current pane body's URI.
	int findNavSelectedIndex()
	{
		final location = GoRouterState.of(context).uri.toString();
    final allItems =
			(navItems + footerItems)
				..removeWhere(
					(item) {
						// print('${item.key.toString()} ${item.key == null}');
						return (item.key == null);
					}
				);

		/// Note: Key.toString() returns a weird format like this:
		/// [<'/view?where=/usr/share/applications'>]

    int ret = allItems.indexWhere(
			(item) {
				// print(location);
				// print(location.startsWith('/settings'));
				// print(location.startsWith('/view'));
				// print(Key(location) == item.key);

				final itemKey = item.key.toString()
																.replaceFirst('[<\'', '')
																.replaceFirst('\'>]', '');

				return (item.key == Key(location))
				|| location.commonPrefixWithAnother(itemKey) == '/view'
				|| location.commonPrefixWithAnother(itemKey) == '/settings'
				|| location.commonPrefixWithAnother(itemKey) == '/queue';
			}
		);

		return (ret != -1) ? ret : 0;
	}

	late final footerItems = [
		createNavPaneItem(loc.settings, FluentIcons.settings, '/settings'),
		createNavPaneItem(loc.settings_about, FluentIcons.info, '/about')
	];

	late final navItems = [
		createNavPaneItem(
			loc.home,
			FluentIcons.home,
			'/'
		),
		createNavPaneItem(
			'Folder',
			FluentIcons.folder,
			'/view?where=${changes.currDir}'
		),
		createNavPaneItem(
			'Favourites',
			FluentIcons.favorite_list,
			'/favourites',
			badge: InfoBadge(source: Text(favourites.length.toString()))
		),

		PaneItemSeparator(),

		PaneItemHeader(header: createText(loc.queue)),

		createNavPaneItem(
			loc.copy,
			FluentIcons.copy,
			'/queue/copy',
			badge: InfoBadge(source: Text(copyQueue.length.toString()))
		),

		createNavPaneItem(
			loc.move,
			FluentIcons.move,
			'/queue/move',
			badge: InfoBadge(source: Text(moveQueue.length.toString()))
		),

		createNavPaneItem(
			loc.trash,
			FluentIcons.delete,
			'/queue/delete',
			badge: InfoBadge(source: Text(delQueue.length.toString()))
		)
	];
	
	@override
	Widget build(BuildContext context)
	{
		return ListenableBuilder(
			listenable: changes,
			builder: (ctxt, _) =>
				NavigationView(
					appBar:
						NavigationAppBar(
							automaticallyImplyLeading: false,
							leading: null,
							title: null,
							actions:
								(Platform.isLinux || Platform.isMacOS || Platform.isWindows)
									? WindowCaption()
									: null
						),

					/* End NavigationAppBar - NavigationView [appBar] */

					paneBodyBuilder: (item, child) {
						// From FluentUI's example
						final name =
            	item?.key is ValueKey ? (item!.key as ValueKey).value : null;
						return FocusTraversalGroup(
							key: ValueKey('body$name'),
							child: widget.child,
						);
					},

					/* End NavigationView's paneBodyBuilder */

					pane: NavigationPane(
						displayMode: PaneDisplayMode.auto,
						items: navItems,
						footerItems: footerItems,
						selected: findNavSelectedIndex()
					)

					/* End NavigationPane - NavigationView [pane] */
				)

			/* End NavigationView */
		);
	}
}


void main() async
{
	WidgetsFlutterBinding.ensureInitialized();
	await SystemTheme.accentColor.load();

	// Load settings
	prefs = await SharedPreferences.getInstance();
	selectedLanguage = (prefs.getString('selectedLanguage') ?? 'en');
	pinned = (prefs.getStringList('pinned') ?? []);
	favourites = (prefs.getStringList('favourites') ?? []);
	windowEffect = (prefs.getString('windowEffect') ?? 'disabled');

	if (Platform.isLinux || Platform.isMacOS || Platform.isWindows)
	{
		await flutter_acrylic.Window.initialize();
		if (Platform.isWindows)
		{ await flutter_acrylic.Window.hideWindowControls(); }

		await windowManager.ensureInitialized();
		windowManager.waitUntilReadyToShow(
			const WindowOptions(
				windowButtonVisibility: false,
				titleBarStyle: TitleBarStyle.hidden
			),
			
			() async {
				await windowManager.show();
				await windowManager.focus();
			}
		);

		await flutter_acrylic.Window.setEffect(
			effect: getFunctions.getByString(windowEffect)
		);
	}
	
	// ask for storage permissions
	if (Platform.isAndroid || Platform.isWindows || Platform.isIOS)
	{
		await Permission.storage.request();
		await Permission.manageExternalStorage.request();
	}
	

	runApp(MainApp());
}

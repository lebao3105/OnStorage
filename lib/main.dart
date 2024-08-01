import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:onstorage/UI/AboutView.dart';
import 'package:onstorage/UI/LanguagesView.dart';
import 'package:onstorage/UI/Utilities.dart';
import 'package:system_theme/system_theme.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

import 'package:onstorage/Home.dart';
import 'package:onstorage/QueueLists.dart';
import 'package:onstorage/Settings.dart';
import 'package:onstorage/DirView.dart';
import 'package:onstorage/Utilities.dart';


	final shellNavKey = GlobalKey<NavigatorState>();
	final rootNavKey = GlobalKey<NavigatorState>();
	final _router = GoRouter(routes: [
		ShellRoute(
			builder: (_, __, ___) => const NavView(),
			navigatorKey: shellNavKey,
			routes: [
				GoRoute(
					path: '/',
					builder: (ctxt, state) { changes.navSelectedIdx = 0; return HomePage(); }
				),
				GoRoute(
					path: '/settings',
					builder: (ctxt, state) => SettingsPage(),
				),
				GoRoute(
					path: '/settings/languages',
					builder: (ctxt, state) => LanguagesPage()
				),
				GoRoute(
					path: '/queue',
					builder: (_, state) => QueueList(type: QueueType.getByString(state.pathParameters['which']!))
				),
				GoRoute(
					path: '/view',
					builder: (_, state) => DirView(where: state.pathParameters['where'] ?? homePath() ?? '/')
				),
				GoRoute(
					path: '/about',
					builder: (_, __) => AboutPage()
				)
			]
		)
	]
	, navigatorKey: rootNavKey
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
						onPressed: () { context.pop(); }
					),
					Button(
						child: const Text('Quit'),
						onPressed: () { exit(0); }
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
			locale: AppLocalizations.supportedLocales[selectedLanguage]
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
				body: SettingsPage(),
			),
			PaneItem(
				icon: const Icon(FluentIcons.info),
				title: createText(loc.settings_about),
				body: AboutPage(),
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
				body: DirView(where: 'C:\\Windows\\System32')
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

		return ListenableBuilder(
			listenable: changes,
			builder: (ctxt, _) => NavigationView(
				appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          leading: null,
					title: null,
					actions: WindowCaption(
						title:
							changes.showDirBar ? CommandBar(
								overflowBehavior: CommandBarOverflowBehavior.noWrap,
								primaryItems: [
									
									// Back
									CommandBarBuilderItem(
										builder: (_, __, w) => Tooltip(message: 'Go back', child: w),
										wrappedItem: CommandBarButton(
											icon: const Icon(FluentIcons.back),
											onPressed: () {}
										)
									),

									// Forward
									CommandBarBuilderItem(
										builder: (_, __, w) => Tooltip(message: 'Go forward', child: w),
										wrappedItem: CommandBarButton(
											icon: const Icon(FluentIcons.forward),
											onPressed: () {}
										)
									),

									// Go up
									CommandBarBuilderItem(
										builder: (_, __, w) => Tooltip(message: 'Go up', child: w),
										wrappedItem: CommandBarButton(
											icon: const Icon(FluentIcons.up),
											onPressed: () => changes.currDir = "${changes.currDir}/.."
										)
									),

									// Refresh
									CommandBarBuilderItem(
										builder: (_, __, w) => Tooltip(message: 'Refresh', child: w),
										wrappedItem: CommandBarButton(
											icon: const Icon(FluentIcons.back),
											onPressed: () => setState(() {})
										)
									),

									// Create button
									CommandBarBuilderItem(
										builder: (_, __, w) => Tooltip(message: "Create something new", child: w),
										wrappedItem: CommandBarButton(
											icon: const Icon(FluentIcons.add),
											onPressed: () {
												String input = "";
												createDialog(
													context, 'Create a new file or folder',
													Column(
														mainAxisSize: MainAxisSize.min,
														children: [
															InfoLabel(
																label: 'Enter the relative path of the new item to be created',
																child: TextBox(
																	expands: false, maxLines: null, autocorrect: false,
																	showCursor: true, autofocus: true, onChanged: (value) => input = value
																),
															)
														]
													),
													[
														Button(child: createText('New file'), onPressed: () => setState(() => createNew(input, true))),
														Button(child: createText('New folder'), onPressed: () => setState(() => createNew(input, false))),
														FilledButton(child: createText('Cancel'), onPressed: () => context.pop())
													]
												);
											}
										)
									),

									// Delete button
									CommandBarBuilderItem(
										builder: (_, __, w) => Tooltip(message: 'Delete selected item(s)', child: w),
										wrappedItem: CommandBarButton(
											icon: const Icon(FluentIcons.delete),
											onPressed: () {}
										)
									),

									// The rest goes here...
								],
							) : null
					)

					/* End Window Caption - NavigationAppBar [actions] */
				),

				/* End NavigationAppBar - NavigationView [appBar] */

				pane: NavigationPane(
					displayMode: PaneDisplayMode.auto,
					items: navItems,
					footerItems: footerItems,
					selected: changes.navSelectedIdx,
					onChanged: (index) => setState(() => changes.navSelectedIdx = index)
				)

				/* End NavigationPane - NavigationView [pane] */
			)

			/* End NavigationView */
		);
	}
}

class NavView extends StatefulWidget
{
	const NavView({super.key});

	@override
	State<StatefulWidget> createState() => _NavView();
}

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await SystemTheme.accentColor.load();

	if (Platform.isLinux || Platform.isMacOS || Platform.isWindows)
	{
		await windowManager.ensureInitialized();
		windowManager.waitUntilReadyToShow(
			const WindowOptions(
				windowButtonVisibility: false,
				titleBarStyle: TitleBarStyle.hidden
			), () async {
				await windowManager.show();
				await windowManager.focus();
			}
		);
	}
	
	// ask for storage permissions
	await Permission.storage.request();
	await Permission.manageExternalStorage.request();
	
	prefs = await SharedPreferences.getInstance();
	selectedLanguage = (prefs.getInt('selectedLanguage') ?? 0);
	pinned = (prefs.getStringList('pinned') ?? []);
	favourites = (prefs.getStringList('favourites') ?? []);

	runApp(MainApp());
}
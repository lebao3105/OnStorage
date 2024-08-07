# OnStorage

A file manager written in Dart with Flutter toolkit. It offers (TODOs included):

* WinUI 3 style

* Queue lists for Copy, Move and Pernament Delete (Trash)!

* Quick jump (not now)

* Ability to switch between list view and tree view (on work, it sucks)

* Tabbed

This project is in very initial state, and objects to change.

## Build and run from source

Install Flutter as well as make.

Clone this repository, run one or more of the following:

Generate icon for platforms (only need to run once): `make gen_icons`

Generate build informations file: `make gen_infos`

Build: `make build`

Clean: `make clean`

Run: `make run`

Generate localizations: `flutter gen_l10n`

Modifiable environment variables:

<table>
	<tr>
		<th>Name</th>
		<th>Usage</th>
	</tr>
	<tr>
		<td>FFLAGS</td>
		<td>Flutter build flags. Default specifies the build target</td>
	</tr>
	<tr>
		<td>RFLAGS</td>
		<td>Flutter run flags. Default specifies the target device</td>
	</tr>
	<tr>
		<td>TARGET</td>
		<td>Flutter build target.</td>
	</tr>
	<tr>
		<td>DEVICE</td>
		<td>Target device id (run flutter devices to obtain)</td>
	</tr>
</table>

> Note: Make sure both FFLAG and RFLAGS points to the same build type (debug, release, profile)!

# Licenses

The license for this project is [here](LICENSE).

The license for Ubuntu font is [here](fonts/UFL.txt).

All other used softwares, dependencies have their licenses placed in Settings -> About -> Licenses.

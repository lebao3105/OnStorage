# Flutter build flags
FFLAGS := $(TARGET)

# Flutter run flags
RFLAGS := -d $(DEVICE)

# Project infos
HOMEPAGE=`git remote get-url --push origin`
APPVER=`dart run get-app-ver.dart`

.PHONY: build run gen_icons

gen_icons:
	dart run flutter_launcher_icons

gen_infos:
	echo "const HOMEPAGE='$(HOMEPAGE)';" > lib/Infos.dart 2>&1
	echo "const APPVER='$(APPVER)';" >> lib/Infos.dart 2>&1

build:
	flutter build $(FFLAGS)

run:
	flutter run $(RFLAGS)

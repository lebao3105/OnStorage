.PHONY: build run

build:
	$(CC) RootHelper/Helper.cpp -o lib/Helper
	flutter build

run: build
	flutter run

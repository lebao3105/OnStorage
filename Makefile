# Flutter build flags
FFLAGS := $(TARGET)

# Flutter run flags
RFLAGS := -d $(DEVICE)

.PHONY: build run gen_icons

gen_icons:
	dart run flutter_launcher_icons

build:
	$(CXX) lib/helper/helper.cpp -o lib/helper/helper -std=c++17
	mv lib/helper/helper.exe lib/helper/helper
	# flutter build $(FFLAGS)

run: build
	flutter run $(RFLAGS)

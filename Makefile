all: docker-image

.PHONY: docker-image
docker-image:
	docker build -t gid-android-builder docker

.PHONY: docker-run
docker-run: docker-image
	docker run --rm -it -v $$(pwd):/build -w /build -u $$(id -u):$$(id -g) gid-android-builder /bin/bash

.PHONY: android-build
android-build:
	dub build --deep --arch=aarch64-linux-android --compiler=ldc2 --build=debug
	dub build --deep --arch=x86_64-linux-android --compiler=ldc2 --build=debug
	pixiewood prepare -s ${ANDROID_HOME} -a ~/mini-studio/ pixiewood.xml
	pixiewood generate
	pixiewood build

.PHONY: clean
clean:
	@rm -rf .buildconfig .pixiewood dub.selections.json gidandroidapp subprojects

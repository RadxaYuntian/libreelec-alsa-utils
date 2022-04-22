MAKEFLAGS += --silent

NAME = $(shell cat NAME)
VERSION = $(shell cat VERSION)
URL = https://github.com/radxa-pkg/libreelec-alsa-utils
DESCRIPTION = ALSA helper from LibreELEC

all:
	cd ./src && \
	git config --get user.name || git config user.name "Radxa" && \
	git config --get user.email || git config user.email "dev@radxa.com" && \
	git am ../*.patch && \
	cd ..

	rm -rf ./.deb-pkg/
	mkdir -p ./.deb-pkg/usr/lib/udev/rules.d/
	cp ./src/packages/audio/alsa-utils/scripts/soundconfig ./.deb-pkg/usr/lib/udev
	cp ./src/packages/audio/alsa-utils/udev.d/90-alsa-restore.rules ./.deb-pkg/usr/lib/udev/rules.d
	
	fpm -s dir -t deb -n $(NAME) -v $(VERSION) \
		-a all \
		--depends dthelper \
		--deb-priority optional --category admin \
		--deb-field "Multi-Arch: foreign" \
		--deb-field "Replaces: $(NAME)" \
		--deb-field "Conflicts: $(NAME)" \
		--deb-field "Provides: $(NAME)" \
		--url $(URL) \
		--description "$(DESCRIPTION)" \
		--license "GPL-2+" \
		-m "Radxa <dev@radxa.com>" \
		--vendor "Radxa" \
		--force \
		./.deb-pkg/=/

	rm -rf ./.deb-pkg/
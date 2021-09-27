.PHONY: help
help:
	@echo "available targets -->\n"
	@cat Makefile | grep ".PHONY" | grep -v ".PHONY: _" | sed 's/.PHONY: //g'


.PHONY: build-podman
build-podman:
	cat ./Dockerfile.template | \
		sed "s/__PYTHON_VERSION__/$$(cat .python-version)/g" | \
	tee ./Dockerfile;
	podman build . -t daxxog/rocketchat-notifier:latest
	rm ./Dockerfile


.PHONY: tag
tag: build-podman
	podman tag daxxog/rocketchat-notifier:latest daxxog/rocketchat-notifier:$$(cat BUILD_NUMBER)
	@echo podman tag daxxog/rocketchat-notifier:latest daxxog/rocketchat-notifier:$$(cat BUILD_NUMBER)


.PHONY: release
release: version-bump
	make tag
	podman push daxxog/rocketchat-notifier:latest 
	podman push daxxog/rocketchat-notifier:$$(cat BUILD_NUMBER)
	git add BUILD_NUMBER
	git commit -m "built rocketchat-notifier@$$(cat BUILD_NUMBER)"
	git push
	git tag -a "$$(cat BUILD_NUMBER)" -m "tagging version $$(cat BUILD_NUMBER)"
	git push origin $$(cat BUILD_NUMBER)


.PHONY: version-bump
version-bump:
	dc --version
	touch BUILD_NUMBER
	echo "$$(cat BUILD_NUMBER) 1 + p" | dc | tee _BUILD_NUMBER
	mv _BUILD_NUMBER BUILD_NUMBER


.PHONY: debug-podman
debug-podman: build-podman
	podman run -i -t \
	--entrypoint /bin/bash \
	daxxog/rocketchat-notifier

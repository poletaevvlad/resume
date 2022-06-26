resume.pdf: _build/base.html _build/styles.css
	chromium --headless \
		--print-to-pdf=$(shell pwd)/resume.pdf \
		--print-to-pdf-no-header \
		--run-all-compositor-stages-before-draw \
		--virtual-time-budget=100000 \
		--allow-file-access-from-files \
		./_build/base.html

_build/base.html: base.pug resume.pug
	mkdir -p _build
	./node_modules/.bin/pug base.pug -o _build

_build/styles.css: $(wildcard styles/*.sass)
	mkdir -p _build
	./node_modules/.bin/sass styles/styles.sass:_build/styles.css

%PHONY: watch
watch: resume.pdf
	while true; do \
		inotifywait -e close_write *.pug styles/*.sass icons/*.svg;\
		make;\
	done


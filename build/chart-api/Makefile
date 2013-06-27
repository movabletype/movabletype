all:
	make clean
	make build

clean:
	-rm -rf dist
	-rm -rf node_modules
	-find . -name '.DS_Store' | xargs rm

build:
	-npm install
	-grunt build

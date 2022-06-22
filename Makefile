.ONESHELL:
SHELL := /bin/bash

nbprocess:
	nbprocess_export

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

sync: ## Propagates any change in the modules (.py files) to the notebooks that created them 
	nbprocess_update

deploy: docs ## Push local docs to gh-pages branch
	nbprocess_ghp_deploy

preview: .install ## Live preview quarto docs with hot reloading.
	nbprocess_sidebar
	IN_TEST=1 &&  nbprocess_quarto --preview

docs: .FORCE ## Build quarto docs and put them into folder specified in `doc_path` in settings.ini
	nbprocess_export
	nbprocess_quarto

docs: .install
	nbprocess_quarto
	
test: ## Test notebooks
	nbprocess_test

release_all: pypi conda_release ## Release python package on pypi and conda.  Also bumps version number automatically.
	nbdev_bump_version

release_pypi: pypi ## Release python package on pypi.  Also bumps version number automatically.
	nbdev_bump_version

conda_release:
	fastrelease_conda_package

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist
	
install: install_quarto ## Install quarto and the latest version of the local python pckage as an editable install
	pip install -e ".[dev]"

.install: install_quarto nbprocess
	pip install -e .[dev]
	touch .install

install_quarto:
	./install_quarto.sh

.FORCE:


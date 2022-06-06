.ONESHELL:
SHELL := /bin/bash
.DEFAULT_GOAL := help

sync:
	nbprocess_update

deploy: docs
	nbprocess_ghp_deploy

preview:
	nbprocess_sidebar
	quarto preview

docs: .FORCE
	nbprocess_export
	nbprocess_quarto

prepare: test
	nbprocess_clean
	nbprocess_export

test:
	nbprocess_test

release_all: pypi conda_release
	nbdev_bump_version

release_pypi: pypi
	nbdev_bump_version

conda_release:
	fastrelease_conda_package

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist
	
install: install_quarto
	pip install -e .

install_quarto: .FORCE
	./install_quarto.sh


.FORCE:

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

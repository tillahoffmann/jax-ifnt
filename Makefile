.PHONY : dist docs doctests lint tests

all : dist docs doctests lint tests

requirements.txt : requirements.in pyproject.toml
	pip-compile -v

lint :
	black --check .

doctests :
	sphinx-build -b doctest . docs/_build

docs :
	rm -rf docs/_build
	sphinx-build -nW --keep-going . docs/_build

tests :
	pytest -v --cov=ifnt --cov-report=term-missing

dist : README.rst
	python -m build
	twine check dist/*.tar.gz dist/*.whl

README.rst : index.rst
	echo ".. This file is generated from index.rst and should not be modified directly.\n" > $@
	sed \
	-e 's/:mod:/:code:/g' \
	-e 's/^.. toctree::/.. End of autogenerated file./g' \
	-e '/^.. End of autogenerated file./q' \
	$< >> $@

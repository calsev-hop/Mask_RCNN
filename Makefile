
SHELL := /bin/bash
VENV := .venv
SYS_PY := /usr/local/pyenv/versions/3.9.9/bin/python

ACTIVATE := source "./$(VENV)/bin/activate"
PIP := pip install --upgrade

env-create:
	$(SYS_PY) -m venv $(VENV)
	$(ACTIVATE) && \
	$(PIP) pip && \
	$(PIP) wheel && \
	$(PIP) setuptools

env-update:
	$(ACTIVATE) && \
	$(PIP) -r requirements.txt

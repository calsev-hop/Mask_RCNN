
SHELL := /bin/bash
VENV := .venv
SYS_PY := /usr/local/pyenv/versions/3.9.9/bin/python
LINT_PATH := mask.py

ACTIVATE := source "./$(VENV)/bin/activate"
PIP := pip install --upgrade
SYNC := rsync -av --delete-before

HOST := ec2-35-172-250-77.compute-1.amazonaws.com

env-create:
	$(SYS_PY) -m venv $(VENV)
	$(ACTIVATE) && \
	$(PIP) pip && \
	$(PIP) wheel && \
	$(PIP) setuptools

env-update:
	$(ACTIVATE) && \
	$(PIP) -r requirements.txt && \
	python3 setup.py install

lint:
	python -m black $(LINT_PATH)
	python -m isort $(LINT_PATH)

login:
	ssh ubuntu@$(HOST)

sync:
	$(SYNC) \
		-e ssh \
		--exclude '.git/' \
		--exclude '.idea/' \
		--exclude '.venv/' \
		--exclude '.vscode/' \
		./ ubuntu@$(HOST):~/mask_rcnn

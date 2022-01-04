
SHELL := /bin/bash
VENV := .venv

ACTIVATE := source "./$(VENV)/bin/activate"
LINT_PATH := mask.py
PIP := pip install --upgrade
PYENV_ROOT := /usr/local/pyenv
PY_VER := 3.7.12
PKG := apt-get -y install
SYNC := rsync -av --delete-before
SYS_PY := $(PYENV_ROOT)/versions/$(PY_VER)/bin/python

HOST := ec2-35-172-250-77.compute-1.amazonaws.com

pyenv-dep:
	sudo apt-get update
	sudo $(PKG) make build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

pyenv-var:
	echo export PYENV_ROOT=$(PYENV_ROOT) | sudo tee /etc/profile.d/pyenv.sh
	echo export PATH="\$$PYENV_ROOT/bin:\$$PATH" | sudo tee -a /etc/profile.d/pyenv.sh
	echo "eval $$(pyenv init - --no-rehash)" | sudo tee -a /etc/profile.d/pyenv.sh
	sudo chmod +x /etc/profile.d/pyenv.sh
	sudo /etc/profile.d/pyenv.sh

pyenv-install:
	sudo git clone https://github.com/pyenv/pyenv $(PYENV_ROOT)
	cd $(PYENV_ROOT) && sudo src/configure && sudo make -C src

# sudo this
pyenv-create:
	. /etc/profile.d/pyenv.sh && pyenv install $(PY_VER)

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
		--exclude '**/__pycache__/' \
		--exclude '.venv/' \
		--exclude '.vscode/' \
		./ ubuntu@$(HOST):~/mask_rcnn

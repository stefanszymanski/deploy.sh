BINDIR = $$HOME/.local/bin
ZSHCOMPDIR = $$HOME/.local/share/zsh/completion

install:
	mkdir -p ${BINDIR}
	cp deploy ${BINDIR}/

uninstall:
	rm ${BINDIR}/deploy

install-zsh-completion:
	mkdir -p ${ZSHCOMPDIR}
	cp completion/_deploy.zsh ${ZSHCOMPDIR}/

uninstall-zsh-completion:
	rm ${ZSHCOMPDIR}/_deploy.zsh

.PHONY: install install-zsh-completion uninstall uninstall-zsh-completion

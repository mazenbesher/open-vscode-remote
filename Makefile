proj = open-vscode-remote

init:
	bun create vite@latest
	cd $(proj); bun add --dev vite-plugin-singlefile

install:
	cd $(proj); bun install

dev:
	cd $(proj); bun run dev

build:
	cd $(proj); bun run build

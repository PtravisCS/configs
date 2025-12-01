#!/bin/bash

exts=('asvetliakov.vscode-neovim'
	'bmewburn.vscode-intelephense-client'
	'dbaeumer.vscode-eslint'
	'gruntfuggly.todo-tree'
	'ms-dotnettools.csdevkit'
	'ms-dotnettools.csharp'
	'ms-dotnettools.vscode-dotnet-runtime'
	'ms-vscode.cmake-tools'
	'ms-vscode.cpptools'
	'ms-vscode.cpptools-extension-pack'
	'ms-vscode.cpptools-themes'
	'murloccra4ler.leap'
	'pkief.material-icon-theme'
	'redhat.java'
	'shevaua.phpcs'
	'theqtcompany.qt'
	'theqtcompany.qt-core'
	'theqtcompany.qt-cpp'
	'theqtcompany.qt-qml'
	'theqtcompany.qt-ui'
	'twxs.cmake'
	'visualstudioexptteam.intellicode-api-usage-examples'
	'visualstudioexptteam.vscodeintellicode'
	'vscjava.vscode-gradle'
	'vscjava.vscode-java-debug'
	'vscjava.vscode-java-dependency'
	'vscjava.vscode-java-pack'
	'vscjava.vscode-java-test'
	'vscjava.vscode-maven'
	'waderyan.gitblame'
	'yatki.vscode-surround'
)

for t in "${exts[@]}"; do
	printf 'Installing %s\n' "$t"
	code --install-extension "$t"
done

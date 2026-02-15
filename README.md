# minimus

> small tools. big impact. zero bloat.

![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/platform-windows%20%7C%20linux%20%7C%20macos-lightgrey)

**minimus** provides a suite of universal tools to manage your projects without bloat.

## tools

### 1. `bootstrap`

one command to set up **ANY** repo. detects project type and runs install/build commands.

### 2. `cleanall`

recursively removes build artifacts (`node_modules`, `dist`, `target`, etc.) to free up space.

### 3. `score`

gamifies your code health. calculates a complexity score based on file count and lines of code.

### 4. `readme`

scans project and generates a `README.md` with install/run instructions based on project type.

### 5. `guard`

pre-commit safety. scans staged files for large files (>50mb), forbidden files (.env, keys), and potential secrets.

### 6. `doctor`

checks your environment for core tools (git, node, docker) and verifies project consistency.

### 7. `depsize`

visualizes dependency weight. shows size of `node_modules` or `venv` packages.

## supported projects (bootstrap)

minimus automatically detects the following files and runs the corresponding commands:

| detected file      | project type | command run                           |
| :----------------- | :----------- | :------------------------------------ |
| `package.json`     | **node.js**  | `npm install`                         |
| `requirements.txt` | **python**   | creates `venv` & `pip install -r ...` |
| `pyproject.toml`   | **python**   | `poetry install` (or `pip install .`) |
| `Cargo.toml`       | **rust**     | `cargo build`                         |
| `go.mod`           | **go**       | `go mod tidy`                         |
| `Dockerfile`       | **docker**   | `docker build -t .`                   |

## installation

### automatic install (recommended)

**windows (powershell)**:

```powershell
./install.ps1
```

**linux / macos**:

```bash
chmod +x install.sh
./install.sh
```

### manual install

#### windows

#### windows

add the `minimus` folder to your PATH, or copy individual scripts (e.g., `bootstrap/bootstrap.ps1`) to a folder in your PATH.

#### linux / macos

make the scripts executable and link them:

```bash
chmod +x bootstrap/bootstrap.sh
ln -s $(pwd)/bootstrap/bootstrap.sh /usr/local/bin/bootstrap
```

## philosophy

small projects ("minimus") shouldn't require big setups. this tool keeps it simple.

## license

MIT

# vim-go cheat sheet

## Completion
| Keys | What it does |
|---|---|
| `Ctrl-x Ctrl-o` | Trigger completion popup |
| `Ctrl-n` / `Ctrl-p` | Next / previous suggestion |
| `Enter` | Confirm selection |

## Navigation
| Command | What it does |
|---|---|
| `:GoDef` | Jump to definition |
| `:GoDefPop` | Jump back |
| `:GoDoc` | Show docs for symbol under cursor |
| `:GoDecls` | List all funcs/types in file |
| `:GoDeclsDir` | List all funcs/types in package |

## Editing
| Command | What it does |
|---|---|
| `:GoFmt` | Format file (also runs on save) |
| `:GoImport [pkg]` | Add an import |
| `:GoImports` | Auto-organize imports |
| `:GoImpl [recv] [type] [interface]` | Generate interface stubs |
| `:GoFillStruct` | Fill struct literal with zero values |
| `:GoIfErr` | Insert `if err != nil` block |
| `:GoAddTags [tags]` | Add struct field tags |
| `:GoRemoveTags [tags]` | Remove struct field tags |

## Build & Test
| Command | What it does |
|---|---|
| `:GoBuild` | Build package, errors in quickfix |
| `:GoInstall` | `go install` |
| `:GoTest` | Run tests |
| `:GoCoverageToggle` | Highlight test coverage in buffer |
| `:GoGenerate` | Run `go generate` |

## Analysis
| Command | What it does |
|---|---|
| `:GoInfo` | Show type of symbol under cursor |
| `:GoImplements` | Show interfaces a type satisfies |
| `:GoCallers` | Show callers of current function |
| `:GoLint` | Run golint |
| `:GoDiagnostics` | Show gopls diagnostics |

## Debugger (requires delve)
| Command | What it does |
|---|---|
| `:GoDebugStart` | Start debugger |
| `:GoDebugBreakpoint` | Toggle breakpoint on current line |
| `:GoDebugContinue` | Continue execution |
| `:GoDebugNext` | Step over |
| `:GoDebugStep` | Step into |
| `:GoDebugStepOut` | Step out |
| `:GoDebugPrint {expr}` | Evaluate expression |
| `:GoDebugStop` | Stop debugger |

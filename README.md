# nvim-lspconfig-test
NOTE: this repo is currently under review before upstreaming to `nvim-lua` -- please wait until then to contribute!

Tests for configurations implemented in [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig).

This repo's tests are run on a nightly basis, and config-specific issues are created/closed automatically when tests fail/pass.

## Why test?
Much like `neovim/nvim-lspconfig`, this repo is community-driven. We highly recommend adding tests for your language server to it! Doing so will:

1. Protect your config from changes to `neovim/nvim-lspconfig`, as we will run these tests to make sure we don't break anything
2. Because of the above, make fixes/refactoring easier on our end
3. Let you know automatically when/if your language server (or something else) changes which breaks compatability with `nvim`

along with all of the other benefits of having well-tested code!

## Adding tests

1. In [`.github/workflows/default.yml`](.github/workflows/default.yml), add the name of your config to `jobs.default.strategy.matrix.config`.
2. Create a folder with your language server's name in the `tests/` directory.
3. Add the following files to it:
- `issue_body`: the body of the issue that will be automatically created if your tests fail. Feel free to @ yourself and other maintainers here.
- `setup.sh`: code to set up your language server on a new machine. This should "formalize" the steps described in [CONFIG.md](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md) for your language server. See [`tests/leanls/setup.sh`](tests/leanls/setup.sh) for an example.
- `test.sh`: code that actually runs your tests. This should exit 0 iff all of your tests succeed. See [`tests/leanls/test.sh`](tests/leanls/test.sh) for an example. As done there, we recommend using `nvim-lua/plenary.nvim`'s `busted`-style testing to write these tests (see [`tests/leanls/tests/lsp_spec.lua`](tests/leanls/tests/lsp_spec.lua)), initializing with the given `minimal_init.lua`.  Some helper functions are provided in [`nvim-lspconfig-test/lua/test/helpers.lua`](nvim-lspconfig-test/lua/test/helpers.lua) (available to your tests via `require'test.helpers'`).

## Running locally

Assuming all of your language server's necessary software is installed, just do:
```text
TEST=<test_name> make test
```
where `<test_name>` is the name of your config.

## Contributing

Feel free to make a PR title-prefixed with `[WIP]` as soon as you start working on your tests. Remove the `[WIP]` when you're ready for review.

## Fixing problems

An issue titled for your language server will automatically be created if your tests fail on a run. *Do not* close these issues manually! They will be automatically closed on a subsequent run where your tests pass.

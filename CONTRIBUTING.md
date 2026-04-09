# Contributing to obsidian-skill

Thank you for your interest in contributing!

## How to Contribute

### Reporting Bugs

1. Open an issue using the [Bug Report template](./.github/ISSUE_TEMPLATE/bug_report.md)
2. Include your Obsidian version, Claude Code version, and OS
3. Describe the expected vs actual behavior
4. Include any relevant logs or error messages

### Suggesting Features

1. Open an issue using the [Feature Request template](./.github/ISSUE_TEMPLATE/feature_request.md)
2. Describe the use case and why it would be valuable
3. If possible, reference the [Obsidian CLI documentation](https://help.obsidian.md/Obsidian/Command+line+interface)

### Adding New Commands

The skill documents Obsidian CLI commands in `plugin/skills/obsidian/references/command-reference.md`. To add a new command:

1. Find the relevant section in the reference file
2. Add the command with syntax and a brief description
3. If adding a full section, also update `SKILL.md` under the appropriate heading
4. Submit a PR with the changes

### Adding Workflow Examples

Real-world automation examples live in `docs/workflows/`. To add one:

1. Create a new `.md` file in `docs/workflows/`
2. Describe the problem, the commands used, and the expected outcome
3. Keep it focused — one workflow per file

### Testing Changes

Since this skill drives Claude Code via the Obsidian CLI, testing requires:

1. A local Obsidian vault with CLI enabled (Settings → Command line interface → Toggle ON)
2. Obsidian app running
3. Clone the repo and load it directly:

```bash
git clone https://github.com/lim1202/obsidian-skill
cd obsidian-skill
# In Claude Code:
/plugin install obsidian-skill
```

4. Try the commands described in your change
5. Verify sandbox bypass (`dangerouslyDisableSandbox: true`) works if you added new Bash calls

### Pull Request Process

1. Fork the repo and create a branch: `git checkout -b feat/my-new-feature`
2. Make your changes
3. Commit with a clear message: `git commit -m "feat: add X command"`
4. Push and open a PR against `main`
5. Respond to review feedback

## Code of Conduct

Please follow our [Code of Conduct](./CODE_OF_CONDUCT.md) in all interactions.

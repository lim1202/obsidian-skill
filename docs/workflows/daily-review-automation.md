# Daily Review Automation

Automate your daily review workflow by creating a structured daily note with tasks pulled from your vault.

## Use Case

You want to start each day by reviewing open tasks, orphans, and unresolved links before planning your day.

## Workflow

### Step 1: Read yesterday's tasks

```bash
obsidian daily:read
```

### Step 2: Find all incomplete tasks

```bash
obsidian tasks
# Filter output for "[ ]" (unchecked) tasks
```

### Step 3: Append review to today's daily note

```bash
obsidian daily:append content="## $(date '+%Y-%m-%d') Daily Review\n\n### Open Tasks\n\n### Orphan Notes\n"
```

Then manually populate orphan list with:

```bash
obsidian orphans
```

### Step 4: Check for broken links

```bash
obsidian unresolved
```

### Step 5: List notes modified yesterday

```bash
obsidian files sort=modified
# Use grep to filter for yesterday's date
```

## Full Example

```bash
obsidian daily:append content="## $(date '+%Y-%m-%d') Daily Review
### Open Tasks
$(obsidian tasks | grep '\[ \]')
### Orphan Notes
$(obsidian orphans | head -10)
### Unresolved Links
$(obsidian unresolved | head -10)
"
```

## Tip

Schedule this with Claude Code's `/loop` command to run every morning automatically.

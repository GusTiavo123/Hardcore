---
description: Run a fast idea validation without human-in-the-loop pauses
---

# /validate:fast

Run the Hardcore Idea Validation pipeline without stopping for human confirmation.

## Usage

```
/validate:fast <describe your idea in natural language>
```

## What It Does

Same as `/validate:new` but:
- Skips all human-in-the-loop checkpoints
- Uses `concise` detail level for faster processing
- Runs the entire 6-department pipeline end-to-end

## When to Use

- Quick first-pass validation
- Batch validating multiple ideas
- When you already understand the idea well and don't need to review intermediate results

## Example

```
/validate:fast An AI-powered tool that automatically generates unit tests
from code comments and docstrings
```

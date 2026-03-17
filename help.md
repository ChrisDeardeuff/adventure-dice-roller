# Adventure Dice Roller Help

**ADR** is a Discord bot for multiple tabletop RPG systems!

## 🎲 Supported Systems
- **none** - Basic dice rolling
- **asoif** - A Song of Ice and Fire RPG
- **age** - Advanced Game Engine
- **dnd** - Dungeons & Dragons 5e
- **sf** - Stillfleet

## 📋 Commands

### System Management
- `/systems` - List available systems
- `/set-system` - Choose your system
- `/get-system` - View your current system

### Rolling Dice

**Basic (none):** `/roll xdy` - Roll x dice with y sides
- Example: `/roll 5d6` → `[6,3,5,1,1]`

**D&D (dnd):** `/roll xdy(modifier) (options)`
- Modifiers: `+`, `-`, `*`, `/` (e.g., `+3`, `/2`)
- Options: `a` (advantage), `d` (disadvantage)
- Example: `/roll 1d20+5 a` → `1d20+5 with advantage: [17] [10] + 5 = 22`

**ASOIF (asoif):** `/roll xby` - Roll x dice, keep highest x from x+y total
- Example: `/roll 5b6` → `Rolled: [6,6,6,5,5,3,2,1,1,1,1]. Highest 5: [6,6,6,5,5] = 28`

**AGE (age):** `/roll x` - Roll 3d6 with modifier x, checks for doubles/stunt points
- Example: `/roll 4` → `[4,1,4] + 4 = 13 and generated 4 stunt points!`

**Stillfleet (sf):** `/roll skill` - Roll d10 for skill (COM, MOV, REA, WIL, CHA)
- Supports modifiers and advantage/disadvantage
- Example: `/roll MOV+1` → `MOV d10: [9] + 1 = 10`
- Also supports standard 'non-system' rolls.
- Example: `/roll 2d6` → `[6,3]`

### Quick Rolls
- `/set-stillfleet-skills` - Save all skills, formatted as dice array. 
- Example: `/set-stillfleet-skills 10 8 8 6 6 4`
- `/set-qr num roll` - Save a roll (1-10)
- `/qr num` - Use saved roll (1-10)

Need more info? Check the [GitHub repository](https://github.com)!
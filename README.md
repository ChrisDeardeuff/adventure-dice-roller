# Adventure Dice Roller

The ADR is a discord bot designed to work with multiple table-top role playing (TTRPG) systems. 
Currently, the bot supports:
* ASOIF RPG (https://greenronin.com/sifrp/)
* AGE system (https://greenroninstore.com/collections/age-system)
* DnD 5e (https://dnd.wizards.com)

It also supports just rolling some dice with no system selected to allow for some flexibility. 

### Supported Commands
> /help - prints this info!

### Systems
> /systems - prints the available systems

> /set-system - provides a selectable drop-down list of systems.

> /get-system - returns the current system that you're account is using.

### Rolls

### No system (none)
> /roll xdy - where x is the number of dice (1-999999) and y is the number of sides (1-999999)<br>
> example: /roll 5d6<br>
> output: [6,3,5,1,1]

### Dungeons & Dragons (dnd)

> /roll xdy - where x is the number of dice (1-999999) and d is the sides of the dice (4,6,8,12,20,100)<br>
> optional attributes: modifiers (a,d,+,-,*,/) - these allow you to add modifiers like advantage, disadvantage, and common math operations<br>
> 
> example: /roll 5d6<br>
> output: Rolled: [1, 3, 3, 5, 6] = 18
> 
> example: /roll 5d6 a<br>
> output: Rolled: roll 1 [1, 3, 3, 5, 6] = 18, roll 2 [6, 6, 6, 6, 6] = 30, roll 2 is highest at 30
>
> example: /roll 5d6+3<br>
> output: Rolled: roll 1 [1, 3, 3, 5, 6] = 18 + 3 = 21

### A Song of Ice and Fire RPG (asoif)

> /roll xby - where x is the number of dice (1-999999) and b is the number of bonus dice (1-999999)<br>
> example: /roll 5b6<br>
> output: Rolled: [6, 6, 6, 6, 5, 5, 3, 3, 2, 1, 1]. The highest 5 is: [6, 6, 6, 6, 5] = 29

### Advanced Game Engine (age)

> /roll x - where x is the modifier (0-9) you want added to your roll. This roll will also check for doubles and calculate stunt points <br>
> example: /roll 4<br>
> output: Rolled: [4, 1, 4] + 4 = 13 and generated 4 stunt points!

### Quick Rolls

> /set-qr num roll -where num is the number 1-10 you want to save the roll to (roll must be valid for current system)<br>
> example: /set-qr 1 5b6
> output: quick roll 1, set to 5b6

> /qr num - where num is the number (1-10) of the saved roll
> example: /qr 1
> output: Rolled: [5, 5, 4, 4, 3, 3, 3, 2, 2, 2, 1]. The highest 5 is: [5, 5, 4, 4, 3] = 21
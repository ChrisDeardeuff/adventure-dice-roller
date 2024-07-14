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

> /roll xdy(modifier) (options) - where x is the number of dice (1-999999) and d is the sides of the dice (4,6,8,12,20,100)<br>
> modifiers (+,-,*,/ and then a number) - these allow you to perform common math operations and can be chained (+3/2) but will be executed in order of listing, not based on order of operation.<br>
> options (a,d) - allow you to specify dis/advantage which will roll the roll twice and either use the highest (a) or lowest (d) roll before applying the modifiers. 
> 
> example: /roll 5d6<br>
> output: 5d6: [1, 2, 4, 3, 1] = 11 <br>
> 
> example: /roll 1d20 a<br>
> output: 1d20 with advantage: [17] [10]  = 17<br>
>
> example: /roll 5d6+3<br>
> output: 5d6+3: [6, 6, 6, 5, 2] + 3 = 28<br>
>
> example: /roll 1d20+5 d<br>
> output: 1d20+5 with disadvantage: [6] [9] + 5 = 11<br>

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

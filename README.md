Currently the existing dice bots on Discord are all geared toward specific systems. Avrae for D&D, and others for
smaller more niche systems.

## Requirements:

* Ability to change system
    * this will determine what valid rolls are
        * can be used to simplify commands (if a system only ever rolls 3D6, the command could just be /roll and it will
          always roll 3D6 (instead of having to specify)
* modifiers (math, common alterations, etc..)
* quick rolls

## How to do this:

* user class
    * uuid
    * current system
    * table of quick rolls
* stored user info in Firebase

## Commands:

|                         |            |                                                                                                      |                                                                                                |
|-------------------------|------------|------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| Command Name            | Variables  | Description                                                                                          | Notes                                                                                          |
| /system \[system name\] | sysName    | Sets the users preferred system.                                                                     | sysName required                                                                               |
| /roll \[n\] (dx) (mod)  | n, dx, mod | Rolls n dice of x sides with any modifications                                                       | modifications will be defined later but will be a string that has to follow specific formating |
| /qr \[x\]               | x          | quick roll will roll a pre configured roll from the users settings. It must be a valid /roll command | x is number from 1-10. 10 is the max number of quick rolls allowed to be saved.                |
| /qrs \[n\] \[r\]        | n, r       | n is the number 1-10  r is the valid roll                                                            |                                                                                                |
|                         |            |                                                                                                      |                                                                                                |
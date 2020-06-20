# BSnake
A version of the classic snake game.

## Screenshots

Start Screen (2nd-easiest difficulty level):

![start screen (second-easiest difficulty level)](Screenshots/start-screen.png?raw=true "Start Screen (2nd-easiest difficulty level)")

Gameplay - 15 apples eaten:

![gameplay (fifteen apples eaten)](Screenshots/15-apples-eaten.png?raw=true "Gameplay - 15 apples eaten")

Gameplay - 2 lives lost + 6 apples eaten:

![gameplay (two lives lost, plus six apples eaten)](Screenshots/2-lives-lost-6-apples-eaten.png?raw=true "Gameplay - 2 lives lost + 6 apples eaten")

## History
Original development stopped 2015-01-13 (it started in early 2014). Feel free to open a pull request if you want to continue it!

## Compilation
You can compile the `.bas` (FreeBASIC) file with the [freebasic compiler](https://sourceforge.net/projects/fbc/files/ "FreeBASIC Compiler on SourceFourge") (last tested with `fbc` version 1.05.0):
```
fbc BSnakeAlt.bas
```

## Known Issues
**LOTS**, here are some:
- Segfault without options given
  - Give both `-noconsole` and `-developer` to make it work!
- The 'head' of the snake will sometimes 'detatch'.

See the notes in `BSnakeAlt.bas` for other known issues.

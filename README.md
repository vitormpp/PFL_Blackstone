## Functional and Logic Programming 
### Second Project
# Blackstone - Prolog Implementation

## Introduction

In the context of the Functional and Logic Programming curricular unit, we were tasked with implementing a game using SICStus Prolog 4.9, in order to use and comprehend the features of logic programming. 

## Group

|Group Member | Student Number | Contribution |
|---|---|---|
| Gabriela Rodrigues da Silva | 202206777 | 50% |
| Vítor Manuel Pereira Pires | 202207301 | 50% |

## Installation and Execution

1) Ensure the correct installation of SICStus Prolog 4.9.
2) Download the zip of code from GitHub, and extract to some folder.
3) To run game:
- **Linux**: open the extracted folder in the terminal and run:
```
cd src/
sicstus
consult('game.pl').
play.
```
- **Windows**: open the `SICStus` and consult the `game.pl` file and run `play.` in the SICStus terminal.


## The Game - Blackstone
**Blackstone** is a two-player game designed by Mark Steere in March 2024. It is played on a square board of any even size, of side length 6 or longer. The following screenshot demonstrates the initial configuration for a 8 by 8 board:

<div align="center">
<img src="imgs/initial_board.png" alt="Game Board" width="300"/>
</div>
<br>

```prolog
(
   1, % Turn number
   player(h,'r'), % Player 1 - a human (with red stones)
   player(c-2,'b'), % Player 2 - the computer (in easy mode, with blue stones)
   [
      [' ','r',' ','r',' ','r',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ','b'],
      ['b',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ','b'],
      ['b',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ',' ',' ',' ',' ',' ','b'],
      ['b',' ',' ',' ',' ',' ',' ',' '],
      [' ',' ','r',' ','r',' ','r',' '],
   ], % 8x8 board
   1 % Churn variant
)
```

Starting with the red player, each player can, in each turn, move one of their own pieces any number of steps in an unobstructed horizontal, vertical or diagonal path. Before the other moves, a black piece is placed on the square the moved piece had originally been.

< image showing a valid move >

If a red or blue piece is unnable to move, it is removed. In the medium churn variant, all black pieces **surrounding it** are removed as well. In the high churn variant, **all** black pieces are eliminated.

< image showing a piece dying >

A player wins when all of their oponent's pieces are eliminated. 

The reference used for the rules can be found [here](https://www.marksteeregames.com/Blackstone_rules.pdf).

## Extensions

In this implementation, we have integrated all churn variants described in the rules, as well as variable board sizes and two different difficulty levels for the computer players.

### Churn variants:
- **1 - Low Churn Variant** (Default): after making a move, if any red or blue stones are surrounded by adjacent stones of any of the three colors and completely blocked from moving, they must be removed from the board.
- **2 - Medium Churn Variant**: if the move blocks red or blue stones, rremove those stones and also the black stones that contributed to the kills.
- **3 - High Churn variant**: if the move blocks red or blue stones, remove those stones and also all of the black stones from the board.

### Dificulty levels:
- **1 - Easy** (Simple Bot): The AI chooses a random move from the list of valid moves.
- **2 - Hard** (Expert Bot): The AI "greedily" chooses a move from the list of valid moves.
- **3 - Smartest** (Minimax Bot): The AI aims to maximize the value heuristic associated with one player considering that the other is trying to minimize it by iterating through states up to a given depth, with alpha-beta prunning.
- **4 - Smart** (Brute-Force Bot): The AI tests every reachable state up to a certain depth, considering that its opponent always makes the greedy choice. It selects the move which can lead to the final state with the most value in these conditions.

## Logic, Arquitecture and Implementation
The development of this application involved multiple components. Decisions were made regarding the representation of data, the design of player interaction mechanisms, and the implementation of algorithms, as well as the selection of modules provided by `SICStus`, namely the _lists_ and _between_ modules.

### Game Configuration Representation

In order to create the initial game state, information is requested from the user, and passed to the initial_state(+GameConfig, -GameState) function.

<div align="center">
   <img src="imgs/init_form.png" alt="Init Form" width="400"/>
</div>
<br>

The GameConfig term matches the format gameConfig(P1Type,P2Type,ChurnVariant,Size), where:
   - P1Type and P2 are either player(h), signalling a human player, or player(c-DifficultyLevel) otherwise, with DifficultyLevel being either 1 or 2.
   - ChurnVariant is a number between 1 and 3
   - Size is an even number greater than 6, representing the size in squares/positions of the side of the square board.

### Internal Game State Representation

To represent a game state, the term state(TurnNumber, Player1, Player2, Variant, Board) is used, where:
   - `TurnNumber` is a number starting at 1 that is incremented every turn.
   - `Player1` and `Player2` are player configurations identical to that of `gameConfig(player(h,Color),player(c-DifficultyLevel,Color))`.
   - `Variant` is a number between 1 and 3.
   - `Board` is a list of lists of characters, representing the piece (`'r'` for red, `'b'` for blue, `'x'` for black), or lack thereof (`' '`), in each position.

> Note: We could not use `assert` or `retract` to store / manipulate game configuration or game state information. So to access you information from the game configuration, namely players and churn variant, we included it in the game state term.

### Move Representation

To represent a move, the term `move(OX-OY, TX-TY)` is used, where:
   - `OX-OY` is the original position of the piece the player wants to move.
   - `TX-TY` is the position to which the player wants to move it.  
For uniformization purposes, we considered that coordinates start at `1-1` at the lower left corner.

### User Interaction

During the main loop of the game, user interaction is handled by the predicate `choose_move(+GameState, +Level, -Move)`, which takes into account the turn number - used to determine which player's turn it is - and whether that player is a computer or human.

<div align="center">
   <img src="imgs/choose_move.png" alt="Init Form" width="600"/>
</div>
<br>

To avoid an application shutdown or other unexpected behaviour, techniques such as well-placed cuts and addicional predicates that verified input before continuing with the next iteration of a loop were used. The following predicate demonstrates both of these techniques:

```prolog
validate('C',GameConfig):- % computer player - asks for a difficulty value 
    !, 
    input_form_difficulty(GameConfig).

validate('H',GameConfig):- %player is human - proceeds to second player question
    !, 
    input_form(player(h,'r'),GameConfig).
validate(_,GameConfig):- % invalid input - repeats first player question
    write('Invalid input!\n'),
    input_form(GameConfig).
```
Moreover, a custom read_number function was created, as the `get_char` and `get_code` predicate were favored over `read`.


### Implementation Details

#### Value Function

To determine the value heuristic for a given player and state, the number of pieces of each player that are on the board are taken into consideration, as well as the number of valid moves available:
- Value = #Our_Pieces - #Other_Player_Pieces + (#Moves/BoardArea)#### Minimax Algorithm



< ! write this ! >
##someone Board generation

As stated in the game rules, the board size is dynamic (i.e, may have a variable size that must be an even number largfer than 6).

< more >

## Conclusions
This project allowed us to apply the knowledge we have gained of logic programming and Prolog to develop a game. We collaboratively designed and agreed upon consistent representations for the data structures used throughout the code. Additionally, several algorithms were explored: a greedy algorithm to select the most favorable current move, a minimax algorithm implemented with depth-first search, and another approach utilizing breadth-first search. Additionally, we made efforts to ensure the game was robust against player input errors.

## Bibliography
[1] 
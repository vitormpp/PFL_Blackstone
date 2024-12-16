## Functional and Logic Programming 
### Second Project
# Blackstone - Prolog Implementation

## Introduction

In the context of the Functional and Logic Programming curricular unit, we were tasked with implementing a game using SICStus Prolog 4.9, in order to use and comprehend the features of logic programming. 

## Group

|Group Member | Student Number | Contribution |
|---|---|---|
| Gabriela Rodrigues da Silva | 202206777 | 50% |
| (insert here) | (insert here) | 50% |

## Installation and Execution

1) Ensure the correct installation of SICStus Prolog 4.9.
2) In the SICStus console,



## The Game - Blackstone
Blackstone is a two-player game designed by Blackstone in March 2024. It is played on a square board of any even size. The following screenshot demonstrates the initial configuration for a 8 by 8 board:

< image goes here >

Starting with the red player, each player can, in each turn, move one of their own pieces any number of steps in an unobstructed horizontal, vertical or diagonal path. Before the other moves, a black piece is placed on the square the moved piece had originally been.

< image showing a valid move >

If a red or blue piece is unnable to move, it is removed. In the medium churn variant, all black pieces _surrounding it_ are removed as well. In the high churn variant, _all_ black pieces are eliminated.

< image showing a piece dying >

A player wins when all of their oponent's pieces are eliminated. 

The reference used for the rules can be found [here](https://www.marksteeregames.com/Blackstone_rules.pdf).

## Extensions

In this implementation, we have integrated all churn variants described in the rules, as well as variable board sizes and two different difficulty levels for the computer players.

< see if we do more extensions >

## Logic, Arquitecture and Implementation



### Game Configuration Representation
In order to create the initial game state, information is requested from the user, and passed to the initial_state(+GameConfig, -GameState) function.

< image of the configuration messages >

The GameConfig term matches the format gameConfig(P1Type,P2Type,ChurnVariant,Size), where:
   - P1Type and P2 are either player(h), signalling a human player, or player(c-DifficultyLevel) otherwise.
   - ChurnVariant is a number between 1 and 3
   - Size is an even number greater than 6, representing the size in squares/positions of the side of the square board.

### Internal Game State Representation

### Move Representation

### User Interaction


## Conclusions



## Bibliographu
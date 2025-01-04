/*
    File: choose_move_helper.pl
    Description: This file contains the predicates that are used to choose a move for the computer to make.
*/

validate_move(state(TurnNo, Player1Info, Player2Info, Variant, Board),X1,Sep1,Y1,Sep2,X2,Sep3,Y2,move(NX1-NY1,NX2-NY2)):-
    member(Sep1,[',',' ','-']),
    member(Sep2,[',',' ','-']),
    member(Sep3,[',',' ','-']),
    length(Board,Height),
    NY1 is Height-Y1,
    NY2 is Height-Y2,
    NX1 is X1-1,
    NX2 is X2-1,
    valid_moves(state(TurnNo, Player1Info, Player2Info, Variant, Board), ListOfMoves),
    member(move(NX1-NY1,NX2-NY2),ListOfMoves),!.

validate_move(GameState,_,_,_,_,_,_,_,Move):-
    write('Invalid input!'),nl,
    display_game(GameState),choose_move(GameState,_,Move).

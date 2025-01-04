/*
    File: choose_move_helper.pl
    Description: This file contains the predicates that are used to choose a move for the computer to make.
*/

% validate_move(+GameState,+Origin,+Destination,-Move)
% validate_move/4 checks if the input from a player choosing a move corresponds to a valid move move(X1-Y1,X2-Y2), to be unified with Move. X1 and Y2 correspond to the coordinates of the position of the piece to be moved, and X2 and Y2 correspond to the coordinates of the position to which it will be moved. 
validate_move(state(TurnNo, Player1Info, Player2Info, Variant, Board),X1-Y1,X2-Y2,move(NX1-NY1,NX2-NY2)):-
    length(Board,Height),
    NY1 is Height-Y1,
    NY2 is Height-Y2,
    NX1 is X1-1,
    NX2 is X2-1,
    valid_moves(state(TurnNo, Player1Info, Player2Info, Variant, Board), ListOfMoves),
    member(move(NX1-NY1,NX2-NY2),ListOfMoves),!.

% if any of the inputs or the move itself is invalid, an error message is desplayed and a "asking for input" cycle is repeated.
validate_move(GameState,_,_,_,_,_,_,_,Move):-
    write('Invalid input!'),nl,
    display_game(GameState),choose_move(GameState,_,Move).

read_move(X1-Y1,X2-Y2):-
    write('Source X: '),
    read_number(X1),skip_line,
    write('Source Y: '),
    read_number(Y1),skip_line,
    write('Target X: '),
    read_number(X2),skip_line,
    write('Target Y: '),
    read_number(Y2),skip_line.
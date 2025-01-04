% validate_move(+GameState,+X1,+Sep1,+Y1,+Sep2,+X2,+Sep3,+Y2,-Move)
% validate_move/9 checks if the input from a player choosing a move corresponds to a valid move move(X1-Y1,X2-Y2), to be unified with Move. X1 and Y2 correspond to the coordinates of the position of the piece to be moved, and X2 and Y2 correspond to the coordinates of the position to which it will be moved. Sep1, Sep2 and Sep3 correspond to the characters the player used to separate the coordinate values.
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
% if any of the inputs or the move itself is invalid, an error message is desplayed and a "asking for input" cycle is repeated.
validate_move(GameState,_,_,_,_,_,_,_,Move):-
    write('Invalid input!'),nl,
    display_game(GameState),choose_move(GameState,_,Move).

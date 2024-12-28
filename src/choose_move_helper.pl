validate_move(GameState,X1,Sep1,Y1,Sep2,X2,Sep3,Y2,move(X1-Y1,X2-Y2)):-
member(Sep1,[',',' ','-']),
member(Sep2,[',',' ','-']),
member(Sep3,[',',' ','-']),
valid_moves(GameState, ListOfMoves),
member(move(X1-Y1,X2-Y2),ListOfMoves),!.

validate_move(GameState,_,_,_,_,_,_,_,Move):-
write('Invalid input!'),nl,
display_game(GameState),choose_move(GameState,_,Move).

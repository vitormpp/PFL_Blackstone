% to draw vertical lines between rows:

% entry point: starts the function with the accumulator
display_grid_line(SSymbol,ESymbol,Size):-
    display_grid_line(SSymbol,ESymbol,0,Size).

% starts a line: prints the starting symbol
display_grid_line(SSymbol,ESymbol,0,Size):-
    Size>1,
    put_char(SSymbol),put_char('-'),
    display_grid_line(SSymbol,ESymbol,1,Size).

% displays the middle of the line
display_grid_line(SSymbol,ESymbol,X,Size):-
    X>0,
    X<Size,
    put_char('-'),put_char('-'),
    X2 is X+1,
    display_grid_line(SSymbol,ESymbol,X2,Size).

% end of iteration: prints the end symbol
display_grid_line(_,ESymbol,Size,Size):-
    put_char(ESymbol).
    
% ---------

% displaying a row.

% recursive case: prints the head.
display_content_line([H|T]):-
    put_char('|'),
    write(H),
    display_content_line(T).
%base case: prints the end character.
display_content_line([]):- write('|').
    
% ----
% display the board:
% recursive case: prints line by line    
display_board([H|T]):-
    length(T,L),
    L>0, % length of the TAIL. This is checking if there are more rows
    length(H,Size),
    display_content_line(H), nl, 
    display_grid_line(' ',' ',Size),
    nl,
    display_board(T).

% base case: prints the final line, without recursion. This was made separately because printing the final line is handled externally, in case we manage to support different end characters.
display_board([H]):-
    display_content_line(H),nl.

% just so the function doesn't fail if the board has dimension 0
display_board([]).

/*
    File: display_game_helpers.pl
    Description: This file contains the predicates that are used to display the game.
*/

% To draw vertical lines between rows:

% display_grid_line(+SSymbol, +ESymbol, +X, +Size)
% display_grid_line/4 displays a line of the board, with the starting symbol SSymbol, the ending symbol ESymbol, and a size of Size.
% It is an entry point: starts the function with the accumulator
display_grid_line(SSymbol, ESymbol, Size):-
    write('  '),
    display_grid_line(SSymbol, ESymbol, 0, Size).

% starts a line: prints the starting symbol
display_grid_line(SSymbol, ESymbol, 0, Size):-
    Size>1,
    write(' '),
    put_char(SSymbol), write('---'),
    display_grid_line(SSymbol, ESymbol, 1, Size).

% displays the middle of the line
display_grid_line(SSymbol,ESymbol,X,Size):-
    X>0,
    X<Size,
    write('+---'),
    X2 is X+1,
    display_grid_line(SSymbol, ESymbol, X2, Size).

% end of iteration: prints the end symbol
display_grid_line(_, ESymbol, Size, Size):-
    put_char(ESymbol).
    

% Displaying a row:

% display_content_line(+Line)
% display_content_line/1 displays the content of a line of the board.
% recursive case: prints the head.
display_content_line([H|T]):-
    write(' | '),
    write(H),
    display_content_line(T).
%base case: prints the end character.
display_content_line([]):- write(' |').


% Displays x coordinate line:

% display_number_line(+Num, +Size)
% display_number_line/2 displays the x coordinate line of the board.
%initial case: prints with an extra space before
display_number_line(1,Size):-
    Size>0,
    write('     1 '), 
    display_number_line(2,Size).
% usual recursive case: prints with a single space
display_number_line(Num,Size):-
    Num>1,
    Num<10,
    Num=<Size,
    write('  '),
    write(Num), 
    write(' '),
    Num2 is Num+1, 
    display_number_line(Num2, Size).

display_number_line(Num,Size):-
    Num>1,
    Num>9,
    Num=<Size,
    write(' '),
    write(Num), 
    write(' '),
    Num2 is Num+1, 
    display_number_line(Num2, Size).

% end of line
display_number_line(Num,Size):-Num>Size.


% Displaying the board:

% display_board(+Board)
% display_board/1 displays the board.
% displays x coordinates and calls helper function with an accumulator for line number (y coordinate)    
display_board([H|T]):- length(H, Size),
    length([H|T], Height),
    display_grid_line(' ', ' ', Size),nl,
    display_board(Height, [H|T]),
    display_grid_line(' ', ' ', Size),nl,
    display_number_line(1, Size),nl.



% recursive case: prints line by line    
display_board(LineNum, [H|T]):-
    length(T, L),
    L>0, % length of the TAIL. This is checking if there are more rows
    length(H, Size),
    LineNum<10,
    write(' '), 
    write(LineNum),
    display_content_line(H), 
    nl, 
    display_grid_line(' ',' ',Size),
    nl,
    NewLineNum is LineNum-1,
    display_board(NewLineNum,T).


display_board(LineNum, [H|T]):-
    length(T, L),
    L>0, % length of the TAIL. This is checking if there are more rows
    length(H, Size),
    LineNum>9,
    write(LineNum),
    display_content_line(H), 
    nl, 
    display_grid_line(' ',' ',Size),
    nl,
    NewLineNum is LineNum-1,
    display_board(NewLineNum,T).



% base case: prints the final line, without recursion. This was made separately because printing the final line is handled externally, in case we manage to support different end characters.
display_board(LineNum, [H]):-
    write(' '),write(LineNum), display_content_line(H),nl.

% just so the function doesn't fail if the board has dimension 0
display_board(_,[]).

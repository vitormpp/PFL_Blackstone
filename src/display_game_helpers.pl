
display_grid_line(SSymbol,ESymbol,Size):-
    display_grid_line(SSymbol,ESymbol,0,Size).

display_grid_line(SSymbol,ESymbol,0,Size):-
    Size>1,
    put_char(SSymbol),put_char('-'),
    display_grid_line(SSymbol,ESymbol,1,Size).

display_grid_line(SSymbol,ESymbol,X,Size):-
    X>0,
    X<Size,
    put_char('-'),put_char('-'),
    X2 is X+1,
    display_grid_line(SSymbol,ESymbol,X2,Size).

display_grid_line(_,ESymbol,Size,Size):-
    put_char(ESymbol).
    


display_content_line(Line):-
    length(Line,Size),
    display_content_line(Line,Size).

display_content_line([H|T],Size):-
    put_char('|'),
    write(H),
    display_content_line(T,Size).

display_content_line([],_):- write('|').
    
    
display_board([H|T]):-
    length(T,L),
    L>0,
    length(H,Size),
    display_content_line(H), nl, 
    display_grid_line(' ',' ',Size),
    nl,
    display_board(T).

display_board([H]):-
    display_content_line(H),nl.
display_board([]).

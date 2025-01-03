:-use_module(library(lists)).
:-use_module(library(between)).

% get_turn_color(+TurnNum, -Color)
% get_turn_color/2 returns the color of the player that is playing in the turn number TurnNum.
get_turn_color(TurnNum,'r'):-
    1 =:= TurnNum mod 2.
get_turn_color(TurnNum,'b'):-
    0 =:= TurnNum mod 2.

% get_board_position(+X-Y, +Board, -Elem)
% helper function that obtains the value at a given board position.
get_board_position(X-Y, Board, Elem):-
    nth0(Y,Board,Line),
    nth0(X,Line,Elem).

% is_in_line_of_sight(+X1-Y1, +X2-Y2)
% is_in_line_of_sight/2 checks if the two given positions (X1, Y1) and (X2, Y2) are in line of sight.
% That is true if they are in the same row, column or diagonal.
is_in_line_of_sight(_-Y, _-Y).
is_in_line_of_sight(X-_, X-_).
is_in_line_of_sight(X1-Y1, X2-Y2):- 
    abs(X1-X2) =:= abs(Y1-Y2).

% has_piece_between(+Board, +X1-Y1, +X2-Y2)
% has_piece_between/3 checks if there is a piece between the two given positions (X1, Y1) and (X2, Y2).
has_piece_between(Board, X1-Y, X2-Y):-
	\+(get_board_position(BX-Y,Board, ' ')), between(X1,X2,BX).

has_piece_between(Board, X-Y1, X-Y2):-
	\+(get_board_position(X-BY,Board, ' ')), between(Y1,Y2,BY).

has_piece_between(Board, X1-Y1, X2-Y2):-
    X1 \= X2, Y1 \= Y2,
    abs(X1-X2)=:=abs(Y1-Y2),
	\+(get_board_position(X-Y,Board, ' ')), abs(X1-X)=:=abs(Y1-Y),between(X1,X2,X),between(Y1,Y2,Y).


% copy_line(+TurnColor, +Line, +Move, -NewLine)
% copy_line/4 copies a line of the board, applying the given move.
copy_line(_,[], _,[]).

copy_line(TurnColor, [_|T], move(OX-OY, 0-0), [TurnColor|T2]):-
    \+ (OX=0,OY=0),
    NOX is OX-1,
    copy_line(TurnColor,T,move(NOX-OY,(-1)-0),T2).

copy_line(TurnColor, [_|T], move(0-0, TX-TY), ['x'|T2]):-
    \+ (TX=0,TY=0),
    NTX is TX-1,
    copy_line(TurnColor,T,move((-1)-0,NTX-TY),T2).

copy_line(TurnColor, [H|T], move(OX-OY, TX-TY), [H|T2]):-
    \+ (TX=0,TY=0),
    \+ (OX=0,OY=0),
    NOX is OX-1,
    NTX is TX-1,
    copy_line(TurnColor,T,move(NOX-OY,NTX-TY),T2).


% create_new_board(+TurnColor, +Board, +Move, -NewBoard)
% create_new_board/4 creates a new board, applying the given move.
create_new_board(_,[], _, []).

create_new_board(TurnColor,[H|T], move(OX-OY, TX-TY), [NH|NT]):-
    copy_line(TurnColor,H,move(OX-OY, TX-TY),NH),
    NOY is OY-1,
    NTY is TY-1,    
    create_new_board(TurnColor,T, move(OX-NOY, TX-NTY),NT).


% bound checks aren't necessary, as get_board_position will fail for invalid numbers anyway.
piece_is_surrounded(X-Y,[H|T]):-
    R is X+1,
    L is X-1,
    U is Y+1,
    D is Y-1,
    \+ get_board_position(L-U,[H|T],' '),
    \+ get_board_position(X-U,[H|T],' '),
    \+ get_board_position(R-U,[H|T],' '),
    \+ get_board_position(L-Y,[H|T],' '),
    \+ get_board_position(X-Y,[H|T],' '),
    \+ get_board_position(X-Y,[H|T],'x'),  % to help in other places... It's not strictly necessary
    \+ get_board_position(R-Y,[H|T],' '),
    \+ get_board_position(L-D,[H|T],' '),
    \+ get_board_position(X-D,[H|T],' '),
    \+ get_board_position(R-D,[H|T],' ').


get_dead_pieces_aux(3,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line), 

    nth0(X,Line,'x').


get_dead_pieces_aux(_,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line), 
    \+nth0(X,Line,'x'),
    \+nth0(X,Line,' '),
    piece_is_surrounded(X-Y,Board).


get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line), 
    nth0(X,Line,'x'),
            L is X-1,
            U is Y+1,
            piece_is_surrounded(L-U,Board).

get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line), 
        
            nth0(X,Line,'x'),

            U is Y+1,
            piece_is_surrounded(X-U,Board).

get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line),

            nth0(X,Line,'x'),

            R is X+1,
            U is Y+1,
            piece_is_surrounded(R-U,Board).    


get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line),

    nth0(X,Line,'x'),
    R is X+1,
    piece_is_surrounded(R-Y,Board).    


get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line),
        
        nth0(X,Line,'x'),
        L is X-1,
        piece_is_surrounded(L-Y,Board).    


get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line),
        
        nth0(X,Line,'x'),
        L is X-1,
        D is Y-1,
        piece_is_surrounded(L-D,Board).  

    
get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line),
    nth0(X,Line,'x'),
    D is Y-1,
    piece_is_surrounded(X-D,Board).


get_dead_pieces_aux(2,Board,X-Y):-
    iterate_pieces(Board,X-Y,Line),        
        nth0(X,Line,'x'),
        R is X+1,
        D is Y-1,
        piece_is_surrounded(R-D,Board).

iterate_pieces(Board,X-Y,Line):-
    length(Board,Len),
    Len2 is Len-1,
    between(0,Len2,Y),

    nth0(Y,Board,Line),
    length(Line,LLen),
    LLen2 is LLen-1,
    between(0,LLen2,X).


get_dead_pieces(ChurnVariant,Board,DeadPieces):-
    findall(DeadPiece,get_dead_pieces_aux(ChurnVariant,Board,DeadPiece),DeadPieces).





%board_empty_position(_,[],[]).
board_empty_position(X-Y,Board , NewBoard):-
    nth0(Y,Board,Line),
    X1 is X+1,
    length(BeforeElem, X),
    length(L2, X1),
    append(BeforeElem,_,Line),
    append(L2,AfterElem,Line),
    append(BeforeElem,[' '|AfterElem],NewLine),
    Y1 is Y+1,
    length(BeforeLine, Y),
    length(L3, Y1),
    append(BeforeLine,_,Board),
    append(L3,AfterLine,Board),
    append(BeforeLine,[NewLine|AfterLine],NewBoard). 


remove_dead_pieces_aux([X-Y|T],Board, NBoard):-
    board_empty_position(X-Y,Board,NewBoard),
    remove_dead_pieces_aux(T,NewBoard, NBoard).

remove_dead_pieces_aux([],Board, Board).

remove_dead_pieces(ChurnVariant,Board, NBoard):-
    get_dead_pieces(ChurnVariant,Board,DeadPieces),
    remove_dead_pieces_aux(DeadPieces,Board, NBoard).
    

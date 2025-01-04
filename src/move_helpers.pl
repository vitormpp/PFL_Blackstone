:-use_module(library(lists)).
:-use_module(library(between)).

/*
    File: move_helpers.pl
    Description: This file contains the predicates that are used to manipulate moves.
*/

% get_turn_color(+TurnNum, -Color)
% get_turn_color/2 returns the color of the player that is playing in the turn number TurnNum.
get_turn_color(TurnNum,'r'):-
    1 =:= TurnNum mod 2.
get_turn_color(TurnNum,'b'):-
    0 =:= TurnNum mod 2.

% get_oponent(+Color, -Oponent)
% get_oponent/2 returns the oponent of the given color.
get_opponent('r','b').
get_opponent('b','r').


% is_in_line_of_sight(+X1-Y1, +X2-Y2)
% is_in_line_of_sight/2 checks if the two given positions (X1, Y1) and (X2, Y2) are in line of sight.
% That is true if they are in the same row, column or diagonal.
is_in_line_of_sight(_-Y, _-Y).
is_in_line_of_sight(X-_, X-_).
is_in_line_of_sight(X1-Y1, X2-Y2):- 
    X1\=X2,
    Y1\=Y2,
    abs(X1-X2) =:= abs(Y1-Y2).

% has_piece_between(+Board, +X1-Y1, +X2-Y2)
% has_piece_between/3 checks if there is a piece between the two given positions (X1, Y1) and (X2, Y2).
has_piece_between(Board, X1-Y, X2-Y):-
    MinX is min(X1,X2)+1,
    MaxX is max(X1,X2)-1,
	between(MinX,MaxX,BX), 
    \+(get_piece_at(BX-Y,Board, ' ')).

has_piece_between(Board, X-Y1, X-Y2):-
    MinY is min(Y1,Y2)+1,
    MaxY is max(Y1,Y2)-1,
    between(MinY,MaxY,BY), 
    \+(get_piece_at(X-BY,Board, ' ')).

has_piece_between(Board, X1-Y1, X2-Y2):-
    MinX is min(X1,X2)+1,
    MaxX is max(X1,X2)-1,
    MinY is min(Y1,Y2)+1,
    MaxY is max(Y1,Y2)-1,
    X1 \= X2, Y1 \= Y2,
    abs(X1-X2)=:=abs(Y1-Y2),
    between(MinX,MaxX,X), between(MinY,MaxY,Y),
	\+(get_piece_at(X-Y,Board, ' ')), 
    abs(X1-X)=:=abs(Y1-Y).

% create_new_board(+TurnColor, +Board, +Move, -NewBoard)
% create_new_board/4 creates a new board, applying the given move.
create_new_board(_,[], _, []).

create_new_board(TurnColor, Board, move(OX-OY, TX-TY), NewBoard):-
    set_piece_at(OX-OY, Board, 'x', NewBoard1),
    set_piece_at(TX-TY, NewBoard1, TurnColor, NewBoard).



% piece_is_surrounded(+X-Y, +Board)
% piece_is_surrounded/2 checks if the piece at position (X, Y) is surrounded by other pieces.
% bound checks aren't necessary, as get_piece_at will fail for invalid numbers anyway.
piece_is_surrounded(X-Y,[H|T]):-
    R is X+1,
    L is X-1,
    U is Y+1,
    D is Y-1,
    \+ get_piece_at(X-Y,[H|T],' '),
    \+ get_piece_at(X-Y,[H|T],'x'),  % to help in other places... It's not strictly necessary
    \+ get_piece_at(L-U,[H|T],' '),
    \+ get_piece_at(X-U,[H|T],' '),
    \+ get_piece_at(R-U,[H|T],' '),
    \+ get_piece_at(L-Y,[H|T],' '),
    \+ get_piece_at(R-Y,[H|T],' '),
    \+ get_piece_at(L-D,[H|T],' '),
    \+ get_piece_at(X-D,[H|T],' '),
    \+ get_piece_at(R-D,[H|T],' ').


% get_dead_pieces_aux(+ChurnVariant, +Board, -X-Y)
% get_dead_pieces_aux/3 returns the position of a dead piece in the board.
get_dead_pieces_aux(3, Board, X-Y):-
    get_piece_at(X-Y,Board,'x').

get_dead_pieces_aux(Board, X-Y):-
    get_piece_at(X-Y,Board,Piece),
    member(Piece,['r','b']),
    piece_is_surrounded(X-Y, Board).

% get_dead_pieces(+ChurnVariant, +Board, -DeadPieces)
% get_dead_pieces/3 returns a list of dead pieces in the board.
% Dead pieces are pieces that are surrounded by other pieces.
get_dead_pieces(1, Board, DeadPieces):-
    findall(DeadPiece, get_dead_pieces_aux(Board,DeadPiece), Res),
    sort(Res, DeadPieces).

get_dead_pieces(2, Board, DeadPieces):-
    findall(DeadPiece, get_dead_pieces_aux(Board,DeadPiece), Res),
    sort(Res, DeadPieces1),
    findall(X-Y,(
        get_piece_at(X-Y,Board,'x'),
        member(X2-Y2,DeadPieces1),
        are_adjacent(X-Y,X2-Y2)
    ),Res2),
    append(Res2,DeadPieces1,DeadPieces2),
    sort(DeadPieces2,DeadPieces).

get_dead_pieces(3, Board, DeadPieces):-
    findall(DeadPiece, get_dead_pieces_aux(Board,DeadPiece), Res),
    sort(Res, DeadPieces1),
    findall(X-Y,(
        length(DeadPieces1,N),
        N>0,
        get_piece_at(X-Y,Board,'x')
        ),
    DeadPieces2),
    append(DeadPieces1,DeadPieces2,DeadPieces3),
    sort(DeadPieces3,DeadPieces).

% are_adjacent(+Originm, +Destination)
% are_adjacent/2 checks whether two positions X-Y are adjacent.
are_adjacent(X1-Y1,X2-Y2):-
    DifX is abs(X2-X1),
    DifY is abs(Y2-Y1),
    DifY=<1,
    DifX=<1.

% board_empty_position(+X-Y, +Board, -NewBoard)
% board_empty_position/3 empties a position in the board.
% board_empty_position(_,[],[]).
board_empty_position(X-Y, Board, NewBoard):-
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

% remove_dead_pieces_aux(+DeadPieces, +Board, -NBoard)
% remove_dead_pieces_aux/3 removes the dead pieces from the board.
remove_dead_pieces_aux([X-Y|T],Board, NBoard):-
    board_empty_position(X-Y,Board,NewBoard),
    remove_dead_pieces_aux(T,NewBoard, NBoard).

remove_dead_pieces_aux([],Board, Board).

remove_dead_pieces(ChurnVariant,Board, NBoard):-
    get_dead_pieces(ChurnVariant,Board,DeadPieces),
    remove_dead_pieces_aux(DeadPieces,Board, NBoard).
    
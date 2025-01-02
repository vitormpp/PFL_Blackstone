
:- use_module(library(lists)).

/*
    File: board.pl
    Description: This file contains the predicates that are used to create and manipulate the board.
*/

% create_list(+Element, +Size, -List)
% crate_list/2 creates a list of Size elements, all of them being Element.
create_list(_, 0, []).
create_list(Element, Size, [Element|Sublist]) :-
    Size > 0,
    Size1 is Size - 1,
    create_list(Element, Size1, Sublist).

% cycle(+N, +List, -Result)
% This predicate generates a list by repeating the elements of the input list `List` `N` times. The result is unified with `Result`.
cycle(0, _, []).
cycle(N, List, Result) :-
    N > 0,
    cycle_aux(N, List, [], Result).

% cycle_aux(+N, +L1, +Acc, -R)
% Auxiliary predicate for cycle/3.
cycle_aux(0, _, Acc, Acc).
cycle_aux(N, L1, Acc, R):-
    N > 0,
    N1 is N - 1,
    append(L1, Acc, Acc1),
    cycle_aux(N1, L1, Acc1, R).

% get_board(+Size, -Board)
% get_board/2 creates a board of size Size x Size.
create_board(Size, Board):-
    create_aux(0, Size, Board).

% create_aux(+Index, +Size, -Board)
% create_aux/3 creates a board of size Size x Size.
create_aux(Index, Size, []) :-
    Index >= Size, !.

create_aux(Index, Size, [Element|Sublist]) :-
    Index >= 0,
    Index < Size,
    create_row(Index, Size, Element),
    Index1 is Index + 1,
    create_aux(Index1, Size, Sublist).

% create_row(+Index, +Size, -Row)
% create_row/3 creates a row of size Size.
create_row(0, Size, Row):-
    N is Size // 2 - 1,!,
    cycle(N, [' ','r'], L),
    append(L, [' ',' '], Row).

create_row(Index, Size, Row):-
    Index is Size - 1,
    N is Size // 2 - 1,!,
    cycle(N, ['r',' '], L),
    append([' ',' '], L, Row).

create_row(Index, Size, Row):-
    Index mod 2 =:= 0,
    N is Size - 1,
    create_list(' ', N, R),
    append(['b'], R, Row).

create_row(Index, Size, Row):-
    Index mod 2 =:= 1,
    N is Size - 1,
    create_list(' ', N, R),
    append(R, ['b'], Row).

% set_piece_at(+Board, +X, +Y, +Piece, -NewBoard)
% set_piece_at/4 sets the piece Piece at position (X, Y) in the board Board. The result is unified with NewBoard.
set_piece_at(Board, X, Y, Piece, NewBoard):-
    nth0(X, Board, Row, Rest),
    set_in_row(Row, Y, Piece, NewRow),
    nth0(X, NewBoard, NewRow, Rest).


% set_in_row(+Row, +X, +Piece, -NewRow)
% set_in_row/4 sets the piece Piece at position X (removing the piece that was already there) in the row Row. The result is unified with NewRow.
set_in_row(Row, Index, Piece, NewRow):-
    nth0(Index, Row, _, Rest),
    nth0(Index, NewRow, Piece, Rest).
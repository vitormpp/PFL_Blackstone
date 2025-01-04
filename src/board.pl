
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
% cycle/3 generates a list by repeating the elements of the input list `List` `N` times (like an append N times). The result is unified with `Result`.
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

% set_piece_at(+X-Y, +Board, +Piece, -NewBoard)
% set_piece_at/4 sets the piece Piece at position (X, Y) in the board Board. The result is unified with NewBoard.
set_piece_at(X-Y, Board, Piece, NewBoard):-
    nth0(Y, Board, Row, Rest),
    set_in_row(Row, X, Piece, NewRow),
    nth0(Y, NewBoard, NewRow, Rest).

% set_in_row(+Row, +X, +Piece, -NewRow)
% set_in_row/4 sets the piece Piece at position X (removing the piece that was already there) in the row Row. The result is unified with NewRow.
set_in_row([], _, _, []).
set_in_row(Row, Index, Piece, NewRow):-
    nth0(Index, Row, _, Rest),
    nth0(Index, NewRow, Piece, Rest).

% get_piece_at(?X-Y, +Board, ?Piece)
% get_piece_at/3 gets the piece at position (X, Y) in the board Board. The result is unified with Piece. It can also be used to obtain all positions containing a piece of a given type.
get_piece_at(X-Y, Board, Piece):-
    nth0(Y, Board, Row),
    nth0(X, Row, Piece).

% get_positions(+Board, +Piece, -Positions)
% get_positions/3 gets all the positions in the board Board that have the piece Piece. The result is unified with Positions.
get_positions(Board, Piece, Positions):-
    findall(X-Y, get_piece_at(X-Y, Board, Piece), Positions).

% count_pieces(+Board, +Piece, -Count)
% count_pieces/3 counts the number of pieces Piece in the board Board. The result is unified with Count.
count_pieces(Board, Piece, Count):-
    get_positions(Board, Piece, Positions),
    length(Positions, Count).

% Determines if is empty
is_empty(' ').

% Determines if is red
is_red('r').

% Determines is blue
is_blue('b').

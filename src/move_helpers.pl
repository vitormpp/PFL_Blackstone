:- consult('valid_moves_helpers.pl').
:- use_module(library(lists)).
:- use_module(library(between)).
copy_line(_,[], _,[]).

copy_line(TurnColor,[_|T], move(OX-OY, 0-0),[TurnColor|T2]):-
    \+ (OX=0,OY=0),
    
    NOX is OX-1,

    copy_line(TurnColor,T,move(NOX-OY,(-1)-0),T2).


copy_line(TurnColor,[_|T], move(0-0, TX-TY),['x'|T2]):-
    \+ (TX=0,TY=0),
    
    NTX is TX-1,

    copy_line(TurnColor,T,move((-1)-0,NTX-TY),T2).



copy_line(TurnColor,[H|T], move(OX-OY, TX-TY),[H|T2]):-
    \+ (TX=0,TY=0),
    \+ (OX=0,OY=0),
    
    NOX is OX-1,
    NTX is TX-1,

    copy_line(TurnColor,T,move(NOX-OY,NTX-TY),T2).



create_new_board(_,[], _, []).

create_new_board(TurnColor,[H|T], move(OX-OY, TX-TY), [NH|NT]):-
    copy_line(TurnColor,H,move(OX-OY, TX-TY),NH),
    NOY is OY-1,
    NTY is TY-1,    
    create_new_board(TurnColor,T, move(OX-NOY, TX-NTY),NT).


%from valid_moves_helper:
%get_board_position(X-Y,Board,Elem)

piece_is_surrounded(X-Y,Board):-
    R is X+1,
    L is X-1,
    U is Y+1,
    D is Y-1,
    \+ get_board_position(L-U,Board,' '),
    \+ get_board_position(X-U,Board,' '),
    \+ get_board_position(R-U,Board,' '),
    \+ get_board_position(L-Y,Board,' '),
    \+ get_board_position(X-Y,Board,' '),
    \+ get_board_position(X-Y,Board,'x'),  % to help in other places... It's not strictly necessary
    \+ get_board_position(R-Y,Board,' '),
    \+ get_board_position(L-D,Board,' '),
    \+ get_board_position(X-D,Board,' '),
    \+ get_board_position(R-D,Board,' ').


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




board_empty_position_aux(_,[],[]).

board_empty_position_aux(X-Y,[H|T],[H|NT]):- 
    \+ (X=0,Y=0),
    NX is X-1,
    board_empty_position_aux(NX-Y,T,NT).

board_empty_position_aux(0-0,[_|T],[' '|NT]):- 
    board_empty_position_aux((-1)-0,T,NT).


board_empty_position(_,[],[]).
board_empty_position(X-Y,[H|T],[NH|NT]):-
    NY is Y-1,
    board_empty_position_aux(X-Y,H,NH),
    board_empty_position_aux(X-NY,T,NT).



remove_dead_pieces_aux([X-Y|T],Board, NBoard):-
    board_empty_position(X-Y,Board,NewBoard),
    remove_dead_pieces_aux(T,NewBoard, NBoard).

remove_dead_pieces_aux([],Board, Board).

remove_dead_pieces(ChurnVariant,Board, NBoard):-
    get_dead_pieces(ChurnVariant,Board,DeadPieces),
    remove_dead_pieces_aux(DeadPieces,Board, NBoard).
    

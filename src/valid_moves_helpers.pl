:- use_module(library(lists)).

get_turn_color(TurnNum,'r'):-
    0 =:= TurnNum mod 2.
get_turn_color(TurnNum,'b'):-
    1 =:= TurnNum mod 2.



merge_moves([H|T],Acc,ListOfMoves):-
    append(Acc,H,Acc2),
    merge_moves(T,Acc2,ListOfMoves).
    merge_moves([],ListOfMoves,ListOfMoves).
    
    merge_moves(LL,ListOfMoves):-merge_moves(LL,[],ListOfMoves).


get_board_position(X-Y,Board,Elem):-
    nth0(Board,Y,Line),
    nth0(X,Line,Elem).


explore_direction(Board,_,X-Y,_,ListOfMoves,ListOfMoves):-
    \+ get_board_position(X-Y,Board,' ').    


explore_direction(Board,X-Y,X-Y,DirX-DirY,Acc,ListOfMoves):- 
    NewX is X+DirX,
    NewY is Y+DirY,
    explore_direction(Board,X-Y,NewX-NewY,DirX-DirY,Acc,ListOfMoves).
        
explore_direction(Board,OriginX-OriginY,X-Y,DirX-DirY,Acc,ListOfMoves):-
    get_board_position(X-Y,Board,' '),
    NewX is X+DirX,
    NewY is Y+DirY,
    explore_direction(Board,OriginX-OriginY,NewX-NewY,DirX-DirY,[move(OriginX-OriginY,X-Y)|Acc],ListOfMoves).


explore_direction(Board,OriginX-OriginY,X-Y,DirX-DirY,ListOfMoves):- explore_direction(Board,OriginX-OriginY,X-Y,DirX-DirY,[],ListOfMoves).

explore_space(X-Y,Board,ListOfMoves):-
    explore_direcition(Board,X-Y,X-Y,1-0,L1),
    explore_direcition(Board,X-Y,X-Y,(-1)-0,L2),
    explore_direcition(Board,X-Y,X-Y,0-1,L3),
    explore_direcition(Board,X-Y,X-Y,0-(-1),L4),
    explore_direcition(Board,X-Y,X-Y,1-(-1),L5),
    explore_direcition(Board,X-Y,X-Y,(-1)-(-1),L6),
    explore_direcition(Board,X-Y,X-Y,(-1)-1,L7),
    explore_direcition(Board,X-Y,X-Y,1-1,L8),
    merge_moves([L1,L2,L3,L4,L5,L6,L7,L8],ListOfMoves).



valid_moves_aux(state(TurnNumber, _,_,_,Board) 
, ListOfMoves):-
    length(Board,Len),
    Len2 is Len-1,
    between(0,Len2,Y),
    nth0(Board,Y,Line),
    
    nth0(Y,Board,Line),
    length(Line,LLen),
    LLen2 is LLen-1,
    between(0,LLen2,X),

    nth0(X,Line,Elem),
   
    get_turn_color(TurnNumber,Elem),
    explore_space(X-Y,Board,ListOfMoves).


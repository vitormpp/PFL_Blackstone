:- use_module(library(lists)).
:- use_module(library(between)).
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
    nth0(Y,Board,Line),
    nth0(X,Line,Elem).


explore_direction(Board,_,X-Y,_,ListOfMoves,ListOfMoves):-
    \+ get_board_position(X-Y,Board,' ').    



explore_direction(_,_,X-_,_,ListOfMoves,ListOfMoves):-
        X<0.    
    

explore_direction(_,_,_-Y,_,ListOfMoves,ListOfMoves):-
            Y<0.    


explore_direction(Board,_,_-Y,_,ListOfMoves,ListOfMoves):-
                length(Board,L),
                Y>=L.            

explore_direction(Board,_,X-_,_,ListOfMoves,ListOfMoves):-
    nth0(0,Board,Line),
    length(Line,L),
     X>=L.            



explore_direction(Board,OriginX-OriginY,X-Y,DirX-DirY,Acc,ListOfMoves):-
    nth0(0,Board,Line),
    length(Line,LL),
    X<LL, X>=0,
    length(Board,L),
    Y<L,Y>=0,
    get_board_position(X-Y,Board,' '),
    NewX is X+DirX,
    NewY is Y+DirY,
    explore_direction(Board,OriginX-OriginY,NewX-NewY,DirX-DirY,[move(OriginX-OriginY,X-Y)|Acc],ListOfMoves).

explore_direction(Board,OriginX-OriginY,X-Y,DirX-DirY,ListOfMoves):-
    nth0(0,Board,Line),
    length(Line,LL),
    X<LL, X>=0,
    length(Board,L),
    Y<L,Y>=0,
    NewX is X+DirX,
    NewY is Y+DirY,
    explore_direction(Board,OriginX-OriginY,NewX-NewY,DirX-DirY,[],ListOfMoves).

explore_space(X-Y,Board,ListOfMoves):-
    explore_direction(Board,X-Y,X-Y,1-0,L1),
    explore_direction(Board,X-Y,X-Y,(-1)-0,L2),
    explore_direction(Board,X-Y,X-Y,0-1,L3),
    explore_direction(Board,X-Y,X-Y,0-(-1),L4),
    explore_direction(Board,X-Y,X-Y,1-(-1),L5),
    explore_direction(Board,X-Y,X-Y,(-1)-(-1),L6),
    explore_direction(Board,X-Y,X-Y,(-1)-1,L7),
    explore_direction(Board,X-Y,X-Y,1-1,L8),
    merge_moves([L1,L2,L3,L4,L5,L6,L7,L8],ListOfMoves).



valid_moves_aux(state(TurnNumber, _,_,_,Board) 
, ListOfMoves):-
    length(Board,Len),
    Len2 is Len-1,
    between(0,Len2,Y),
    nth0(Y,Board,Line),
    
    nth0(Y,Board,Line),
    length(Line,LLen),
    LLen2 is LLen-1,
    between(0,LLen2,X),

    nth0(X,Line,Elem),
   
    get_turn_color(TurnNumber,Elem),
    explore_space(X-Y,Board,ListOfMoves).


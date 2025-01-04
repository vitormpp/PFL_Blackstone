:- include('game.pl').


get_states(Depth,MaxDepth,Acc,States):-
    Depth<MaxDepth,
    Depth>=0,
    findall(NewList,
        (
            member(S,Acc),
            last(S,State-_),
            move(State,move(X1-X2,Y1-Y2),NewState),
            append(S,[NewState-move(X1-X2,Y1-Y2)],NewList)
        ),
        NewAcc),
        NewDepth is Depth+1,
        get_states(NewDepth,MaxDepth,NewAcc,States).


get_states(MaxDepth,MaxDepth,States,States).


get_best_move(state(TurnNumber, P1, P2, Churn, Board),player(P,Color),Depth,Move):-
    Depth>0,
    get_turn_color(TurnNumber,Color),

    findall(Value-M,(
        get_states(0,Depth,[[state(TurnNumber, P1, P2, Churn, Board)-move(none)]],StatesList),
        member([_,S-M|T],StatesList),
        last([S-M|T],State-_),
        value(State,player(P,Color),Value)
    ),
    MovesValues
    ),
    findall(VMove,
        (member(V-VMove, MovesValues),
             \+ (member( V2-_, MovesValues),
                V2 > V)),
        MostValuableMoves),
    random_member(Move, MostValuableMoves).



test_get_best_move:-
    get_best_move(state(1, player(h,'r'), player(h,'b'), 1, [['r',' ','r'],['b','b',' ']]), player(_,'r'),4,Move),write(Move).


test_findall:- findall(X,(between(0,5,X),write('wut')),_).
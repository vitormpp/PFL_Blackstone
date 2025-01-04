/*
    File: ai.pl
    Description: This file contains the predicates that are used to implement the expert BOT.
*/

minimax(GameState, Depth, Player, BestMove):-
	minimax_aux(GameState, Depth, Player, -1000, 1000, _, BestMove).

% If the depth is 0, return the heuristic value of the node
minimax_aux(GameState, 0, player(c-3,Color), _, _, BestValue, _) :-
	!,
	value(GameState, player(c-3,Color), BestValue).

minimax_aux(GameState, Depth, player(c-3,Color), _, _, BestValue, _) :-
	Depth > 0,
	game_over(GameState, Color),!,
	value(GameState, player(c-3,Color), BestValue).

minimax_aux(GameState, Depth, player(c-3,Color), Alpha, Beta, BestValue, BestMove) :-
	Depth > 0,
	valid_moves(GameState, ListOfMoves),
	evaluate_moves(GameState, Depth, player(c-3,Color), ListOfMoves, Alpha, Beta, -1000, _, BestValue, BestMove).

evaluate_moves(_, _, _, [], _, _, BestValue, BestMove, BestValue, BestMove).

evaluate_moves(GameState, Depth, player(c-3,Color), [Move | ListOfMoves], Alpha, Beta, CurrentBestValue, CurrentBestMove, BestValue, BestMove) :-
	move(GameState, Move, NewGameState),
	get_opponent(Color, Opponent),
	NewDepth is Depth - 1,
	NegAlpha is -Beta,
	NegBeta is -Alpha,
	minimax_aux(NewGameState, NewDepth, player(c-3,Opponent), NegAlpha, NegBeta, OpponentValue, _),
	CurrentValue is -OpponentValue,
	update_best_value(CurrentBestValue, CurrentValue, CurrentBestMove, Move, NewBestValue, NewBestMove),
	NewAlpha is max(Alpha, CurrentValue),
	cut_or_continue(GameState, Depth, player(c-3,Color), ListOfMoves, NewAlpha, Beta, NewBestValue, NewBestMove, BestValue, BestMove).

update_best_value(CurrentBestValue, CurrentValue, CurrentBestMove, _, CurrentBestValue, CurrentBestMove):-
	CurrentValue =< CurrentBestValue, !.

update_best_value(_, CurrentValue, _, Move, CurrentValue, Move).

cut_or_continue(GameState, Depth, player(c-3,Color), ListOfMoves, NewAlpha, Beta, CurrentBestValue, CurrentBestMove, BestValue, BestMove):-
	NewAlpha < Beta,!,
	evaluate_moves(GameState, Depth, player(c-3,Color), ListOfMoves, NewAlpha, Beta, CurrentBestValue, CurrentBestMove, BestValue, BestMove).

% beta cut-off
cut_or_continue(GameState, Depth, player(c-3,Color), _, NewAlpha, Beta, CurrentBestValue, CurrentBestMove, BestValue, BestMove):-
	evaluate_moves(GameState, Depth, player(c-3,Color), [], NewAlpha, Beta, CurrentBestValue, CurrentBestMove, BestValue, BestMove).



%second AI:



get_states(us,P1,P2,Depth,MaxDepth,Acc,States):-
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
        get_states(other,P1,P2,NewDepth,MaxDepth,NewAcc,States).


get_states(other,P1,P2,Depth,MaxDepth,Acc,States):-
	Depth<MaxDepth,
	Depth>=0,
	findall(NewList,
		(
		member(S,Acc),
		last(S,State-_),
		move(State,move(X1-X2,Y1-Y2),NewState),
		value(NewState,P2,Value),
		\+ (
			move(State,_,NewState2),
			value(NewState2,P2,Value2),
			Value2>Value			
			),
		append(S,[NewState-move(X1-X2,Y1-Y2)],NewList)
		),
				NewAcc),

				NewDepth is Depth+1,
	get_states(us,P1,P2,NewDepth,MaxDepth,NewAcc,States).
		
get_states(MaxDepth,MaxDepth,States,States).


get_other_player(player(_,'r'),_,player(_,'r'),player(_,'r')).
get_other_player(_,player(_,'b'),player(_,'b'),player(_,'b')).

get_best_move(state(TurnNumber, P1, P2, Churn, Board),player(P,Color),Depth,Move):-
    Depth>0,
    get_turn_color(TurnNumber,Color),

	get_other_player(P1,P2,player(P,Color),OtherP),
    findall(Value-M,(
        get_states(us,player(P,Color),OtherP,0,Depth,[[state(TurnNumber, P1, P2, Churn, Board)-move(none)]],StatesList),
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

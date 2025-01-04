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

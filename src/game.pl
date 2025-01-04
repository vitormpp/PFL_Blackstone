:- use_module(library(random)).
:- consult('board.pl').
:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('move_helpers.pl').
:- consult('gameloop.pl').
:- consult('choose_move_helper.pl').
:- consult('ai.pl').

/*
	File: game.pl
	Description: This file contains the predicates that are used to play the game.
*/

%state(TurnNumber, Player1,Player2, Variant,Board) 

% Move representation : move(OX-OY,TX-TY)
%move(originX-originY,targetX-targetY).

% GameConfig( (H/H, H/PC, PC/H, or PC/PC) - ser computador vs computador/ vs pessoa, level 1 vs level 2 difficulty, board size, churn variant)

% use  get_char for input

%even turns is red and P1. Odd turns is blue and P2 


% mandatory:


% play/0 starts the game
play:-
	write('Welcome to Blackstone!\nWould you like to:\n 1 - Play\n 2 - Consult Rules\n 3 - Quit\n'), 
	get_char(C),
	skip_line,
	main_menu_evaluate(C).

% initial_state(+GameConfig, -GameState)
% initial_state/2 Unifies Board with a board of size Size x Size.
initial_state(gameConfig(Player1, Player2, Variant, Size), state(1, Player1, Player2, Variant, Board)) :-
	create_board(Size, Board).

% display_game(+GameState)
% display_game/1 displays the game board.
display_game(state(TurnNumber, _, _, _, Board))  :-
	write('Turn '),
	write(TurnNumber),
	nl, 
    length(Board, BSize),
	BSize > 0,
	nth0(0, Board, Elem),
	length(Elem, Size),
	Size>0,
	display_board(Board).
	
% move(+GameState, +Move, -NewGameState)
% move/3 applies the move Move to the game state GameState, resulting in the new game state NewGameState.
move(state(TurnNumber, Player1, Player2, ChurnVariant, Board), move(OX-OY, TX-TY), state(NTurnNumber, Player1, Player2, ChurnVariant, NBoard)):-
	get_turn_color(TurnNumber, TurnColor),
	get_piece_at(OX-OY, Board, TurnColor),
	get_piece_at(TX-TY, Board, ' '),
	is_in_line_of_sight(OX-OY, TX-TY),
    \+ (has_piece_between(Board, OX-OY, TX-TY)),
	create_new_board(TurnColor, Board,  move(OX-OY, TX-TY), B2),
	remove_dead_pieces(ChurnVariant, B2, NBoard),
	NTurnNumber is TurnNumber + 1.


% valid_moves(+GameState, -ListOfMoves):-
% valid_moves/2 returns a list of all valid moves for the current player.
valid_moves(state(TurnNumber, Player1,Player2, Variant, Board), ListOfMoves):-
	findall(Move, move(state(TurnNumber, Player1, Player2, Variant, Board),Move,_),ListOfMoves).
%	findall(Moves,
%		valid_moves_aux(state(TurnNumber, _, _, _, Board),
%			Moves),
%		ListOfLists),
%	merge_moves(ListOfLists, ListOfMoves).
    

% game_over(+GameState, -Winner)
% game_over/2 checks if the game is over and returns the winner.
game_over(state(TurnNumber, _, _, _, Board), P2):-
	 \+ (member(Line, Board),
		member('r', Line)),
	 \+ (member(Line, Board),
		member('b', Line)),!,
	 get_turn_color(TurnNumber,P1),
	 get_opponent(P1,P2).

game_over(state(_, _, _, _, Board), 'b'):-
	 \+ (member(Line, Board),
		member('r', Line)).

game_over(state(_, _, _, _, Board), 'r'):-
	 \+ (member(Line, Board),
		member('b', Line)).
    
% choose_move(+GameState, +Level, -Move)
% choose_move/3 chooses a move for the computer to make.
choose_move(state(TurnNumber, player(c-4,'r'), P2, Churn, Board), _, Move):-
	1 =:= TurnNumber mod 2,
	get_best_move(state(TurnNumber, player(c-4,'r'), P2, Churn, Board), player(c-4,'r'),5,Move).
choose_move(state(TurnNumber, P1,player(c-4,'b'), Churn, Board), _, Move):-
	0 =:= TurnNumber mod 2,
	get_best_move(state(TurnNumber, P1, player(c-4,'b'), Churn, Board), player(c-4,'b'),5,Move).


choose_move(state(TurnNumber, player(c-2,'r'), P2, Churn, Board), _, Move):-
	1 =:= TurnNumber mod 2,
	findall(M-Value,
		(
			move(state(TurnNumber,
				player(c-2,'r'),
				P2,
				Churn,
				Board),
				M,
				NewState
			),
			value(NewState, player(c-2,'r'), Value)
		),
		MovesValues),
	findall(VMove,
			(
				member(VMove - V, MovesValues),
	 			\+ (member(_ - V2, MovesValues), V2 > V)
			),
		MostValuableMoves),
	random_member(Move, MostValuableMoves).

% choose_move(+GameState, +Level, -Move)
% choose_move/3 chooses a move for the computer to make.
choose_move(state(TurnNumber, player(c-1,'r'), P2, Churn, Board), _, Move):-
 
	1 =:= TurnNumber mod 2,
	valid_moves(state(TurnNumber,
			player(c-1,'r'),
			P2,
			Churn,
			Board),
		ListOfMoves),
	random_member(Move, ListOfMoves).

choose_move(state(TurnNumber, P1, player(c-2,'b'), Churn, Board), _, Move):-
 
	0 =:= TurnNumber mod 2,
	findall(M-Value,
		(
			move(state(TurnNumber,
				P1,
				player(c-2,'b'),
				Churn,
				Board),
				M,
				NewState),
			value(NewState, player(c-2,'b'), Value)
			),
		MovesValues),

	    findall(VMove,
            (member(VMove - V, MovesValues),
                 \+ (member(_ - V2, MovesValues),
                    V2 > V)),
            MostValuableMoves),
        random_member(Move, MostValuableMoves).

choose_move(state(TurnNumber, P1, player(c-1,'b'), Churn, Board), _, Move):-
 	0 =:= TurnNumber mod 2,
	valid_moves(state(TurnNumber,
			P1,
			player(c-1,'b'),
			Churn,
			Board),
		ListOfMoves),
	random_member(Move, ListOfMoves).

choose_move(state(TurnNumber, player(h,'r'), P2, Churn, Board), _, Move):-
     1 =:= TurnNumber mod 2,
	write('Player one - r '),nl,
	read_move(X1-Y1,X2-Y2),
    skip_line,
    validate_move(state(TurnNumber, player(h,'r'), P2, Churn, Board),X1-Y1,X2-Y2, Move).


choose_move(state(TurnNumber, P1, player(h,'b'), Churn, Board), _, Move):-
 
    0 =:= TurnNumber mod 2,
    write('Player two - b '),nl,
	read_move(X1-Y1,X2-Y2),
    skip_line,
    validate_move(state(TurnNumber, P1, player(h,'b'), Churn, Board),X1-Y1,X2-Y2,Move).

choose_move(state(TurnNumber, player(c-3,'r'), _, Churn, Board), _, Move):-
	minimax(state(TurnNumber, player(c-3,'r'), _, Churn, Board), 3, player(c-3,'r'), Move).

choose_move(state(TurnNumber, _, player(c-3,'b'), Churn, Board), _, Move):-
	minimax(state(TurnNumber, _, player(c-3,'b'), Churn, Board), 3, player(c-3,'b'), Move).


% value(+GameState, +Player, -Value)
% value/3 evaluates how good or bad a move (chosen by the computer). The higher the value, the better the move.
/*
	Key factors for evaluation:
	- Blocking opponent's movement;
	- Preserving mobility;
	- Capturing opponent's pieces;
	- Strategic positioning;
*/
value(state(_, _, _, _, Board), player(_,Piece), Value):-
	get_opponent(Piece, Oponent),
	count_pieces(Board, Piece, PlayerCount),
	count_pieces(Board, Oponent, OponentCount),
	%get_dead_pieces(Variant, Board, DeadPieces),
	%findall(X-Y, (member(X-Y, DeadPieces), get_piece_at(X-Y, Board, Oponent)), OponentDeadPieces),
	%length(OponentDeadPieces, OponentDeadPiecesCount),
	Value is PlayerCount - OponentCount.


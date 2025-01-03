:- use_module(library(random)).
:- consult('board.pl').
:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('move_helpers.pl').
:- consult('gameloop.pl').
:- consult('choose_move_helper.pl').

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
display_game(state(_, _, _, _, Board))  :- 
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
	get_board_position(OX-OY,Board,TurnColor),
	get_board_position(TX-TY,Board, ' '),
	is_in_line_of_sight(OX-OX,TX-TY),
    \+ (has_piece_between(Board,OX-OY,TX-TY)),
	create_new_board(TurnColor, Board,  move(OX-OY, TX-TY), B2),
	remove_dead_pieces(ChurnVariant, B2, NBoard),
	NTurnNumber is TurnNumber + 1.


% valid_moves(+GameState, -ListOfMoves):-
% valid_moves/2 returns a list of all valid moves for the current player.
valid_moves(state(TurnNumber, Player1,Player2, Variant, Board), ListOfMoves):-
	findall(Move,move(state(TurnNumber, Player1,Player2, Variant, Board),Move,_),ListOfMoves).
%	findall(Moves,
%		valid_moves_aux(state(TurnNumber, _, _, _, Board),
%			Moves),
%		ListOfLists),
%	merge_moves(ListOfLists, ListOfMoves).
    

% game_over(+GameState, -Winner)
% game_over/2 checks if the game is over and returns the winner.
game_over(state(_, _, _, _, Board), 'x'):-
	 \+ (member(Line, Board),
		member('r', Line)),
	 \+ (member(Line, Board),
		member('b', Line)),
	!.

game_over(state(_, _, _, _, Board), 'b'):-
	 \+ (member(Line, Board),
		member('r', Line)).

game_over(state(_, _, _, _, Board), 'r'):-
	 \+ (member(Line, Board),
		member('b', Line)).
    
% value(+GameState, +Player, -Value)
value(GameState, Player, Value).

% choose_move(+GameState, +Level, -Move)
% choose_move/3 chooses a move for the computer to make.
choose_move(state(TurnNumber, player(c-2,'r'), P2, Churn, Board), _, Move):-
	1 =:= TurnNumber mod 2,
	findall(M-Value,
		(valid_moves(state(TurnNumber,
					player(c-2,'r'),
					P2,
					Churn,
					Board),
				ListOfMoves),
			member(M, ListOfMoves),
			move(valid_moves(state(TurnNumber,
						player(c-2,'r'),
						P2,
						Churn,
						Board),
					M,
					NewState),
				value(NewState, player(c-2,'r'), Value))),
		MovesValues),
	findall(VMove,
		(member(VMove - V, MovesValues),
			 \+ (member(_ - V2, MovesValues),
				V2 > V)),
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
		(valid_moves(state(TurnNumber,
                    P1,
					player(c-2,'b'),
					Churn,
					Board),
				ListOfMoves),
			member(M, ListOfMoves),
			move(valid_moves(state(TurnNumber,
                        P1,
                        player(c - 2,'b'),
						Churn,
						Board),
					M,
					NewState),
				value(NewState, player(c - 2,'b'), Value))),
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
	write('Player one(r) (Xi-Yi,Xf-Yf): '),nl,
    read_number(X1),
    get_char(Sep1),
    read_number(Y1),
    get_char(Sep2),
    read_number(X2),
    get_char(Sep3),
    read_number(Y2),
    skip_line,
    validate_move(state(TurnNumber, player(h,'r'), P2, Churn, Board),X1,Sep1,Y1,Sep2,X2,Sep3,Y2, Move).


choose_move(state(TurnNumber, P1, player(h,'b'), Churn, Board), _, Move):-
    0 =:= TurnNumber mod 2,
    write('Player two(b) (Xi-Yi,Xf-Yf): '),nl,
    read_number(X1),
    get_char(Sep1),
    read_number(Y1),
    get_char(Sep2),
    read_number(X2),
    get_char(Sep3),
    read_number(Y2),
    skip_line,
    validate_move(state(TurnNumber, P1, player(h,'b'), Churn, Board),X1,Sep1,Y1,Sep2,X2,Sep3,Y2,Move).


% value(+GameState, +Player, -Value)
% value/3 evaluates how good or bad a move (chosen by the computer). The higher the value, the better the move.
/*
	Key factors for evaluation:
	- Blocking opponent's movement;
	- Preserving mobility;
	- Capturing opponent's pieces;
	- Strategic positioning;
*/
value(state(TurnNumber, _, _, Variant, Board), player(_,Piece), Value):-
	oponent(Piece, Oponent),
	count_pieces(Board, Piece, PlayerCount),
	count_pieces(Board, Oponent, OponentCount),
	findall(Move,move(state(TurnNumber, _, _, Variant, Board),Move,_),ListOfMoves),
	length(ListOfMoves, PlayerMoves),
	get_dead_pieces(Variant, Board, DeadPieces),
	findall(X-Y, get_piece_at(X-Y, DeadPieces, Oponent), OponentDeadpieces),
	length(DeadPiecePositions, OponentDeadPieces),
	Value is PlayerCount - OponentCount + DeadPieceCount.

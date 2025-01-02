%state(TurnNumber, Player1,Player2, Variant,Board) 

% Move representation : move(OX-OY,TX-TY)

% GameConfig( (H/H, H/PC, PC/H, or PC/PC) - ser computador vs computador/ vs pessoa, level 1 vs level 2 difficulty, board size, churn variant)

% use  get_char for input


% mandatory:

:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('move_helpers.pl').
:- consult('gameloop.pl').
:- consult('choose_move_helper.pl').
:- use_module(library(random)).


play:-write('Welcome to Blackstone!\nWould you like to:\n 1 - Play\n 2 - Consult Rules\n 3 - Quit\n'), get_char(C),skip_line,main_menu_evaluate(C).


display_game(state(_, _, _, _, Board))  :- 
    length(Board, BSize),
	BSize > 0,
	nth0(0, Board, Elem),
	length(Elem, Size),
	Size>0,
	display_board(Board).
	




    
% move(+GameState, +Move, -NewGameState)
move(state(TurnNumber, Player1, Player2, ChurnVariant, Board), move(OX-OY, TX-TY), state(NTurnNumber, Player1, Player2, ChurnVariant, NBoard)):-
	get_turn_color(TurnNumber, TurnColor),
	get_board_position(OX-OY,Board,TurnColor),
	get_board_position(TX-TY,Board, ' '),
	is_in_line_of_sight(OX-OX,TX-TY),
    \+ (has_piece_between(Board,OX-OY,TX-TY)),
	create_new_board(TurnColor, Board,  move(OX-OY, TX-TY), B2),
	remove_dead_pieces(ChurnVariant, B2, NBoard),
	NTurnNumber is TurnNumber + 1.


%move(originX-originY,targetX-targetY).
%valid_moves(+GameState, -ListOfMoves):-
valid_moves(state(TurnNumber, Player1,Player2, Variant, Board), ListOfMoves):-
	findall(Move,move(state(TurnNumber, Player1,Player2, Variant, Board),Move,_),ListOfMoves).
%	findall(Moves,
%		valid_moves_aux(state(TurnNumber, _, _, _, Board),
%			Moves),
%		ListOfLists),
%	merge_moves(ListOfLists, ListOfMoves).
    

% game_over(+GameState, -Winner)
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






%even turns is red and P1. Odd turns is blue and P2 

% choose_move(+GameState, +Level, -Move)
choose_move(state(TurnNumber, player(c-2,'r'), P2, Churn, Board), _, Move):-
	0 =:= TurnNumber mod 2,
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

choose_move(state(TurnNumber, player(c-1,'r'), P2, Churn, Board), _, Move):-
	0 =:= TurnNumber mod 2,
	valid_moves(state(TurnNumber,
			player(c-1,'r'),
			P2,
			Churn,
			Board),
		ListOfMoves),
	random_member(Move, ListOfMoves).

choose_move(state(TurnNumber, P1, player(c-2,'b'), Churn, Board), _, Move):-
	(\+ 0 =:= TurnNumber mod 2),
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
	 \+ (0 =:= TurnNumber mod 2),
	valid_moves(state(TurnNumber,
			P1,
			player(c-1,'b'),
			Churn,
			Board),
		ListOfMoves),
	random_member(Move, ListOfMoves).



choose_move(state(TurnNumber, player(h,'r'), P2, Churn, Board), _, Move):-
    0 =:= TurnNumber mod 2,
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
    0 =\= TurnNumber mod 2,
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
    
    





% initial_state(+GameConfig, -GameState)
initial_state(config(Size, Variant), gamestate(1, Player1Info, Player2Info, Variant, Board)) :-
	create_board(Size, Board),
	initialize_players(Player1Info, Player2Info).


% create_board(+Size, -Board)
create_board(Size, Board) :-
	length(Board, Size),
	create_rows(Size, 0, Board).

% create_rows(+Size, +Index, -Rows)
create_rows(Size, Index, []) :-
	Index =:= Size.
create_rows(Size, Index, [Row|Rows]) :-
	Index < Size,
	create_row(Size, Index, Row),
	NextIndex is Index + 1,
	create_rows(Size, NextIndex, Rows).

% create_row(+Size, +RowIndex, -Row)
create_row(Size, RowIndex, Row) :-
	length(Row, Size),
	place_pieces(RowIndex, 0, Size, Row).

% place_pieces(+RowIndex, +ColIndex, +Size, -Row)
place_pieces(_, ColIndex, Size, []) :-
	ColIndex =:= Size.
place_pieces(RowIndex, ColIndex, Size, [Cell|Rest]) :-
	piece_at(RowIndex, ColIndex, Size, Cell),
	NextColIndex is ColIndex + 1,
	place_pieces(RowIndex, NextColIndex, Size, Rest).

% place_at(+RowIndex, +ColIndex, +Size, -Piece)
piece_at(RowIndex, ColIndex, Size, 'r') :-
	(RowIndex =:= 0;
RowIndex =:= Size - 1),
	ColIndex < Size - 2,
	ColIndex mod 2 =:= 1,
	!.
piece_at(RowIndex, ColIndex, Size, 'b') :-
	RowIndex > 0,
	RowIndex < Size - 1,
	RowIndex mod 2 =:= 1,
	ColIndex =:= 0,
	!.
piece_at(RowIndex, ColIndex, Size, 'b') :-
	RowIndex > 0,
	RowIndex < Size - 1,
	RowIndex mod 2 =:= 0,
	ColIndex =:= Size - 1,
	!.
piece_at(_, _, _, ' ').
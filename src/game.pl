%state(TurnNumber, Player1,Player2, Variant,Board) 

% Move representation : move(OX-OY,TX-TY)

% GameConfig( (H/H, H/PC, PC/H, or PC/PC) - ser computador vs computador/ vs pessoa, level 1 vs level 2 difficulty, board size, churn variant)

% use  get_char for input


% mandatory:

:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('valid_moves_helpers.pl').
:- consult('move_helpers.pl').
:- consult('gameloop.pl').


play:-
	write('Welcome to Blackstone!\n'),
	input_form(GameConfig),
	initial_state(GameConfig, GameState),
    gameloop(GamesState).% not done




% display_game(+GameState)
display_game(state(_, _, _, _, Board)):-
	length(Board, BSize),
    BSize>0,
    nth0(0,Board,Elem),
    length(Elem,Size),
    display_grid_line(' ', ' ', Size),
	nl,
	display_board(Board),
	display_grid_line(' ', ' ', Size),
	nl.






    
% move(+GameState, +Move, -NewGameState)
move(state(TurnNumber, Player1, Player2, ChurnVariant, Board), Move, state(NTurnNumber, Player1, Player2, ChurnVariant, NBoard)):-
    get_turn_color(TurnNumber,TurnColor),
    create_new_board(TurnColor,Board,Move, B2), 
    remove_dead_pieces(ChurnVariant,B2, NBoard),
	NTurnNumber is TurnNumber + 1.


%move(originX-originY,targetX-targetY).
%valid_moves(+GameState, -ListOfMoves):-
valid_moves(state(TurnNumber, _, _, _, Board), ListOfMoves):-
	findall(Moves,
		valid_moves_aux(state(TurnNumber, _, _, _, Board),
			Moves),
		ListOfLists),
	merge_moves(ListOfLists, ListOfMoves).
    

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
value(GameState, Player, Value) .

% choose_move(+GameState, +Level, -Move)
choose_move(GameState, Level, Move).



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
create_rows(Size, Index, [Row | Rows]) :-
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
place_pieces(RowIndex, ColIndex, Size, [Cell | Rest]) :-
    piece_at(RowIndex, ColIndex, Size, Cell),
    NextColIndex is ColIndex + 1,
    place_pieces(RowIndex, NextColIndex, Size, Rest).

% place_at(+RowIndex, +ColIndex, +Size, -Piece)
piece_at(RowIndex, ColIndex, Size, 'r') :-
    (RowIndex =:= 0 ; RowIndex =:= Size - 1),
    ColIndex < Size - 2,
    ColIndex mod 2 =:= 1, !.
piece_at(RowIndex, ColIndex, Size, 'b') :-
    RowIndex > 0,
    RowIndex < Size - 1,
    RowIndex mod 2 =:= 1,
    ColIndex =:= 0, !.
piece_at(RowIndex, ColIndex, Size, 'b') :-
    RowIndex > 0,
    RowIndex < Size - 1,
    RowIndex mod 2 =:= 0,
    ColIndex =:= Size - 1, !.
piece_at(_, _, _, ' ').
%state(TurnNumber, Player1,Player2, Variant,Board) 

% Move representation : Move([sX,sY],[tX,tY])

% GameConfig( (H/H, H/PC, PC/H, or PC/PC) - ser computador vs computador/ vs pessoa, level 1 vs level 2 difficulty, board size, churn variant)

% use  get_char for input



%number_codes(11, "11")

% mandatory:

:- consult('init_form.pl').
:- consult('display_game_helpers.pl').
:- consult('valid_moves_helpers.pl').


play:- 
    write('Welcome to Blackstone!\n'),
    input_form_start(GameConfig),
    initial_state(GameConfig,GameState). % not done




% initial_state(+GameConfig, -GameState)
initial_state(GameConfig, GameState):- write(GameConfig). 



% display_game(+GameState)
display_game(state(_, _,_, _,Board)):-
    length(Board,Size),
    display_grid_line(' ',' ',Size),
    nl,
    display_board(Board),
    display_grid_line(' ',' ',Size),nl.



get_turn_color(TurnNum,'r'):-
    0 =:= TurnNum mod 2.
get_turn_color(TurnNum,'b'):-
    1 =:= TurnNum mod 2.
    
% move(+GameState, +Move, -NewGameState)

%move(originX-originY,targetX-targetY).
%valid_moves(+GameState, -ListOfMoves):-



valid_moves(state(TurnNumber, _,_,_,Board) 
, ListOfMoves):- 
    findall(Moves, valid_moves_aux(state(TurnNumber, _,_,_,Board),Moves), ListOfLists),
    merge_moves(ListOfLists,ListOfMoves).
    

% game_over(+GameState, -Winner)

% value(+GameState, +Player, -Value)

% choose_move(+GameState, +Level, -Move)
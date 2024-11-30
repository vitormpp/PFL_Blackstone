%state(TurnNo, Player1Info(Computador ou pessoa ), Player2Info(Computador ou pessoa), Board, churn Variant)

% Move representation : Move([sX,sY],[tX,tY])

% GameConfig( (H/H, H/PC, PC/H, or PC/PC) - ser computador vs computador/ vs pessoa, level 1 vs level 2 difficulty, board size, churn variant)

% use  get_char for input



%number_codes(11, "11")

% mandatory:



validate_type(P1Type,P2Type,GameConfig):-
    member(P1Type,['C','H']),
    member(P2Type,['C','H']), 
    input_form_2(P1Type,P2Type,GameConfig),!.

validate_type(P1Type,P2Type,GameConfig):- write('Invalid input.\n'), input_form_start(GameConfig).




validate_difficulty(DifficultyLevel,P1Type,P2Type,GameConfig):-
    member(DifficultyLevel,[1,2]),
    input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig),!.

validate_difficulty(_,P1Type,P2Type,GameConfig):- write('Invalid input.\n'), input_form_2(P1Type,P2Type,GameConfig).



validate_churn(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-
    member(ChurnVariant,[1,2,3]),
    input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig),!.

validate_churn(_,DifficultyLevel,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig).


validate_size(Size,ChurnVariant,DifficultyLevel,P1Type,P2Type,gameConfig(P1Type,P2Type,DifficultyLevel,ChurnVariant,Size)):-
    member(Size,[10,6,8]),!.

validate_size(_,ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).

size_chr('6',6).
size_chr('8',8).
size_chr('1',10).
size_chr(_,0).

input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-    
    write('Board size (6,8,10): '),
    get_char(Size),
    skip_line,
    size_chr(Size,Number),
    validate_size(Number,ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).     


input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig):-    
    write('Churn variant (1 - default, 2 - medium, 3 - high): '),
    get_code(ChurnVariant),
    skip_line,
    number_codes(Number, [ChurnVariant]),
    validate_churn(Number,DifficultyLevel,P1Type,P2Type,GameConfig).



input_form_2(P1Type,P2Type,GameConfig):-    
    write('Difficulty level(1/2): '),
    get_code(DifficultyLevel),
    skip_line,
    number_codes(Number, [DifficultyLevel]),
    validate_difficulty(Number,P1Type,P2Type,GameConfig).


%input_form(-GameConfig)
input_form_start(GameConfig):-
    write('Game type (H)uman/(C)omputer, H/H,C/C,C/H: '),
    get_char(P1Type),
    get_char(_),
    get_char(P2Type),
    skip_line,
    validate_type(P1Type,P2Type,GameConfig).





play:- 
    write('Welcome to Blackstone!\n'),
    input_form_start(GameConfig),
    initial_state(GameConfig,GameState).




% initial_state(+GameConfig, -GameState)
initial_state(GameConfig, GameState):- write(GameConfig).

% display_game(+GameState)

% move(+GameState, +Move, -NewGameState)

% valid_moves(+GameState, -ListOfMoves)

% game_over(+GameState, -Winner)

% value(+GameState, +Player, -Value)

% choose_move(+GameState, +Level, -Move)
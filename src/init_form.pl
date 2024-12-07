

validate_type(P1Type,P2Type,GameConfig):-
    member(P1Type,['C','H']),
    member(P2Type,['C','H']),!, 
    input_form_2(P1Type,P2Type,GameConfig).

validate_type(_,_,GameConfig):- write('Invalid input.\n'), input_form_start(GameConfig).




validate_difficulty(DifficultyLevel,P1Type,P2Type,GameConfig):-
    member(DifficultyLevel,[1,2]),!,
    input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig).

validate_difficulty(_,P1Type,P2Type,GameConfig):- write('Invalid input.\n'), input_form_2(P1Type,P2Type,GameConfig).



validate_churn(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-
    member(ChurnVariant,[1,2,3]),!,
    input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).

validate_churn(_,DifficultyLevel,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig).


validate_size(Size,ChurnVariant,DifficultyLevel,P1Type,P2Type,gameConfig(P1Type,P2Type,DifficultyLevel,ChurnVariant,Size)):-
    Size>=6,!.

validate_size(_,ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).


number_from_code(Code,Number):-
    Number is Code - 48.

read_number(X):-
    read_number(0,false,X).

is_number_code(C,true):-
    C > 47, 
    C < 58.
is_number_code(C,false):-
    C < 48. 
is_number_code(C,false):- 
    C > 57.


read_number(Acc,_,X):-
    get_code(C),
    is_number_code(C,true),
    !,
    Acc1 is Acc*10 + C - 48,
    validate_next_character(Acc1,X).

read_number(Acc,true,Acc).

validate_next_character(X,X):-
    peek_code(C),
    \+ is_number_code(C,true).

validate_next_character(Acc,X):-
    peek_code(C),
    is_number_code(C,true),
    read_number(Acc,true,X).



read_until_between(Min,Max,Value):-
    repeat,
    read_number(Value),
    Value >= Min,
    Value =< Max,
    !.

input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-    
    write('Board size: '),
    read_number(Size),
    skip_line,!,
    validate_size(Size,ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).     


input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig):-    
    write('Churn variant (1 - default, 2 - medium, 3 - high): '),
    get_code(ChurnVariant),
    skip_line,
    number_from_code(ChurnVariant,Number),!,
    validate_churn(Number,DifficultyLevel,P1Type,P2Type,GameConfig).



input_form_2(P1Type,P2Type,GameConfig):-    
    write('Difficulty level(1/2): '),
    get_code(DifficultyLevel),
    skip_line,!,
    number_from_code(DifficultyLevel,Number),
    validate_difficulty(Number,P1Type,P2Type,GameConfig).


%input_form(-GameConfig)
input_form_start(GameConfig):-
    write('Game type (H)uman/(C)omputer, H/H,C/C,C/H: '),
    get_char(P1Type),
    get_char(_),
    get_char(P2Type),
    skip_line,!,
    validate_type(P1Type,P2Type,GameConfig).

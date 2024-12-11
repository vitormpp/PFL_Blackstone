
validate(P1Type,GameConfig):-
    member(P1Type,['C']),!, 
    input_form_difficulty(GameConfig).

validate(P1Type,GameConfig):-
    member(P1Type,['H']),!, 
    input_form(player(h),GameConfig).
validate(_,GameConfig):-input_form(GameConfig).



validate(P1Type,P2Type,GameConfig):-
        member(P2Type,['C']),!, 
        input_form_difficulty(P1Type,GameConfig).
    
validate(P1Type,P2Type,GameConfig):-
        member(P2Type,['H']),!, 
        input_form(P1Type,player(h),GameConfig).
validate(P1Type,_,GameConfig):-input_form(P1Type,GameConfig).
    




% validates the answer to the difficulty question and moves on to the next question.
validate_difficulty(DifficultyLevel,P1Type,GameConfig):-
    member(DifficultyLevel,[1,2]),!,
    input_form(P1Type,player(c-DifficultyLevel),GameConfig).
% if the input isn't valid, it repeats the question.
validate_difficulty(_,P1Type,GameConfig):- write('Invalid input.\n'), input_form_2(P1Type,GameConfig).

validate_difficulty(DifficultyLevel,GameConfig):-
    member(DifficultyLevel,[1,2]),!,
    input_form(player(c-DifficultyLevel),GameConfig).

% if the input isn't valid, it repeats the question.
validate_difficulty(_,GameConfig):- write('Invalid input.\n'), input_form(GameConfig).

%---

% validates the answer to the churn question and moves on to the next question
validate(ChurnVariant,P1Type,P2Type,GameConfig):-
    member(ChurnVariant,[1,2,3]),!,
    input_form(ChurnVariant,P1Type,P2Type,GameConfig).
% if the check fails, repeat the question.
validate_churn(_,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form(P1Type,P2Type,GameConfig).
%---

% validates the answer to the board size question and moves on to the next question. 
validate(Size,ChurnVariant,P1Type,P2Type,gameConfig(P1Type,P2Type,ChurnVariant,Size)):-
    Size>=6,!.
% if the answer isn't valid, repeat the question.
validate(_,ChurnVariant,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form_4(ChurnVariant,P1Type,P2Type,GameConfig).

% helper function to conver a code to a number.
number_from_code(Code,Number):-
    Number is Code - 48.

% helper function to read a number to the console - calls a recursive function with more parameters
read_number(X):-
    read_number(0,false,X).

% helper funtion to tell if a char code is a number code
is_number_code(C,true):-
    C > 47, 
    C < 58.
is_number_code(C,false):-
    C < 48. 
is_number_code(C,false):- 
    C > 57.

% reads a number from the console digit by digit. Stops if the character read isn't a number
read_number(Acc,_,X):-
    get_code(C),
    is_number_code(C,true),
    !,
    Acc1 is Acc*10 + C - 48,
    validate_next_character(Acc1,X).

% base case: return the value
read_number(Acc,true,Acc).

% my complicated addition to make it so that the read_number function ends if the user clicks a single new line, instead of 2. It checks if the next character is a number, and only if it is does it call read_number.
validate_next_character(X,X):-
    peek_code(C),
    \+ is_number_code(C,true).

validate_next_character(Acc,X):-
    peek_code(C),
    is_number_code(C,true),
    read_number(Acc,true,X).


% not used.
read_until_between(Min,Max,Value):-
    repeat,
    read_number(Value),
    Value >= Min,
    Value =< Max,
    !.


% prints the board size question
input_form(ChurnVariant,P1Type,P2Type,GameConfig):-    
    write('Board size: '),
    read_number(Size),
    skip_line,!,
    validate(Size,ChurnVariant,P1Type,P2Type,GameConfig).     

% prints the churn question
input_form(P1Type,P2Type,GameConfig):-    
    write('Churn variant (1 - default, 2 - medium, 3 - high): '),
    get_code(ChurnVariant),
    skip_line,
    number_from_code(ChurnVariant,Number),!,
    validate(Number,P1Type,P2Type,GameConfig).


% prints the difficulty question
input_form_difficulty(P1Type,P2Type,GameConfig):-    
    write('Difficulty level(1/2): '),
    get_code(DifficultyLevel),
    skip_line,!,
    number_from_code(DifficultyLevel,Number),
    validate_difficulty(Number,P1Type,P2Type,GameConfig).

input_form_difficulty(P1Type,GameConfig):-    
    write('Difficulty level(1/2): '),
    get_code(DifficultyLevel),
    skip_line,!,
    number_from_code(DifficultyLevel,Number),
    validate_difficulty(Number,P1Type,GameConfig).



input_form(P1Type,GameConfig):-
    write('Player 2 type ((H)uman/(C)omputer): '),
    get_char(P2Type),
    skip_line,!,
    validate(P1Type,P2Type,GameConfig).
    
% prints the human/computer question
input_form(GameConfig):-
    write('Player 1 type ((H)uman/(C)omputer): '),
    get_char(P1Type),
    skip_line,!,
    validate(P1Type,GameConfig).

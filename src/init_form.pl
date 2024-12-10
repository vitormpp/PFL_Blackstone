


% helper function that validates the input from the question of whether each player is a human or a computer. If the input is valid, it moves on to the next part of the input form 
validate_type(P1Type,P2Type,GameConfig):-
    member(P1Type,['C','H']),
    member(P2Type,['C','H']),!, 
    input_form_2(P1Type,P2Type,GameConfig).
% Otherwise it repeats the question.
validate_type(_,_,GameConfig):- write('Invalid input.\n'), input_form_start(GameConfig).
% ----


% validates the answer to the difficulty question and moves on to the next question.
validate_difficulty(DifficultyLevel,P1Type,P2Type,GameConfig):-
    member(DifficultyLevel,[1,2]),!,
    input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig).
% if the input isn't valid, it repeats the question.
validate_difficulty(_,P1Type,P2Type,GameConfig):- write('Invalid input.\n'), input_form_2(P1Type,P2Type,GameConfig).

%---

% validates the answer to the churn question and moves on to the next question
validate_churn(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-
    member(ChurnVariant,[1,2,3]),!,
    input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).
% if the check fails, repeat the question.
validate_churn(_,DifficultyLevel,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig).
%---

% validates the answer to the board size question and moves on to the next question. 
validate_size(Size,ChurnVariant,DifficultyLevel,P1Type,P2Type,gameConfig(P1Type,P2Type,DifficultyLevel,ChurnVariant,Size)):-
    Size>=6,!.
% if the answer isn't valid, repeat the question.
validate_size(_,ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).

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
input_form_4(ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig):-    
    write('Board size: '),
    read_number(Size),
    skip_line,!,
    validate_size(Size,ChurnVariant,DifficultyLevel,P1Type,P2Type,GameConfig).     

% prints the churn question
input_form_3(DifficultyLevel,P1Type,P2Type,GameConfig):-    
    write('Churn variant (1 - default, 2 - medium, 3 - high): '),
    get_code(ChurnVariant),
    skip_line,
    number_from_code(ChurnVariant,Number),!,
    validate_churn(Number,DifficultyLevel,P1Type,P2Type,GameConfig).


% prints the difficulty question
input_form_2(P1Type,P2Type,GameConfig):-    
    write('Difficulty level(1/2): '),
    get_code(DifficultyLevel),
    skip_line,!,
    number_from_code(DifficultyLevel,Number),
    validate_difficulty(Number,P1Type,P2Type,GameConfig).


% prints the human/computer question
input_form_start(GameConfig):-
    write('Game type (H)uman/(C)omputer, H/H,C/C,C/H: '),
    get_char(P1Type),
    get_char(_),
    get_char(P2Type),
    skip_line,!,
    validate_type(P1Type,P2Type,GameConfig).

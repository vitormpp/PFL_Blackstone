/*
    File: init_form.pl
    Description: This file contains the predicates that are used to initialize the game.
*/

% main_menu_evaluate(+Option)
% main_menu_evaluate/1 evaluates the option chosen by the user in the main menu.
main_menu_evaluate('1'):-
    !,input_form(GameConfig),
    initial_state(GameConfig, GameState),
    gameloop(GameState).
main_menu_evaluate('2'):-
    !,write('Blackstone is a two-player game designed by Blackstone in March 2024. It is played on a square board of any even size.\nStarting with the red player, each player can, in each turn, move one of their own pieces any number of steps in an unobstructed horizontal, vertical or diagonal path. Before the other moves, a x piece is placed on the square the moved piece had originally been.\nIf a r or b piece is unnable to move, it is removed. In the medium churn variant, all x pieces surrounding it are removed as well. In the high churn variant, all x pieces are eliminated.\nA player wins when all of their oponent\'s pieces are eliminated.\n'),
    play.
main_menu_evaluate('3'):-!.
main_menu_evaluate(_):- 
    write('Invalid input!\n'),
    play.


validate(P1Type,GameConfig):-
    member(P1Type,['C']),!, 
    input_form_difficulty(GameConfig).

validate(P1Type,GameConfig):-
    member(P1Type,['H']),!, 
    input_form(player(h,'r'),GameConfig).
validate(_,GameConfig):-
    write('Invalid input!\n'),
    input_form(GameConfig).



validate(P1Type,P2Type,GameConfig):-
        member(P2Type,['C']),!, 
        input_form_difficulty(P1Type,GameConfig).
    
validate(P1Type,P2Type,GameConfig):-
        member(P2Type,['H']),!, 
        input_form(P1Type,player(h,'b'),GameConfig).
validate(P1Type,_,GameConfig):-
    write('Invalid input!\n'),
    input_form(P1Type,GameConfig).
    


% validates the answer to the difficulty question and moves on to the next question.
validate_difficulty(P1Type,DifficultyLevel,GameConfig):-
    member(DifficultyLevel,[1,2]),!,
    input_form(P1Type,player(c-DifficultyLevel,'b'),GameConfig).
% if the input isn't valid, it repeats the question.
validate_difficulty(_,P1Type,GameConfig):- write('Invalid input.\n'), input_form(P1Type,GameConfig).

validate_difficulty(DifficultyLevel,GameConfig):-
    member(DifficultyLevel,[1,2]),!,
    input_form(player(c-DifficultyLevel,'r'),GameConfig).

% if the input isn't valid, it repeats the question.
validate_difficulty(_,GameConfig):- write('Invalid input.\n'), input_form(GameConfig).

%---

% validates the answer to the churn question and moves on to the next question
validate(ChurnVariant,P1Type,P2Type,GameConfig):-
    member(ChurnVariant,[1,2,3]),
    write(ChurnVariant), 
    input_form(ChurnVariant,P1Type,P2Type,GameConfig).
% if the check fails, repeat the question.
validate(_,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form(P1Type,P2Type,GameConfig).
%---

% validates the answer to the board size question and moves on to the next question. 
validate(Size,ChurnVariant,P1Type,P2Type,gameConfig(P1Type,P2Type,ChurnVariant,Size)):-
    Size>=6, 0 is Size mod 2,!.
% if the answer isn't valid, repeat the question.
validate(_,ChurnVariant,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form(ChurnVariant,P1Type,P2Type,GameConfig).

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

read_next_if_new_line:- !, peek_char('\n'),get_char(_).
read_next_if_new_line.

read_number_if_not_new_line(X,X):-peek_char('\n'),!.
read_number_if_not_new_line(Acc,X):-
    peek_char(C),!,
    C\='\n',
    read_number(Acc,true,X).

validate_number_code(C,Acc,_,X):-
    is_number_code(C,true),
    !,
    number_from_code(C,Number),
    Acc1 is Acc*10 + Number,
    read_number_if_not_new_line(Acc1,X).
    
validate_number_code(C,0,false,X):- 
    \+ is_number_code(C,true),!,
    read_next_if_new_line,
    write('Invalid input! Please input a number!\n'),
    read_number(0,false,X).
%this case breaks if newline...

validate_number_code(C,X,true,X):-
    \+ is_number_code(C,true),!,
    skip_line.



read_number(Acc,true,X):-
    get_code(C),!,
    validate_number_code(C,Acc,true,X).
   

read_number(Acc,false,X):-
    peek_char(Next),
    Next\='\n',
    get_code(C),!,
    validate_number_code(C,Acc,false,X).
read_number(Acc,false,X):-
    peek_char('\n'),skip_line,write('Invalid input! Please write a number!\n'),
    read_number(Acc,false,X).

% base case: return the value
read_number(Acc,true,Acc):-write(end).


% prints the board size question
input_form(ChurnVariant,P1Type,P2Type,GameConfig):-    
    write('Board size: \n'),
    read_number(Size),
    skip_line,!,
    validate(Size,ChurnVariant,P1Type,P2Type,GameConfig).     




% prints the churn question
input_form(P1Type,P2Type,GameConfig):-    
    write('Churn variant (1 - default, 2 - medium, 3 - high): \n'),
    read_number(ChurnVariant),
    skip_line,!,
    validate(ChurnVariant,P1Type,P2Type,GameConfig).



% prints the difficulty question
input_form_difficulty(P1Type,GameConfig):-    
    write('Difficulty level(1/2): \n'),
    read_number(DifficultyLevel),!,skip_line,
    validate_difficulty(P1Type,DifficultyLevel,GameConfig).
input_form_difficulty(P1Type,GameConfig):-    
    !, write('Invalid input!\n'),
    input_form_difficulty(P1Type,GameConfig).

input_form_difficulty(GameConfig):-    
    write('Difficulty level(1/2): \n'),
    read_number(DifficultyLevel),!,skip_line,
    validate_difficulty(DifficultyLevel,GameConfig).

input_form_difficulty(GameConfig):-    
    !, write('Invalid input!\n'),
    input_form_difficulty(GameConfig).


input_form(P1Type,GameConfig):-
    write('Player 2 type ((H)uman/(C)omputer): \n'),
    get_char(P2Type),
    skip_line,!,
    validate(P1Type,P2Type,GameConfig).
    
% prints the human/computer question
input_form(GameConfig):-
    write('Player 1 type ((H)uman/(C)omputer): \n'),
    get_char(P1Type),
    skip_line,!,
    validate(P1Type,GameConfig).

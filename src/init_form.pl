/*
    File: init_form.pl
    Description: This file contains the predicates that are used to initialize the game.
*/

% main_menu_evaluate(+Option)
% main_menu_evaluate/1 evaluates the option chosen by the user in the main menu.
main_menu_evaluate('1'):- %starting the game
    !,input_form(GameConfig),
    initial_state(GameConfig, GameState),
    gameloop(GameState).

main_menu_evaluate('2'):- %printing the game description
    !,write('Blackstone is a two-player game designed by Blackstone in March 2024. It is played on a square board of any even size.\nStarting with the red player, each player can, in each turn, move one of their own pieces any number of steps in an unobstructed horizontal, vertical or diagonal path. Before the other moves, a x piece is placed on the square the moved piece had originally been.\nIf a r or b piece is unnable to move, it is removed. In the medium churn variant, all x pieces surrounding it are removed as well. In the high churn variant, all x pieces are eliminated.\nA player wins when all of their oponent\'s pieces are eliminated.\n'),
    play.
main_menu_evaluate('3'):-!. % quitting the game
main_menu_evaluate(_):- % invalid option - repeats the "question"
    write('Invalid input!\n'),
    play.

% validate(+P1Type, -GameConfig)
% validate/2 evaluates whether the first player type input was valid, and proceeds to the appropriate question afterwards.
validate('C',GameConfig):- % computer player - asks for a difficulty value 
    !, 
    input_form_difficulty(GameConfig).

validate('H',GameConfig):- %player is human - proceeds to second player question
    !, 
    input_form(player(h,'r'),GameConfig).
validate(_,GameConfig):- % invalid input - repeats first player question
    write('Invalid input!\n'),
    input_form(GameConfig).


% validate(+P1Type, +P2Type, -GameConfig)
% validate/2 evaluates whether the second player type input was valid, and proceeds to the appropriate question afterwards.
validate(P1Type,'C',GameConfig):- % computer player - asks for a difficulty value
        input_form_difficulty(P1Type,GameConfig).
    
validate(P1Type,'H',GameConfig):- %player is human - proceeds to churn variant question
        input_form(P1Type,player(h,'b'),GameConfig).
validate(P1Type,_,GameConfig):- % invalid input - repeats second player question
    write('Invalid input!\n'),
    input_form(P1Type,GameConfig).
    


% validate_difficulty(+P1Type, +DifficultyLevel -GameConfig)
% validate_difficulty/3 validates the answer to the difficulty question for a player two computer and moves on to the churn variant question.
validate_difficulty(P1Type,DifficultyLevel,GameConfig):-
    member(DifficultyLevel,[1,2,3,4]),!,
    input_form(P1Type,player(c-DifficultyLevel,'b'),GameConfig).
% if the input isn't valid, it repeats the question.
validate_difficulty(_,P1Type,GameConfig):- write('Invalid input.\n'), input_form(P1Type,GameConfig).

% validate_difficulty( +DifficultyLevel -GameConfig)
% validate_difficulty/3 validates the answer to the difficulty question for a player one computer and moves on to the second player type question.
validate_difficulty(DifficultyLevel,GameConfig):-
    member(DifficultyLevel,[1,2,3,4]),!,
    input_form(player(c-DifficultyLevel,'r'),GameConfig).

% if the input isn't valid, it repeats the question.
validate_difficulty(_,GameConfig):- write('Invalid input.\n'), input_form(GameConfig).

%---

% validate(ChurnVariant,P1Type,P2Type,GameConfig):-
% validate\4 validates the answer to the churn question and moves on to the board size question
validate(ChurnVariant,P1Type,P2Type,GameConfig):-
    member(ChurnVariant,[1,2,3]),
    input_form(ChurnVariant,P1Type,P2Type,GameConfig).
% if the check fails, repeat the question.
validate(_,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form(P1Type,P2Type,GameConfig).
%---

% validate(+Size, +ChurnVariant, +P1Type, +P2Type, -GameConfig):-
% validates the answer to the board size question. If the input so far is valid, gameConfig(P1Type,P2Type,ChurnVariant,Size) is unified with GameConfig. 
validate(Size,ChurnVariant,P1Type,P2Type,gameConfig(P1Type,P2Type,ChurnVariant,Size)):-
    Size>=6,Size<100, 0 is Size mod 2,!.
% if the answer isn't valid, repeat the question.
validate(_,ChurnVariant,P1Type,P2Type,GameConfig):-
    write('Invalid input.\n'),
    input_form(ChurnVariant,P1Type,P2Type,GameConfig).

% number_from_code(+Code, -Number)
% number_from_code/2 is a helper predicate to conver a character code that corresponds to a digit to a number.
number_from_code(Code,Number):-
    Number is Code - 48.

% read_number(-X)
% read_number/1 is a helper predicate to read a number from the console. It calls a recursive predicate with more parameters. The predicate will loop until it reads at least one digit, whereupon it will only read until the next non-digit character.
read_number(X):-
    read_number(0,false,X).

% is_number_code(+C, -Val) 
% is_number_code/2 is a helper funtion to determine whether a character code corresponds to a digit
is_number_code(C,true):-
    C > 47, 
    C < 58.
is_number_code(C,false):-
    C < 48. 
is_number_code(C,false):- 
    C > 57.


% read_number_if_not_new_line(+Acc, -X)
% read_number_if_not_new_line/2 is an helper predicate that determines whether the read_number/3 predicate should continue its iteration. 
read_number_if_not_new_line(X,X):-peek_char('\n'),!.
read_number_if_not_new_line(Acc,X):-
    peek_char(C),!,
    C\='\n',
    read_number(Acc,true,X).


% validate_number_code(+C, +Acc, +Val, -X)
% validate_number_code/4 determines what happens after a character is read in read_number/3, depending on whether it is a digit or not, and whether there have been previous digit characters. 
validate_number_code(C,Acc,_,X):- % if it's a digit, continues iterating 
    is_number_code(C,true),
    !,
    number_from_code(C,Number),
    Acc1 is Acc*10 + Number,
    read_number_if_not_new_line(Acc1,X).
    
validate_number_code(C,0,false,X):- % if it's not a digit but no digit has been read so far, writes an invalid input message and tries to obtain a digit by repeating read_number/3
    is_number_code(C,false),
    peek_char('\n'),!,
    skip_line,
    write('Invalid input! Please input a number!\n'),
    read_number(0,false,X).


validate_number_code(C,0,false,X):- % if it's not a digit but no digit has been read so far, writes an invalid input message and tries to obtain a digit by repeating read_number/3
    is_number_code(C,false),
    peek_char(Next),!,
    Next\='\n',
    read_number(0,false,X).


validate_number_code(C,X,true,X):- % if it's not a digit and digits have been read, ends.
   is_number_code(C,false),!.



% read_number(+Acc, +Val,-X)
% read_number/3 repeatedly tries to read the console input until it has successfully read a number
read_number(Acc,true,X):- % if a digit has been read, proceed to validation regardless of character type
    get_code(C),!,
    validate_number_code(C,Acc,true,X).

% if no digit has been found and the next character isn't a new-line, proceed normally 
read_number(Acc,false,X):-
    peek_char(Next),
    Next\='\n',
    get_code(C),!,
    validate_number_code(C,Acc,false,X).
% if the next character is a new-line, ignore it and write an invalid input message. This fixes a bug where two new lines needed to be inserted for them to be flagged as incorrect. 
read_number(Acc,false,X):-
    peek_char('\n'),
    skip_line,
    write('Invalid input! Please write a number!\n'),
    read_number(Acc,false,X).


% input_form(+ChurnVariant, +P1Type, +P2Type, -GameConfig)    
% input_form/4 prints the board size question and handles the respective input.
input_form(ChurnVariant,P1Type,P2Type,GameConfig):-    
    write('Board size: \n'),
    read_number(Size),
    skip_line,!,
    validate(Size,ChurnVariant,P1Type,P2Type,GameConfig).     



% input_form(+P1Type, +P2Type, -GameConfig)    
% input_form/3 prints the churn question and handles the respective input.
input_form(P1Type,P2Type,GameConfig):-    
    write('Churn variant (1 - default, 2 - medium, 3 - high): \n'),
    read_number(ChurnVariant),
    skip_line,!,
    validate(ChurnVariant,P1Type,P2Type,GameConfig).



% input_form_difficulty(+P1Type, -GameConfig)    
% input_form_difficulty/2 prints the difficulty question for a second-player computer player and handles the respective input.
input_form_difficulty(P1Type,GameConfig):-    
    write('Difficulty level(1/2/3/4): \n'),
    read_number(DifficultyLevel),!,skip_line,
    validate_difficulty(P1Type,DifficultyLevel,GameConfig).
input_form_difficulty(P1Type,GameConfig):- % on invalid input, repeats the question    
    !, write('Invalid input!\n'),
    input_form_difficulty(P1Type,GameConfig).

% input_form_difficulty(-GameConfig)    
% input_form_difficulty/1 prints the difficulty question for a first-player computer player and handles the respective input.
input_form_difficulty(GameConfig):-    
    write('Difficulty level(1/2/3/4): \n'),
    read_number(DifficultyLevel),!,skip_line,
    validate_difficulty(DifficultyLevel,GameConfig).

input_form_difficulty(GameConfig):- % on invalid input, repeats the question        
    !, write('Invalid input!\n'),
    input_form_difficulty(GameConfig).


% input_form(+P1Type, -GameConfig)    
% input_form/2 prints the human/computer question for player 2.
input_form(P1Type,GameConfig):-
    write('Player 2 type ((H)uman/(C)omputer): \n'),
    get_char(P2Type),
    skip_line,!,
    validate(P1Type,P2Type,GameConfig).
    
% input_form(-GameConfig)    
% input_form/1 prints the human/computer question for player 1.
input_form(GameConfig):-
    write('Player 1 type ((H)uman/(C)omputer): \n'),
    get_char(P1Type),
    skip_line,!,
    validate(P1Type,GameConfig).

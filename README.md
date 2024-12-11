# pfl_project_2
##TODO:
- need to put difficulty level into gamestate.
- move initial game state creation functions into a different file, for consistency's sake.
- value(GameState, Player, Value) .
- choose_move(+GameState, +Level, -Move) -> I would like to do this pls




to check if we're on linux so we can use special characters and colors, we can use:


:- prolog_flag(host_type,Flag),atom_chars(Flag, List), append(_,[ 'l','i','n','u','x'| _],List), (do things that should only happen on linux - the best way is to consult a special linux-only file, because special characters cause the thing on windows to crash even if they're not executed.).

By the way, this readme will need to be changed, because it is supposed to include actual information about our actual code.
% create_list(+Element, +Size, -List)
create_list(_, 0, []).
create_list(Element, Size, [Element|Sublist]) :-
    Size > 0,
    Size1 is Size - 1,
    create_list(Element, Size1, Sublist).

% cycle(+N, +L1, -R)
cycle(0, _, []).
cycle(N, L1, R) :-
    N > 0,
    cycle_aux(N, L1, [], R).

% cycle_aux(+N, +L1, +Acc, -R)
cycle_aux(0, _, Acc, Acc).
cycle_aux(N, L1, Acc, R):-
    N > 0,
    N1 is N - 1,
    append(L1, Acc, Acc1),
    cycle_aux(N1, L1, Acc1, R).

% 
% A - habitacion donde esta el robot
% B y C - se le da el valor v si el robot tiene en la pinza la caja
% 1 o 2, respectivamente
% Evalua si el robot esta a la izquierda, y si lo esta, entonces pasa a la derecha y viceversa

pasar([A,B,C],Actual) :- 
    (A==i), Actual = [d,B,C].

pasar([A,B,C],Actual) :- 
    (A==d), Actual = [i,B,C].

% Establece (v) si el robot tiene la caja C1 o la C2

cogerC1([A,B,C],Actual) :- 
    (A==B),(C\==v), Actual = [A,v,C].

cogerC2([A,B,C],Actual) :- 
    (A==C),(B\==v), Actual = [A,B,v].

% Establece en que habitacion esta la caja al momento de soltarse

soltarC1([A,B,C],Actual) :- 
    (B==v), Actual = [A,A,C].

soltarC2([A,B,C],Actual) :- 
    (C==v), Actual = [A,B,A].

% La funcion heuristica recibe el estado actual y el estado objetivo

costoRobot([X,_,_],[Y,_,_], Score) :- 
    (X\==Y) , Score is 1.

costoRobot([X,_,_],[Y,_,_], Score) :- 
    (X==Y) , Score is 0.

costoC1([_,X,_],[_,Y,_], Score) :- 
    (X\==Y) , Score is 1.

costoC1([_,X,_],[_,Y,_], Score) :- 
    (X==Y) , Score is 0.

costoC2([_,_,X],[_,_,Y], Score) :- 
    (X\==Y) , Score is 1.

costoC2([_,_,X],[_,_,Y], Score) :- 
    (X==Y) , Score is 0.

heuristica(Actual, Goal, Costo, A,B,C):-
    costoRobot(Actual,Goal, A),
    costoC1(Actual,Goal, B),
    costoC2(Actual,Goal, C),
    Costo is A+B+C.

precedes([,,F1], [,,F2]) :- 
    F1 =< F2.

empty_set([]).  %set vacio
empty_sort_queue([]). % Cola de prioridad
insert_sort_queue(State, [], [State]).
insert_sort_queue(State, [H | T], [State, H | T]) :-
    precedes(State, H).
insert_sort_queue(State, [H|T], [H | T_new]) :-
    insert_sort_queue(State, T, T_new).
remove_sort_queue(First, [First|Rest], Rest). % Remover de la cola de prioridad
add_to_set(X, S, [X|S]).
add_to_set(X, S, S) :- member(X, S), !.  % Adicionar en el set
member_sort_queue(E, S) :- member(E, S). % Evaluar si es miembro de la cola de prioridad
member_set(E, S) :- member(E, S). % Evaluar si es miembro del set

state_record(State, Parent, G, H, F, [State, Parent, G, H, F]).

aestrella(Start, Goal) :-
    empty_set(Closed), % Lista de los estados que hacen parte del camino correcto
    empty_sort_queue(Empty_open), % Lista de los estados que no hacen parte del camino correcto, ordernada
    heuristica(Start, Goal, H,_,_,_),% Se calcula la heuristica del estado actual frente al estado final
    state_record(Start, nil, 0, H, H, EstadoInicial_record), % Se guarda toda la info. del estadoInicial
    insert_sort_queue(EstadoInicial_record, Empty_open, Open),
    path(Open,Closed,Goal).
    % si la cola de prioridad esta vacia, es que no se ha encontrado solucion

path(Open_pq,_,_) :-
       empty_sort_queue(Open_pq),
       write('No se encontro solucion.').

path(Open, Closed, Goal) :-
    remove_sort_queue(First_record, Open, _),
    state_record(State, _, _, _, _, First_record),
    State = Goal,
    write('El camino de la solucion es: '), nl,
    printsolution(First_record, Closed).

path(Open, Closed, Goal) :-
    remove_sort_queue(First_record, Open, Rest_of_open),
    (bagof(Child, moves(First_record, Open, Closed, Child, Goal), Children);Children = []), 
    insert_list(Children, Rest_of_open, New_open), 
    add_to_set(First_record, Closed, New_closed),
    printsolution(First_record, Closed),
    path(New_open, New_closed, Goal),!. 

moves(State_record, Open, Closed,Child, Goal) :-
    state_record(State,_,G,_,_,State_record),
    pasar(State, Next),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristica(Next, Goal, H,_,_,_),
    F is G_new + H,
    state_record(Next, State, G_new, H, F, Child).
    %Guarda toda la info de un child

moves(State_record, Open, Closed,Child, Goal) :-
    state_record(State,_,G,_,_,State_record),
    cogerC1(State, Next),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristica(Next, Goal, H,_,_,_),
    F is G_new + H,
    state_record(Next, State, G_new, H, F, Child).

moves(State_record, Open, Closed,Child, Goal) :-
    state_record(State,_,G,_,_,State_record),
    cogerC2(State, Next),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristica(Next, Goal, H,_,_,_),
    F is G_new + H,
    state_record(Next, State, G_new, H, F, Child).

moves(State_record, Open, Closed,Child, Goal) :-
    state_record(State,_,G,_,_,State_record),
    soltarC2(State, Next),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristica(Next, Goal, H,_,_,_),
    F is G_new + H,
    state_record(Next, State, G_new, H, F, Child).

moves(State_record, Open, Closed,Child, Goal) :-
    state_record(State,_,G,_,_,State_record),
    soltarC1(State, Next),
    state_record(Next, _, _, _, _, Test),
    not(member_sort_queue(Test, Open)),
    not(member_set(Test, Closed)),
    G_new is G + 1,
    heuristica(Next, Goal, H,_,_,_),
    F is G_new + H,
    state_record(Next, State, G_new, H, F, Child).

insert_list([], L, L).
insert_list([State | Tail], L, New_L) :-
    insert_sort_queue(State, L, L2),
    insert_list(Tail, L2, New_L).

    % imprime la solucion
printsolution(Next_record, _):-
    state_record(State, nil, G,_,_,Next_record),
    write(State+G), nl.

printsolution(Next_record, Closed) :-
    state_record(State, Parent, G,_,_, Next_record),
    state_record(Parent, _, _, _, _, Parent_record),
    member_set(Parent_record, Closed),
    printsolution(Parent_record, Closed),
    write(State+G), nl.
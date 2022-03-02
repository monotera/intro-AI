% Codigo Grupo 5
% Nelson Mosquera
% Sebastián Ruiz
% David Castillo
% Uso: ejemplo: busqueda([d,d,d],[i,i,i]) En este caso, el estado inicial (primer argumento) es el robot y las cajas estan en la derecha 
% y el estado final (segundo argumento) el robot y las cajas pasen a estar en la izquierda

% A - es la habitacion donde esta el robot
% B y C - son las cajas. Se le da el valor de v si el robot tiene en la pinza la caja 1 o 2, respectivamente

busqueda(Inicio, Meta) :-
    vaciar_set(Cerrado), % Cerrado es la lista de los estados que hacen parte del camino correcto
    vaciar_cola_ordenada(Empty_open), % Empty_open es la lista de los estados que no hacen parte del camino correcto, ordernada
    heuristica(Inicio, Meta, H,_,_,_),% Se calcula la heuristica del estado actual frente al estado final
    guardar_estado(Inicio, nil, 0, H, H, EstadoInicial_record), % Se guarda toda la info. del estadoInicial
    insertar_cola_ordenada(EstadoInicial_record, Empty_open, Abierto),
    ruta(Abierto,Cerrado,Meta).
    % si la cola de prioridad esta vacia, es que no se ha encontrado una solucion

% La funcion heuristica recibe el estado actual y el estado objetivo. Se calcula el costo teniendo en cuenta el estado (estado inicial y final) de los elementos (robot y cajas) 
% Se suma un 1 si los estados cambian, y 0 si los estados quedan iguales.
heuristica(Actual, Meta, Costo, A,B,C):-
    costoRobot(Actual,Meta, A),
    costoC1(Actual,Meta, B),
    costoC2(Actual,Meta, C),
    Costo is A+B+C.
% Se verifica que el robot y la caja estén en la misma habitación (i o d), y se pone (v) si el robot tiene la caja C1 o la C2

cogerC1([A,B,C],Actual) :- 
    (A==B),(C\==v), Actual = [A,v,C].

cogerC2([A,B,C],Actual) :- 
    (A==C),(B\==v), Actual = [A,B,v].

% Se verificar que la caja esta en la pinza del robot y se suelta en la misma habitacion donde este el robot.
soltarC1([A,B,C],Actual) :- 
    (B==v), Actual = [A,A,C].

soltarC2([A,B,C],Actual) :- 
    (C==v), Actual = [A,B,A].
% Se verifica si el robot esta a la izquierda o la a derecha, y si lo esta cambia de posicion
% El robot esta a la izquierda si A es i o esta a la derecha si A es d

pasar([A,B,C],Actual) :- 
    (A==i), Actual = [d,B,C].

pasar([A,B,C],Actual) :- 
    (A==d), Actual = [i,B,C].


costoRobot([X,_,_],[Y,_,_], Puntaje) :- 
    (X\==Y) , Puntaje is 1.

costoRobot([X,_,_],[Y,_,_], Puntaje) :- 
    (X==Y) , Puntaje is 0.

costoC1([_,X,_],[_,Y,_], Puntaje) :- 
    (X\==Y) , Puntaje is 1.

costoC1([_,X,_],[_,Y,_], Puntaje) :- 
    (X==Y) , Puntaje is 0.

costoC2([_,_,X],[_,_,Y], Puntaje) :- 
    (X\==Y) , Puntaje is 1.

costoC2([_,_,X],[_,_,Y], Puntaje) :- 
    (X==Y) , Puntaje is 0.
    
mover(Estado_guardado, Abierto, Cerrado,Child, Meta) :-
    guardar_estado(Estado,_,G,_,_,Estado_guardado),
    pasar(Estado, Siguiente),
    guardar_estado(Siguiente, _, _, _, _, Test),
    not(cola_ordenada_miembros(Test, Abierto)),
    not(set_miembro(Test, Cerrado)),
    G_new is G + 1,
    heuristica(Siguiente, Meta, H,_,_,_),
    F is G_new + H,
    guardar_estado(Siguiente, Estado, G_new, H, F, Child).
    %Guarda toda la info de un child

mover(Estado_guardado, Abierto, Cerrado,Child, Meta) :-
    guardar_estado(Estado,_,G,_,_,Estado_guardado),
    cogerC1(Estado, Siguiente),
    guardar_estado(Siguiente, _, _, _, _, Test),
    not(cola_ordenada_miembros(Test, Abierto)),
    not(set_miembro(Test, Cerrado)),
    G_new is G + 1,
    heuristica(Siguiente, Meta, H,_,_,_),
    F is G_new + H,
    guardar_estado(Siguiente, Estado, G_new, H, F, Child).

mover(Estado_guardado, Abierto, Cerrado,Child, Meta) :-
    guardar_estado(Estado,_,G,_,_,Estado_guardado),
    cogerC2(Estado, Siguiente),
    guardar_estado(Siguiente, _, _, _, _, Test),
    not(cola_ordenada_miembros(Test, Abierto)),
    not(set_miembro(Test, Cerrado)),
    G_new is G + 1,
    heuristica(Siguiente, Meta, H,_,_,_),
    F is G_new + H,
    guardar_estado(Siguiente, Estado, G_new, H, F, Child).

mover(Estado_guardado, Abierto, Cerrado,Child, Meta) :-
    guardar_estado(Estado,_,G,_,_,Estado_guardado),
    soltarC2(Estado, Siguiente),
    guardar_estado(Siguiente, _, _, _, _, Test),
    not(cola_ordenada_miembros(Test, Abierto)),
    not(set_miembro(Test, Cerrado)),
    G_new is G + 1,
    heuristica(Siguiente, Meta, H,_,_,_),
    F is G_new + H,
    guardar_estado(Siguiente, Estado, G_new, H, F, Child).

mover(Estado_guardado, Abierto, Cerrado,Child, Meta) :-
    guardar_estado(Estado,_,G,_,_,Estado_guardado),
    soltarC1(Estado, Siguiente),
    guardar_estado(Siguiente, _, _, _, _, Test),
    not(cola_ordenada_miembros(Test, Abierto)),
    not(set_miembro(Test, Cerrado)),
    G_new is G + 1,
    heuristica(Siguiente, Meta, H,_,_,_),
    F is G_new + H,
    guardar_estado(Siguiente, Estado, G_new, H, F, Child).


aux_ord([,,F1], [,,F2]) :- 
    F1 =< F2.

vaciar_set([]).  %set vacio
vaciar_cola_ordenada([]). % Cola de prioridad
insertar_cola_ordenada(Estado, [], [Estado]).
insertar_cola_ordenada(Estado, [H | T], [Estado, H | T]) :-
    aux_ord(Estado, H).
insertar_cola_ordenada(Estado, [H|T], [H | T_new]) :-
    insertar_cola_ordenada(Estado, T, T_new).
eliminar_cola_ordenada(First, [First|Rest], Rest). % Remover de la cola de prioridad
agregar_al_set(X, S, [X|S]).
agregar_al_set(X, S, S) :- member(X, S), !.  % Adicionar en el set
cola_ordenada_miembros(E, S) :- member(E, S). % Evaluar si es miembro de la cola de prioridad
set_miembro(E, S) :- member(E, S). % Evaluar si es miembro del set

guardar_estado(Estado, Padre, G, H, F, [Estado, Padre, G, H, F]).


ruta(Cola_ordenada_abierta,_,_) :-
       vaciar_cola_ordenada(Cola_ordenada_abierta),
       write('No se encontro solucion.').

ruta(Abierto, Cerrado, Meta) :-
    eliminar_cola_ordenada(First_record, Abierto, _),
    guardar_estado(Estado, _, _, _, _, First_record),
    Estado = Meta,
    write('El camino de la solucion es: '), nl,
    imprimir_solucion(First_record, Cerrado).

ruta(Abierto, Cerrado, Meta) :-
    eliminar_cola_ordenada(First_record, Abierto, Rest_of_open),
    (bagof(Child, mover(First_record, Abierto, Cerrado, Child, Meta), Children);Children = []), 
    insertar_lista(Children, Rest_of_open, New_open), 
    agregar_al_set(First_record, Cerrado, New_closed),
    imprimir_solucion(First_record, Cerrado),
    ruta(New_open, New_closed, Meta),!. 

insertar_lista([], L, L).
insertar_lista([Estado | Cola], L, New_L) :-
    insertar_cola_ordenada(Estado, L, L2),
    insertar_lista(Cola, L2, New_L).

    % imprime la solucion
imprimir_solucion(Siguiente_guardado, _):-
    guardar_estado(Estado, nil, G,_,_,Siguiente_guardado),
    write(Estado+G), nl.

imprimir_solucion(Siguiente_guardado, Cerrado) :-
    guardar_estado(Estado, Padre, G,_,_, Siguiente_guardado),
    guardar_estado(Padre, _, _, _, _, Padre_guardado),
    set_miembro(Padre_guardado, Cerrado),
    imprimir_solucion(Padre_guardado, Cerrado),
    write(Estado+G), nl.
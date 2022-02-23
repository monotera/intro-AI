Realizado por: David Castillo, Nelson Mosquera Y Sebastián Ruiz

Instrucciones:

Al correr el programa, lo primero que se va a indicar son las posiciones del tablero (Figura 1). Luego, se preguntará quién empieza; siendo el 1 para el jugador y 2 para la IA (Las X son para la IA y las O para el jugador). Dependiendo de quién empieza se hará el siguiente movimiento. Si empieza la IA se mostrará el tablero, la jugada, la IA notifica que ya jugó y se pide al jugador que seleccione un número de 1 al 9 que son las casillas del triqui donde se pondrá la O. 
Por otro lado, si empieza el jugador se le muestra el tablero inicial y se le pregunta que casilla quiere seleccionar (1-9), 
se pone la O en el lugar, se muestra el tablero con el movimiento, y es turno de la IA y así continua el juego en ambos casos. Si el jugador ingresa una posición donde la IA ya tiene la X esta posición será inválida y se le pedirá ingresar una nueva.

Según como fue codificado el juego la IA no puede perder, por lo que el jugador tiene la posibilidad de empatar o perder el juego. 
	1|2|3					 | |			X| |			 |O| 
	-----					-----			-----			-----
	4|5|6 					 | |			 | | 			 | |
	-----					-----			-----			-----
	7|8|9					 | | 			 | |			 | |

   Figura 1.Posiciones 		Figura 2. Tablero		Figura 3. Jugada 	Figura 4. Jugada ejemplo
	tablero triqui.   			inicial			jugador IA		jugador pesrsona


		X|O|O				X|O|X	
		-----				-----
		O|X|O				O|X|O
		-----				-----
		O|O|X				O|X|O
	Figura 5.Victoria 		Figura 6.Empate
	Jugador IA			entre los jugadores
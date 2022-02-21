tablero = {1: ' ', 2: ' ', 3: ' ',
           4: ' ', 5: ' ', 6: ' ',
           7: ' ', 8: ' ', 9: ' '}
player = '⭕'
bot = '❌'
           
def imprimirTablero(tablero):
    print(tablero[1] + '│' + tablero[2] + '│' + tablero[3])
    print('-+-+-')
    print(tablero[4] + '│' + tablero[5] + '│' + tablero[6])
    print('-+-+-')
    print(tablero[7] + '│' + tablero[8] + '│' + tablero[9])
    print("\n\n")


def espacioVacio(pos):
    if tablero[pos] == ' ':
        return True
    else:
        return False


def insertarJugada(letra, posicion):
    if espacioVacio(posicion):
        tablero[posicion] = letra
        imprimirTablero(tablero)
        if (validarEmpate()):
            print("Empate!")
            exit()
        if validarGanador():
            if letra == '❌':
                print("IA gana!")
                exit()
            else:
                print("Jugador gana!")
                exit()

        return


    else:
        print("Movimiento invalido!")
        posicion = int(input("Por favor ingrese una nueva posición:  "))
        insertarJugada(letra, posicion)
        return


def validarGanador():
    if (tablero[1] == tablero[2] and tablero[1] == tablero[3] and tablero[1] != ' '):
        return True
    elif (tablero[4] == tablero[5] and tablero[4] == tablero[6] and tablero[4] != ' '):
        return True
    elif (tablero[7] == tablero[8] and tablero[7] == tablero[9] and tablero[7] != ' '):
        return True
    elif (tablero[1] == tablero[4] and tablero[1] == tablero[7] and tablero[1] != ' '):
        return True
    elif (tablero[2] == tablero[5] and tablero[2] == tablero[8] and tablero[2] != ' '):
        return True
    elif (tablero[3] == tablero[6] and tablero[3] == tablero[9] and tablero[3] != ' '):
        return True
    elif (tablero[1] == tablero[5] and tablero[1] == tablero[9] and tablero[1] != ' '):
        return True
    elif (tablero[7] == tablero[5] and tablero[7] == tablero[3] and tablero[7] != ' '):
        return True
    else:
        return False


def comprobarEmoticonGanador(mark):
    if tablero[1] == tablero[2] and tablero[1] == tablero[3] and tablero[1] == mark:
        return True
    elif (tablero[4] == tablero[5] and tablero[4] == tablero[6] and tablero[4] == mark):
        return True
    elif (tablero[7] == tablero[8] and tablero[7] == tablero[9] and tablero[7] == mark):
        return True
    elif (tablero[1] == tablero[4] and tablero[1] == tablero[7] and tablero[1] == mark):
        return True
    elif (tablero[2] == tablero[5] and tablero[2] == tablero[8] and tablero[2] == mark):
        return True
    elif (tablero[3] == tablero[6] and tablero[3] == tablero[9] and tablero[3] == mark):
        return True
    elif (tablero[1] == tablero[5] and tablero[1] == tablero[9] and tablero[1] == mark):
        return True
    elif (tablero[7] == tablero[5] and tablero[7] == tablero[3] and tablero[7] == mark):
        return True
    else:
        return False


def validarEmpate():
    for key in tablero.keys():
        if (tablero[key] == ' '):
            return False
    return True


def movimientoJugador():
    posicion = int(input("Ingrese la posicion para 'O':  "))
    insertarJugada(player, posicion)
    return


def turnoComputador():
    print("Turno de la IA")
    mejorPuntuacion = -800
    mejorMovimiento = 0
    for key in tablero.keys():
        if (tablero[key] == ' '):
            tablero[key] = bot
            puntuacion = minimax(tablero, 0, False)
            tablero[key] = ' '
            if (puntuacion > mejorPuntuacion):
                mejorPuntuacion = puntuacion
                mejorMovimiento = key

    insertarJugada(bot, mejorMovimiento)
    return


def minimax(tablero, profundidad, isMaximizing):
    if (comprobarEmoticonGanador(bot)):
        return 1
    elif (comprobarEmoticonGanador(player)):
        return -1
    elif (validarEmpate()):
        return 0

    if (isMaximizing):
        mejorPuntuacion = -800
        for key in tablero.keys():
            if (tablero[key] == ' '):
                tablero[key] = bot
                puntuacion = minimax(tablero, profundidad + 1, False)
                tablero[key] = ' '
                if (puntuacion > mejorPuntuacion):
                    mejorPuntuacion = puntuacion
        return mejorPuntuacion

    else:
        mejorPuntuacion = 800
        for key in tablero.keys():
            if (tablero[key] == ' '):
                tablero[key] = player
                puntuacion = minimax(tablero, profundidad + 1, True)
                tablero[key] = ' '
                if (puntuacion < mejorPuntuacion):
                    mejorPuntuacion = puntuacion
        return mejorPuntuacion

def __main__():
    imprimirTablero(tablero)
    print("Las posiciones son las siguientes:")
    print("1, 2, 3 ")
    print("4, 5, 6 ")
    print("7, 8, 9 ")
    print("\n")

    emp = int(input("Empieza: \n1. Jugador \n2. IA \n"))

    while not validarGanador():
        if emp == 1:
            movimientoJugador()
            turnoComputador()
        else:
            turnoComputador()
            movimientoJugador()
            
__main__()
import json

"""
Ejemplo: 
reglas = [
    ["S", ["Z", "and", "L"]],
    ["E", ["A", "and", "N"]],
    ["Z", ["D", "or", "M"]],
    ["M", ["A"]],
    ["N", ["Q", "and", "notW", "and", "notZ"]],
    ["E", ["L", "and", "M"]],
    ["Q", ["B", "or", "C"]]
]

conocidos = ["A", "L"]
"""

# Extrae los datos del archivo data.json
with open('data.json') as json_file:
    data = json.load(json_file)
conocidos = data.get("conocidos")
reglas = data.get("reglas")
"""
Recibe una regla en formato ("S", ["Z", "and", "L"]) y traduce el segundo
arreglo en booleanos dependiendo si el hecho se encuentra en conocidos o no
Retorna un arreglo [False, "and", True]
"""


def transformar_regla_en_condicion(regla):
    aux = []
    for i in range(len(regla[1])):
        hecho_actual = regla[1][i]
        if hecho_actual != "and" and hecho_actual != "or":
            if "not" not in hecho_actual and hecho_actual in conocidos:
                aux.append(True)
            elif "not" in hecho_actual:
                hecho_actual = hecho_actual.replace("not", "")
                if hecho_actual not in conocidos:
                    aux.append(True)
                else:
                    aux.append(False)
            else:
                aux.append(False)
        else:
            aux.append(hecho_actual)
    return aux


"""
Recibe un condicional en un arreglo [True,"and",False,"or",True] y retorna el resultado de este condicional True.
Para esto toma los tres primeros elementos del condicional y los elimina del arreglo,
Evalua este sub condicion y concatena la respuesta al condicional original, se repite estre proceso hasta
Obtener un unico elemento en el arreglo
arreglo_original = [True,"and",False,"or",True]
valor1 = True
condicional = "and"
valor2 = False
arreglo_original = ["or",True]
respuesta = True and False
arreglo_original = [respuesta,"or",True]
valor1 = respuesta
condicional = "or"
valor2 = True
arreglo_original = []
respuesta = False or True
arreglo_original = [respuesta]
retorna respuesta(True)
"""


def validar_condicion(condicion):
    if len(condicion) == 1:
        return condicion[0]
    while len(condicion) > 1:
        valor1 = condicion[0]
        condicional = condicion[1]
        valor2 = condicion[2]
        condicion = condicion[3:]
        if condicional == "and":
            response = valor1 and valor2
        else:
            response = valor1 or valor2
        condicion.insert(0, response)

    return condicion[0]


"""
Recorre los hechos uno por uno y verifica si con ese hecho puede generar un nuevo conocido,
Si se puede generar un nuevo conocido, lo agrega al arreglo de conocidos.
Si recorrio todos los hechos sin encontrar un conocido nuevo, se acaba el ciclo o si ya no tiene hechos que recorrer
"""


def __main__():
    i = 0  # index usado para recorrer el arreglo
    j = 0  # index usado para verificar que no se haya dado una vuelta entera a los hechos, desde el ultimo hecho valido
    while j < len(reglas) and len(reglas) > 0:
        print("regla actual: ", reglas[i], "conocidos actual: ", conocidos)
        condicion = transformar_regla_en_condicion(reglas[i])
        print("regla actual transformada: ", condicion)
        if validar_condicion(condicion):
            conocidos.append(reglas[i][0])
            del reglas[i]
            j = 0
        else:
            i += 1
            j += 1
        if i == len(reglas):
            i = 0
    print("Respuesta: ", conocidos)


__main__()

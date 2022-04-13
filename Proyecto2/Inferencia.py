#Nelson Mosquera
#David Saavedra
fin = False

#Funcion que captura los datos de entrada; la sentencia negada y las clausulas que hacen parte de la base de conocimiento
def lectura( ):
  conocimiento = []
  print("Ingrese la negación de la sentencia que se quiere confirmar: ")
  sentencia = input()
  datos = "1"
  while(datos == "1" ):
      a = input("Ingrese una proposición:\n")
      lista = integrarDatos(a)
      conocimiento.append(lista)
      print("¿Quiere continuar agregando propociciones a la base de conocimiento? Escriba 1 si es así; 2 en caso contrario")
      datos = input()

  print('\n', '\n',"Sentencia: ", sentencia)

  data = integrarDatos(sentencia)
  conocimiento.append(data)

  return conocimiento

#Guardo lo datos y los pongo de manera que los pueda utilizar
def integrarDatos(a):
  lista = a.split(',')
  return lista


#Utilizo dos reglas de resolucion para aplicar con las clausulas:
#1. Si en una clausula aparece un literal y en otra aparece la negacion del mismo literal, se pueden unir ambas clausulas eliminando dicho literal
#2. Si en una clausula aparece un literal y su negacion, equivale a verdadero y se podra eliminar dicha clausula
def regla(primera,segunda):
    copiap = primera.copy()
    copias = segunda.copy()
    saber = False
#Si las ultimas dos clausulas tienen True ya me dice que el resultado es vacio y por lo tanto se confirma la teoria
    if 'T' in copiap:
        if 'T' in copias:
            return ['T']
#Evaluo la primera regla
    for k in primera:
        for j in segunda:
    
            if("!"+k == j or "!"+j == k):
                copiap.remove(k)
                copias.remove(j)
                saber = True
                break
        break
    if(saber == True):
        for k in copiap:
            for j in copias:
                
#Evaluo la segunda regla
                if("!"+k == j or "!"+j == k):
                    copiap.remove(k)
                    copias.remove(j)
                    copias.append("T")
                    if(len(copiap) == 1):
                        for p in copiap:
                            for l in copias:
                                if("!"+p == l or "!"+l == p):
                                  copiap.remove(p)
                                  copias.remove(l)
                                  copias.append("T")
                   
                
    if(saber == True):

     if(fin == False):
  #Devuelvo el resultado
      sentencia = copiap+copias
      return sentencia
#Si al final me queda solo dos clausulas y contienen true se confirma a teoria, si no, devuelvo false
     if(fin == True):
             if 'T' in copiap:
              if 'T' in copias:
               return ['T']
     else:
         return ['F']

#Si ninguna regla aplica entonces devuelvo solo la segunda clausula    
    return segunda.copy()



def InferenciaResolucion():
   conocimiento = lectura()
   print("Base del conocimiento")
   print(conocimiento)

   decision = 0
   #Mientras no se resuelvan todas las clausulas no se termina el proceso
   while(decision == 0):
       copia = conocimiento.copy()
       sentencia = copia[0]
       conocimiento.clear()
       contador = 0
       #Comparo la primera clausula con las otras, aplico las reglas y esto me genera un nueovo arreglo de clausulas.
       #Continuo trabajando con este arreglo y asi sucesivamente
       for i in copia:
           if(contador != 0):
              sent = regla(sentencia,i)
              conocimiento.append(sent)
           contador+=1
       print("Siguiente iteracion:  ")
       print(conocimiento)
       if(len(conocimiento) == 2):
           fin = True
       if(len(conocimiento) == 1):
           decision = 1


   if(conocimiento == [['T']]):
       print("Verdadero")
   else:
       print("Falso")

   

InferenciaResolucion()
function needle_top_down(profilePorcentajes, profileCadena, str2, m, n, W)
    if m == 0
        return 0
    end

    if n == 0
        return 0
    end

    if W[m, n] != typemin(Int64)
        return W[m, n]
    end

    #falta actualizar los porcentajes para llamar a las recursiones
    W[m, n] = max(
            needle_top_down(profilePorcentajes, profileCadena, str2, m-1, n, W) + sii(str2[n]=="_", 0, -1) ,
            needle_top_down(profilePorcentajes, profileCadena, str2, m, n-1, W) + scoregap(profilePorcentajes[n], profileCadena[n]), #ver cuanto vale gap
            needle_top_down(profilePorcentajes, profileCadena, str2, m-1, n-1, W) + score(profilePorcentajes[n], profileCadena[n], str2[m]) #match
    )
end

function sii(condicion, res1, res2)
    if condicion
        res1
    else
        res2
    end
end

function score(porcentajes, letras, caracterSegundaCadena) #no se si esta dando lo que tiene que dar
    score = 0
    #por ser recursiva siempre estamos trabajando con la ultima columna del profile y la ultima letra del string (n y m)
    for j in size(porcentajes)[1]
        score = score + porcentajes[j] * compararEnMatriz(letras[j],caracterSegundaCadena) # ej 0.3 * -4
    end
    return score
end

function scoregap(porcentajes, letras)
     score = 0
     for j in size(porcentajes)[1]
         score = score + porcentajes[j] * sii(letras[j]=="_", 0, -1)
    end
end

function actualizarProfile(profilePorcentajes, profileCadena, cadena) #devuelve un nuevo profile con los porcentajes actualizados
    nuevoProfilePorcentajes = []
    nuevaProfileCadena = []

    for (columnaIndex, columa) in enumerate(cadena)
        porcentajesColumna = profilePorcentajes[columnaIndex] # [0.25, 0.5, 0.25] profiles de la columna
        cadenaColumna = profileCadena[columnaIndex] #[g, t, _] cadena de la columna

        nuevoCaracterAAgregar = string(cadena[columnaIndex]) #letrita a agregar
        nuevosPorcentajesColumna = []

        for porcentaje in porcentajesColumna
            nuevosPorcentajesColumna = push!(nuevosPorcentajesColumna, porcentaje/2) #divido los porcentajes en 2
        end

        if(nuevoCaracterAAgregar in cadenaColumna)
            print("entre al if")
            stringCadena = join(cadenaColumna) #uno la columna del perfil ej "ACG"
            indiceCaracterExistente = findfirst(nuevoCaracterAAgregar, stringCadena) #encuentro el indice del caracter
            nuevosPorcentajesColumna[indiceCaracterExistente[1]] = nuevosPorcentajesColumna[indiceCaracterExistente[1]] + 0.5 #actualizo el porcentaje en ese indice
            nuevaCadenaColumna = cadenaColumna
        else
            nuevosPorcentajesColumna = push!(nuevosPorcentajesColumna, 0.5)
            print(cadenaColumna)
            print(nuevoCaracterAAgregar) #agrego porcentaje de letra nueva
            nuevaCadenaColumna = push!(cadenaColumna, nuevoCaracterAAgregar) #agrego la letra
        end

        #termine CON LA COLUMNA
        nuevoProfilePorcentajes = push!(nuevoProfilePorcentajes, nuevosPorcentajesColumna) #agrego los nuevos porcentajes actualizados al profile nuevo
        nuevaProfileCadena = push!(nuevaProfileCadena, nuevaCadenaColumna) #agrego la letra de la iteracion a la columna

    end

    return (nuevoProfilePorcentajes, nuevaProfileCadena)
end

actualizarProfile([[0.2, 0.3, 0.25, 0.25]], [["A", "C", "G", "T"]], "A")

function generarProfileInicial(string)
    profile = []
    for letter in string
        profile = push!(profile, (letter, 1))
    end

    return profile
end

function compararEnMatriz(letra1, letra2)
    letrasYPosiciones = Dict("A" => 1, "T" => 2, "G" => 3, "C" => 4)
    m = [5  -4  -4  -4; -4   5  -4  -4; -4  -4   5  -4; -4  -4  -4   5]
    return(m[letrasYPosiciones[letra1], letrasYPosiciones[letra2]])
end

str1 = "gatos"
str2 = "pato"
m = length(str1)
n = length(str2)
W = fill(typemin(Int64), m, n)
needle_top_down(str1, str2, m, n, W)
reconstruccion_top_down(str1, str2, W)

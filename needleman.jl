function needle_top_down(profile, str2, m, n, W, matrizDeCostoEIndices)
    #esto devuelve un score y AFECTA a la matriz. Pero NO DEVUELVE UNA MATRIZ
    #m es el index para la cadena del profile y n es el index para la cadena a comparar

    if m == 0
        return n * -1
    end

    if n == 0
        return m * -1
    end

    if W[m, n] != typemin(Float64)
        return W[m, n]
    end

    W[m, n] = max(
            needle_top_down(profile, str2, m-1, n, W, matrizDeCostoEIndices) -1, #gap contra gap es 0 y gap contra letra es -1
            needle_top_down(profile, str2, m, n-1, W, matrizDeCostoEIndices) -1,
            needle_top_down(profile, str2, m-1, n-1, W, matrizDeCostoEIndices) + scoreColumna(profile, m, str2[n], matrizDeCostoEIndices) #apareamiento de columna
            )

    return W[m, n]
end

function compararEnMatriz(letra1, letra2, matrizDeCostoEIndices)
    letrasYPosiciones = matrizDeCostoEIndices[1]
    m = matrizDeCostoEIndices[2]
    return (m[letrasYPosiciones[string(letra1)], letrasYPosiciones[string(letra2)]])
end

function sii(condicion, res1, res2)
    if condicion
        res1
    else
        res2
    end
end

function scoreColumna(profile, numeroColumna, caracterSegundaCadena, matrizDeCostoEIndices) 
    scoreDeColumna = 0
    #por ser recursiva siempre estamos trabajando con la ultima columna del profile y la ultima letra del string (n y m)
    profileColumna = profile.profileCadenas[numeroColumna]

    for (j, porcentaje) in enumerate(profile.profilePorcentajes[numeroColumna]) #recorrido vertical
        scoreDeColumna = scoreDeColumna + (porcentaje * compararEnMatriz(profileColumna[j], caracterSegundaCadena, matrizDeCostoEIndices)) # ej 0.3 * -4
    end

    return scoreDeColumna
end

function scoregap(profile, numeroColumna)
    scoreDeColumna = 0
    #por ser recursiva siempre estamos trabajando con la ultima columna del profile y la ultima letra del string (n y m)
    profileColumna = profile.profileCadenas[numeroColumna]

    for (j, porcentaje) in enumerate(profile.profilePorcentajes[numeroColumna]) #recorrido vertical
        scoreDeColumna = scoreDeColumna + (porcentaje * sii(profileColumna[j]=="-", 0, -1)) # clase con pato: actualiza los porcentajes del profile dependiendo de SI YA ERAN UN GAP O NO
    end
    return scoreDeColumna
end

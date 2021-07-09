function needle_top_down(profile, str2, m, n, W)
    #esto devuelve un score y AFECTA a la matriz. Pero NO DEVUELVE UNA MATRIZ

    if m == 1
        W[m,n] = scoreColumna(profile, m, str2[m])
        return W[m,n]
    end

    if n == 1
        W[m,n] = scoreColumna(profile, n, str2[n])
        return W[m,n]
    end

    if W[m, n] != typemin(Int64)
        return W[m, n]
    end

    #falta actualizar los porcentajes para llamar a las recursiones

    W[m, n] = max(
            needle_top_down(profile, str2, m-1, n, W) + sii(str2[n]=="-", 0, -1), #gap contra gap es 0 y gap contra letra es -1
            needle_top_down(profile, str2, m, n-1, W) + sii(str2[m]=="-", 0, -1),
            needle_top_down(profile, str2, m-1, n-1, W) + scoreColumna(profile, n, str2[m]) #apareamiento de columna
            )

    return W[m, n]
end

function compararEnMatriz(letra1, letra2)
    letrasYPosiciones = Dict("A" => 1, "T" => 2, "G" => 3, "C" => 4, "-" => 5)

    m = [
         5 -4 -4 -4 -1;
        -4 5 -4 -4 -1;
        -4 -4 5 -4 -1;
        -4 -4 -4 5 -1;
        -1 -1 -1 -1 0
        ]
    return(m[letrasYPosiciones[string(letra1)], letrasYPosiciones[string(letra2)]])
end

compararEnMatriz("-", "-")
function sii(condicion, res1, res2)
    if condicion
        res1
    else
        res2
    end
end

function scoreColumna(profile, numeroColumna, caracterSegundaCadena) #no se si esta dando lo que tiene que dar. pero reviso despues
    scoreDeColumna = 0
    #por ser recursiva siempre estamos trabajando con la ultima columna del profile y la ultima letra del string (n y m)
    profileColumna = profile.profileCadenas[numeroColumna]

    for (j, porcentaje) in enumerate(profile.profilePorcentajes[numeroColumna]) #recorrido vertical
        scoreDeColumna = scoreDeColumna + (porcentaje * compararEnMatriz(profileColumna[j], caracterSegundaCadena)) # ej 0.3 * -4
    end

    return scoreDeColumna
end

str1 = "ACGT"
str2 = "ACGA"
profile = inicializarProfile(str1)

scoreColumna(profile, 1, "A")

function scoregap(porcentajes, letras)
     score = 0
     for (j, porcentaje) in enumerate(porcentajes)
         score = score + porcentajes[j] * sii(letras[j]=="_", 0, -1) # clase con pato: actualiza los porcentajes del profile dependiendo de SI YA ERAN UN GAP O NO
    end
end

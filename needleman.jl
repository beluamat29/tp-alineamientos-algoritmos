function needle_top_down(profile, str2, m, n, W)
    #esto devuelve usna matriz

    if m == 1
        return 0
    end

    if n == 1
        return 0
    end

    if W[m, n] != typemin(Int64)
        return W[m, n]
    end

    #falta actualizar los porcentajes para llamar a las recursiones
    W[m, n] = max(
            needle_top_down(profile, str2, m-1, n, W) + sii(str2[n]=="_", 0, -1), #gap contra gap es 0 y gap contra letra es -1
            needle_top_down(profile, str2, m, n-1, W) + sii(str2[m]=="_", 0, -1),
            needle_top_down(profile, str2, m-1, n-1, W) + score(profile.profilePorcentajes[n], profile.profileCadenas[n], str2[m]) #apareamiento de columna
            )

    return W[m, n]
end

function compararEnMatriz(letra1, letra2)
    letrasYPosiciones = Dict("A" => 1, "T" => 2, "G" => 3, "C" => 4)
    m = [5  -4  -4  -4; -4   5  -4  -4; -4  -4   5  -4; -4  -4  -4   5]
    return(m[letrasYPosiciones[string(letra1)], letrasYPosiciones[string(letra2)]])
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
    for (j, porcentaje) in enumerate(porcentajes)
        score = score + porcentajes[j] * compararEnMatriz(letras[j],caracterSegundaCadena) # ej 0.3 * -4
    end
    return score
end

score([0.25, 0.5, 0.25],["A", "G", "C"], "G")

function scoregap(porcentajes, letras)
     score = 0
     for (j, porcentaje) in enumerate(porcentajes)
         score = score + porcentajes[j] * sii(letras[j]=="_", 0, -1) # clase con pato: actualiza los porcentajes del profile dependiendo de SI YA ERAN UN GAP O NO
    end
end

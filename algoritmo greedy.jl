include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")

using(Combinatorics)

function alineamientoGreedy(secuencias)
    mejorParInicial = encontrarMejorParInicial(secuencias) #buscamos los dos que mejor score tienen para empezar
    profileOriginal = actualizarProfile(mejorParInicial[3], mejorParInicial[4]) #armo el primer profile con el resultado del mejor par
    listaSecuencias = eliminarSecuenciaDeLista(mejorParInicial[1][1], secuencias) #elimino las secuencias del par inicial de la lista de secuencias restantes
    listaSecuencias = eliminarSecuenciaDeLista(mejorParInicial[1][2], secuencias)

    score = mejorParInicial[2]
    while(listaSecuencias != []) #mientras queden cadenas sin alinear
        mejorAlineamientoQueSigue = encontrarMejorSecuenciaQueSigue(listaSecuencias, profileOriginal) #busco la mejor cadena que sigue
        profileOriginal = reconstruccion_top_down(profileOriginal, mejorAlineamientoQueSigue[1], mejorAlineamientoQueSigue[3])[3] #actualizo el profile con la mejor cadena posible
        score += mejorAlineamientoQueSigue[2] #sumo el score del alineamiento
        listaSecuencias = eliminarSecuenciaDeLista(mejorAlineamientoQueSigue[1], listaSecuencias) #sacamos a la secuencia elegida de la lista de secuencias
    end

    return (score, profileOriginal) #falta alineamiento, hay que ir armandolo en cada pasada del while (funcion reconstruccion_top_down)
end

function encontrarMejorParInicial(secuencias)
    listaDePares = collect(combinations(secuencias, 2)) #genera todos los pares posibles
    scoreMejorPar = typemin(Float64) #arranco con el numero mas pequeño posible
    mejorPar = nothing #aun no tengo mi mejor par
    mejorProfile = nothing
    mejorString2 = nothing

    for par in listaDePares
        profilePar = inicializarProfile(par[1]) #inicializo un nuevo profile con el primer elemento de cada par
        string2 = par[2] #uso al segundo elemento de cada par como cadena
        lProfile = largoProfile(profilePar)
        W = fill(typemin(Float64), lProfile, length(string2))
        scorePar = needle_top_down(profilePar, string2, lProfile, length(string2), W) #averiguo el score de este par
        if(scorePar > scoreMejorPar) #si el score es mejor que el que ya tenia, actualizo
            mejorPar = par
            scoreMejorPar = scorePar
            mejorProfile = profilePar
            mejorString2 = string2
        end
    end

    return (mejorPar, scoreMejorPar, mejorProfile, mejorString2)
end

function eliminarSecuenciaDeLista(secuenciaAEliminar, listaSecuencias)
    return filter!(secuencia -> secuencia !== secuenciaAEliminar, listaSecuencias) #IMPORTANTE: Elimina por IDENTIDAD, no por igualdad
end

function encontrarMejorSecuenciaQueSigue(secuencias, profile)
    mejorSecuencia = secuencias[1] #elijo la primera para empezar a comparar
    lProfile = largoProfile(profile)
    W = fill(typemin(Float64), lProfile, length(mejorSecuencia))
    scoreMejorSecuencia = needle_top_down(profile, mejorSecuencia, lProfile, length(mejorSecuencia), W)
    matrizDeAlineamientoConMejorSecuencia = W

    for secuencia in secuencias[2:end] #busco la que mas me conviene
        W = fill(typemin(Float64), lProfile, length(secuencia))
        scoreAlineamientoConSecuencia = needle_top_down(profile, secuencia, lProfile, length(secuencia), W) #averiguo el score de este par

        if(scoreAlineamientoConSecuencia > scoreMejorSecuencia) #si el score es mejor que el que ya tenia, actualizo
            scoreMejorSecuencia = scoreAlineamientoConSecuencia
            mejorSecuencia = secuencia
            matrizDeAlineamientoConMejorSecuencia = W
        end
    end

    return (mejorSecuencia, scoreMejorSecuencia, matrizDeAlineamientoConMejorSecuencia)
end

alineamientoGreedy(["AACGT", "AAA", "GTT", "AAGTT", "AAGTA", "GGGTT", "A", "CCCGA"])

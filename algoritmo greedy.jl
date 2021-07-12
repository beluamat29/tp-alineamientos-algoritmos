include("profile.jl")
include("needleman.jl")
using(Combinatorics)

function alineamientoGreedy(secuencias)
    mejorParInicial = encontrarMejorParInicial(secuencias) #buscamos los dos que mejor score tienen para empezar
    profileOriginal = actualizarProfile(mejorParInicial[3], mejorParInicial[4]) #armo el primer profile con el resultado del mejor par
    listaSecuencias = eliminarDeListaDeSecuencias(mejorParInicial[1], secuencias) #elimino las secuencias del par inicial de la lista de secuencias restantes

    copiaProfile = profileOriginal
    score = mejorParInicial[2]
    while(listaSecuencias != []) #mientras queden cadenas sin alinear
        mejorSecuenciaQueSigue = encontrarMejorSecuenciaQueSigue(listaSecuencias, copiaProfile)
        copiaProfile = actualizarProfile(copiaProfile, mejorSecuenciaQueSigue[1]) #agrego la secuencia al profile
        score += mejorSecuenciaQueSigue[2] #sumo el score del alineamiento
        listaSecuencias = eliminarSecuenciaDeLista(mejorSecuenciaQueSigue[1], listaSecuencias) #sacamos a la secuencia elegida de la lista de secuencias
    end
    #FALTA EL VALOR A DEVOLVER, HABRIA QUE IR CONSTRUYENDO EL ALINEAMIENTO A MEDIDA QUE AVANZAMOS EN LA LISTA
end

alineamientoGreedy(["AACGT", "GTT-", "AAGTT", "AAGTA"])

function encontrarMejorParInicial(secuencias)
    listaDePares = collect(combinations(secuencias, 2)) #genera todos los pares posibles
    scoreMejorPar = typemin(Float64) #arranco con el numero mas pequeño posible
    mejorPar = nothing

    for par in listaDePares
        profilePar = inicializarProfile(par[1])
        string2 = par[2]
        lProfile = largoProfile(profile)
        W = fill(typemin(Float64), lProfile, length(string2))
        scorePar = needle_top_down(profilePar, string2, lProfile, length(string2), W) #averiguo el score de este par
        if(scorePar > scoreMejorPar) #si el score es mejor que el que ya tenia, actualizo
            mejorPar = par
            scoreMejorPar = scorePar
        end
    end

    return (mejorPar, scoreMejorPar, profilePar, string2)
end

function eliminarSecuenciaDeLista(secuenciaAEliminar, listaSecuencias)
    return filter!(secuencia -> secuencia !== secuenciaAEliminar, listaSecuencias)
end

function

function encontrarMejorSecuenciaQueSigue(secuencias, profile)
    mejorSecuencia = secuencias[1] #elijo la primera para empezar a comparar
    lProfile = largoProfile(profile)
    W = fill(typemin(Float64), lProfile, length(mejorSecuencia))
    scoreMejorSecuencia = needle_top_down(profile, mejorSecuencia, lProfile, length(mejorSecuencia), W)

    for secuencia in secuencias[2:end] #busco la que mas me conviene
        W = fill(typemin(Float64), lProfile, length(secuencia))
        scoreAlineamientoConSecuencia = needle_top_down(profile, secuencia, lProfile, length(secuencia), W) #averiguo el score de este par
        if(scoreAlineamientoConSecuencia > scoreMejorSecuencia) #si el score es mejor que el que ya tenia, actualizo
            scoreMejorSecuencia = scoreAlineamientoConSecuencia
            mejorSecuencia = secuencia
        end
    end

    return (mejorSecuencia, scoreMejorSecuencia)
end

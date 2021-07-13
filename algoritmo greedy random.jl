include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")
include("algoritmo greedy.jl")

using(Combinatorics)

function algoritmoGreedyRandom(secuencias, cantidadMejores) #elegimos al azar entre algunas de las mejores
    primerasNMejores = encontrarNMejoresPares(secuencias, cantidadMejores) #buscamos los dos que mejor score tienen para empezar
    return primerasNMejores
end

function encontrarNMejoresPares(secuencias, cantidadMejores)
    listaDePares = collect(combinations(secuencias, 2)) #formo todos los pares
    mejoresPares = [] #aun no tengo mi mejor par

    while(length(mejoresPares) !== cantidadMejores && secuencias !== []) #tengo que buscar al mejor par pero N veces
        mejorPar = nothing
        scoreMejorPar = typemin(Float64)

        for par in listaDePares
            profilePar = inicializarProfile(par[1]) #inicializo un nuevo profile con el primer elemento de cada par
            string2 = par[2] #uso al segundo elemento de cada par como cadena
            lProfile = largoProfile(profilePar)
            W = fill(typemin(Float64), lProfile, length(string2))
            scorePar = needle_top_down(profilePar, string2, lProfile, length(string2), W) #averiguo el score de este par
            if(scorePar >= scoreMejorPar) #si el score es mejor que el que ya tenia, actualizo
                mejorPar = par
                scoreMejorPar = scorePar
            end
        end

        mejoresPares = push!(mejoresPares, (mejorPar[1], mejorPar[2])) #agrego el par encontrado
        listaDePares = eliminarParDeListaDePares(mejorPar, listaDePares) #saco el par que ya sume al resultado
    end

    return mejoresPares #retorno los cantidadMejores pares
end

function eliminarParDeListaDePares(mejorPar, listaDePares)
    return filter!(par -> (par[1] !== mejorPar[1]) || (par[2] !== mejorPar[2]), listaDePares)
end

algoritmoGreedyRandom(["AACGT", "GTT", "AAGTT", "AAGTA", "GGGTT", "AA", "CCCGA"], 7)

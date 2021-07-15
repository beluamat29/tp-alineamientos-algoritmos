include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")
include("algoritmo greedy.jl")

using(Combinatorics)

function algoritmoGreedyRandom(secuencias) #elegimos al azar entre algunas de las mejores. largo(secuencias) debe ser >= 2
    #BUGIMPORTANTEEEE: No puede haber dos secuencias iguales :(
    primerasNMejores = encontrarNMejoresPares(secuencias, length(secuencias)/2) #me quedo con la mejor mitad
    primerParRandom = primerasNMejores[rand(1:end)] #elijo un par al azar dentro de los mejores

    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[1],secuencias)
    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[2],secuencias)

    profile = armarProfileInicial(primerParRandom)[2] #profile con el que arranca el algoritmo
    score = 0
    while(listaDeSecuencias != []) #mientras queden secuencias por alinear
        mejoresSecuencias = encontrarNMejoresSecuencias(listaDeSecuencias, profile, length(listaDeSecuencias)/2)
        lProfile = largoProfile(profile)
        string2 = mejoresSecuencias[rand(1:end)] #elijo una secuencia al azar dentro de las n/2 mejores
        W = fill(typemin(Float64), lProfile, length(string2))
        score += needle_top_down(profile, string2, lProfile, length(string2), W)
        profile = reconstruccion_top_down(profile, string2, W)[3] #alineo el profile vs la cadena seleccionada

        listaDeSecuencias = eliminarSecuenciaDeLista(string2, listaDeSecuencias)
    end

    return (score, profile)
end

function encontrarNMejoresPares(secuencias, cantidadMejores)
    listaDePares = collect(combinations(secuencias, 2)) #formo todos los pares
    mejoresPares = [] #aun no tengo mi mejor par

    while(length(mejoresPares) < cantidadMejores) #tengo que buscar al mejor par pero N veces
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

#encontrarNMejoresPares(["AACGT", "GTT", "AAGTT", "AAGTA", "GGGTT", "AA", "CCCGA", "GGTAC"], 4)

function eliminarParDeListaDePares(mejorPar, listaDePares)
    return filter!(par -> (par[1] !== mejorPar[1]) || (par[2] !== mejorPar[2]), listaDePares)
end

function armarProfileInicial(par)
    profile = inicializarProfile(par[1])
    lProfile = largoProfile(profile)
    string2 = par[2]
    W = fill(typemin(Float64), lProfile, length(string2))
    scorePar = needle_top_down(profile, string2, lProfile, length(string2), W)
    profileActualizado = reconstruccion_top_down(profile, string2, W)[3]
    return (scorePar, profileActualizado)
end

function encontrarNMejoresSecuencias(listaDeSecuencias, profile, cantidad)
    copiaSecuencias = copy(listaDeSecuencias) #porque si no me las saca de la lista original
    mejoresSecuencias = []
    contador = cantidad

    while(contador > 0)
        mejorSecuenciaQueSigue = encontrarMejorSecuenciaQueSigue(copiaSecuencias, profile)[1]
        mejoresSecuencias = push!(mejoresSecuencias, mejorSecuenciaQueSigue)
        listaDeSecuencias = eliminarSecuenciaDeLista(mejorSecuenciaQueSigue, copiaSecuencias)
        contador -= 1
    end

    return mejoresSecuencias
end
#profile = Profile(Any[Any[1.0], Any[1.0], Any[1.0], Any[1.0], Any[0.5, 0.5]], Any[["A"], ["A"], ["G"], ["T"], ["T", "A"]])

profile = algoritmoGreedyRandom(["AACGT", "GTT", "AAGTT", "AAGTA", "TTAG", "CCCTAGG", "CGTAC"])
imprimirProfile(profile)

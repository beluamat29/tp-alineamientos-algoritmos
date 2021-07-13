include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")
include("algoritmo greedy.jl")

using(Combinatorics)

function algoritmoGreedyRandom(secuencias) #elegimos al azar entre algunas de las mejores
    #BUGIMPORTANTEEEE: No puede haber dos secuencias iguales :(
    primerasNMejores = encontrarNMejoresPares(secuencias, lenght(secuencias)/2) #ESTO DEBERIA SER LEN(SECUENCIAS)/2
    primerParRandom = primerasNMejores[rand(1:end)] #elijo un par al azar dentro de los n/2 mejores

    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[1],secuencias)
    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[2],secuencias)

    profile = armarProfileInicial(primerParRandom)[3] #profile con el que arranca el algoritmo

    while(listaDeSecuencias !== []) #mientras queden secuencias por alinear
        mejoresSecuencias = encontrarNMejoresSecuencias(listaDeSecuencias, profile, lenght(listaDeSecuencias)/2)
        lProfile = largoProfile(profile)
        string2 = mejoresSecuencias[rand(1:end)] #elijo una secuencia al azar dentro de las n/2 mejores
        W = fill(typemin(Float64), lProfile, length(string2))
        scorePar = needle_top_down(profile, string2, lProfile, length(string2), W)
        profile = reconstruccion_top_down(profile, string2, W) #alineo el profile vs la cadena seleccionada

        listaDeSecuencias = eliminarSecuenciaDeLista(string2, listaDeSecuencias)
    end

    return profile
end

function encontrarNMejoresPares(secuencias, cantidadMejores)
    listaDePares = collect(combinations(secuencias, 2)) #formo todos los pares
    mejoresPares = [] #aun no tengo mi mejor par

    while(length(mejoresPares) !== cantidadMejores && listaDePares !== []) #tengo que buscar al mejor par pero N veces
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

function armarProfileInicial(par)
    profile = inicializarProfile(par[1])
    lProfile = largoProfile(profile)
    string2 = par[2]
    W = fill(typemin(Float64), lProfile, length(string2))
    scorePar = needle_top_down(profile, string2, lProfile, length(string2), W)
    return reconstruccion_top_down(profile, string2, W)
end

function encontrarNMejoresSecuencias(listaDeSecuencias, profile, cantidad)
    mejoresSecuencias = []
    contador = cantidad

    while(contador != 0)
        mejorSecuenciaQueSigue = encontrarMejorSecuenciaQueSigue(listaDeSecuencias, profile)[1]
        listaSecuencias = eliminarSecuenciaDeLista(mejorSecuenciaQueSigue, listaSecuencias)
        contador -= 1
    end

    return mejoresSecuencias
end
algoritmoGreedyRandom(["AACGT", "GTT", "AAGTT", "AAGTA", "GGGTT", "AA", "CCCGA"], 7)

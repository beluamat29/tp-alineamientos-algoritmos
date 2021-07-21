include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")
include("algoritmo_greedy.jl")
include("result.jl")
include("cadena.jl")
include("matrices_de_costo.jl")
include("parseo_de_cadenas.jl")

using(Combinatorics)

function algoritmoGreedyRandom(archivoSecuencias, matrizDeCostoEIndices, randomTake) #largo(secuencias) debe ser >= 2
    secuencias = parsearListaDeCadenas(archivoSecuencias)
    primerasNMejores = encontrarNMejoresPares(secuencias, length(secuencias)/randomTake, matrizDeCostoEIndices) #me quedo con la mejor mitad
    primerParRandom = primerasNMejores[rand(1:end)] #elijo un par al azar dentro de los mejores

    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[1],secuencias)
    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[2],secuencias)

    profileInicial = armarProfileInicial(primerParRandom, matrizDeCostoEIndices)
    profile = profileInicial[2] #profile con el que arranca el algoritmo
    score = 0
    while(listaDeSecuencias != []) #mientras quede mas de una secuencia por alinear
        mejoresSecuencias = encontrarNMejoresSecuencias(listaDeSecuencias, profile, length(listaDeSecuencias)/randomTake, matrizDeCostoEIndices)
        lProfile = largoProfile(profile)
        cadenaString2 = (mejoresSecuencias[rand(1:end)])
        string2 = cadenaString2.valorCadena #elijo una secuencia al azar dentro de las n/2 mejores
        W = fill(typemin(Float64), lProfile, length(string2))
        score = needle_top_down(profile, string2, lProfile, length(string2), W, matrizDeCostoEIndices)
        reconstruccion = reconstruccion_top_down(profile, string2, W) #alineo el profile vs la cadena seleccionada
        profile = reconstruccion[3]
        listaDeSecuencias = eliminarSecuenciaDeLista(cadenaString2, listaDeSecuencias)
    end

    return Result(profile, score)
end

function encontrarNMejoresPares(secuencias, cantidadMejores, matrizDeCostoEIndices)
    listaDePares = collect(combinations(secuencias, 2)) #formo todos los pares
    paresConResultados = []

    for par in listaDePares
        profilePar = inicializarProfile(par[1].valorCadena) #inicializo un nuevo profile con el primer elemento de cada par
        string2 = par[2].valorCadena #uso al segundo elemento de cada par como cadena
        lProfile = largoProfile(profilePar)
        W = fill(typemin(Float64), lProfile, length(string2))
        scorePar = needle_top_down(profilePar, string2, lProfile, length(string2), W, matrizDeCostoEIndices) #averiguo el score de este par
        paresConResultados = push!(paresConResultados, (par, scorePar))
    end

    paresConResultados = sort!(paresConResultados, by = parConResultado -> parConResultado[2])

    mejoresPares = []

    tomados = 1
    while(tomados < cantidadMejores)
        mejoresPares = push!(mejoresPares, paresConResultados[tomados][1]) #tomo los cantidadMejores pares
        tomados += 1
    end

    return mejoresPares #retorno los cantidadMejores pares
end

function eliminarParDeListaDePares(mejorPar, listaDePares)
    return filter!(par -> (par[1] !== mejorPar[1]) || (par[2] !== mejorPar[2]), listaDePares)
end

function armarProfileInicial(par, matrizDeCostoEIndices)
    profile = inicializarProfile(par[1].valorCadena)
    lProfile = largoProfile(profile)
    string2 = par[2].valorCadena
    W = fill(typemin(Float64), lProfile, length(string2))
    scorePar = needle_top_down(profile, string2, lProfile, length(string2), W, matrizDeCostoEIndices)
    profileActualizado = reconstruccion_top_down(profile, string2, W)[3]
    return (scorePar, profileActualizado)
end

function encontrarNMejoresSecuencias(listaDeSecuencias, profile, cantidad, matrizDeCostoEIndices)
    copiaSecuencias = copy(listaDeSecuencias) #porque si no me las saca de la lista original
    mejoresSecuencias = []
    contador = cantidad

    while(contador > 0)
        mejorSecuenciaQueSigue = encontrarMejorSecuenciaQueSigue(copiaSecuencias, profile, matrizDeCostoEIndices)[1]
        mejoresSecuencias = push!(mejoresSecuencias, mejorSecuenciaQueSigue)
        listaDeSecuencias = eliminarSecuenciaDeLista(mejorSecuenciaQueSigue, copiaSecuencias)
        contador -= 1
    end

    return mejoresSecuencias
end

p = algoritmoGreedyRandom("archivo_de_cadenas.txt", matrizDeAminoacidos(), 1.5)

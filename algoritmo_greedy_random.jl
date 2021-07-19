include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")
include("algoritmo_greedy.jl")
include("result.jl")
include("cadena.jl")
include("matrices_de_costo.jl")

using(Combinatorics)

function algoritmoGreedyRandom(secuencias, matrizDeCostoEIndices, randomTake) #largo(secuencias) debe ser >= 2
    primerasNMejores = encontrarNMejoresPares(secuencias, length(secuencias)/randomTake, matrizDeCostoEIndices) #me quedo con la mejor mitad
    primerParRandom = primerasNMejores[rand(1:end)] #elijo un par al azar dentro de los mejores

    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[1],secuencias)
    listaDeSecuencias = eliminarSecuenciaDeLista(primerParRandom[2],secuencias)

    profileInicial = armarProfileInicial(primerParRandom, matrizDeCostoEIndices)
    profile = profileInicial[2] #profile con el que arranca el algoritmo
    score = 0
    while(length(listaDeSecuencias) > 1) #mientras quede mas de una secuencia por alinear
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
    mejoresPares = [] #aun no tengo mi mejor par

    while(length(mejoresPares) < cantidadMejores) #tengo que buscar al mejor par pero N veces
        mejorPar = nothing
        scoreMejorPar = typemin(Float64)

        for par in listaDePares
            profilePar = inicializarProfile(par[1].valorCadena) #inicializo un nuevo profile con el primer elemento de cada par
            string2 = par[2].valorCadena #uso al segundo elemento de cada par como cadena
            lProfile = largoProfile(profilePar)
            W = fill(typemin(Float64), lProfile, length(string2))
            scorePar = needle_top_down(profilePar, string2, lProfile, length(string2), W, matrizDeCostoEIndices) #averiguo el score de este par
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

p = algoritmoGreedyRandom([
Cadena("LCQGTSNKLTQLGTFEDHFLSLRRMFNNCEVVLGNLEITYVQKNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYGTNKSGLRELPMRSLQEVL"),
Cadena("VCQGTSNRLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYMQRNYDLSFLKTIQEVAGYVLIALNTVEKIPLENLQIIRGNVLYENTHALSVLSNYGSNKTGLQELPLRNLHEIL"),
Cadena("IILVQICQGTSNRLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYMQKNYDLSFLKTIQEVAGYVLIALNTVEKIPLENLQIIRGNVLYENTHALSVLSNYGANKVGLRELPMRNLQEIL"),
Cadena("FCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNLLYENTYALAVLSNYGANKTGVKELPMRNLQEIL"),
Cadena("VCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL"),
Cadena("LEEKKVCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL"),
Cadena("MFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL"),
Cadena("LEEKKVCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL"),
Cadena("MFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL"),
Cadena("LEEKKVCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL"),
Cadena("FLPSLVCQGTSNKLTQLGTFEDHFVSLQRMFNNCEVVLGNLEITYVQKNYDLSFLKTIQEVAGYVLIALNAVEKIPLENLQVIRGNVLYENFYALSVLSNYDVNKTGVKELPMRNLLEIL"),
Cadena("LASGICQGTGNKLTQLGTLDDHFLSLQRMYNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNSVETIPLVNLQIIRGNVLYEGFALAVLSNYGMNKTGLKELPMRNLLEIL")
], matrizDeAminoacidos(), 1.5)
include("profile.jl")
include("needleman.jl")
include("reconstruccion.jl")
include("matrices de costo.jl")
include("cadena.jl")
include("result.jl")

using(Combinatorics)

function alineamientoGreedy(secuencias, matrizDeCostoEIndices)
    mejorParInicial = encontrarMejorParInicial(secuencias, matrizDeCostoEIndices)
    #buscamos los dos que mejor score tienen para empezar
    #Devuelve el mejor par y el score del mejor par
    profileOriginal = inicializarProfile(mejorParInicial[1][1].valorCadena)
    string2 = (mejorParInicial[1][2]).valorCadena
    W = fill(typemin(Float64), largoProfile(profileOriginal), length(string2))
    score = needle_top_down(profileOriginal, string2, largoProfile(profileOriginal), length(string2), W, matrizDeCostoEIndices)
    profileOriginal = reconstruccion_top_down(profileOriginal, string2, W)[3] #armo el primer profile con el resultado del mejor par

    ###TERMINA INICIALIZACION DE PROFILE INICIAL###

    listaSecuencias = eliminarSecuenciaDeLista(mejorParInicial[1][1], secuencias) #elimino las secuencias del par inicial de la lista de secuencias restantes
    listaSecuencias = eliminarSecuenciaDeLista(mejorParInicial[1][2], secuencias)

    while(listaSecuencias != []) #mientras queden cadenas sin alinear
        mejorAlineamientoQueSigue = encontrarMejorSecuenciaQueSigue(listaSecuencias, profileOriginal, matrizDeCostoEIndices) #busco la mejor cadena que sigue
        profileOriginal = reconstruccion_top_down(profileOriginal, mejorAlineamientoQueSigue[1].valorCadena, mejorAlineamientoQueSigue[3])[3] #actualizo el profile con la mejor cadena posible
        score += mejorAlineamientoQueSigue[2] #sumo el score del alineamiento
        listaSecuencias = eliminarSecuenciaDeLista(mejorAlineamientoQueSigue[1], listaSecuencias) #sacamos a la secuencia elegida de la lista de secuencias
    end

    return Result(profileOriginal, score) #falta alineamiento, hay que ir armandolo en cada pasada del while (funcion reconstruccion_top_down)
end

function encontrarMejorParInicial(secuencias, matrizDeCostoEIndices)
    listaDePares = collect(combinations(secuencias, 2)) #genera todos los pares posibles
    scoreMejorPar = typemin(Float64) #arranco con el numero mas pequeño posible
    mejorPar = nothing #aun no tengo mi mejor par
    mejorProfile = nothing
    mejorString2 = nothing

    for par in listaDePares
        profilePar = inicializarProfile(par[1].valorCadena) #inicializo un nuevo profile con el primer elemento de cada par
        string2 = (par[2]).valorCadena #uso al segundo elemento de cada par como cadena
        lProfile = largoProfile(profilePar)
        W = fill(typemin(Float64), lProfile, length(string2))
        scorePar = needle_top_down(profilePar, string2, lProfile, length(string2), W, matrizDeCostoEIndices) #averiguo el score de este par
        if(scorePar > scoreMejorPar) #si el score es mejor que el que ya tenia, actualizo
            mejorPar = par
            scoreMejorPar = scorePar
            mejorProfile = profilePar
            mejorString2 = string2
        end
    end

    return (mejorPar, scoreMejorPar)
end

function eliminarSecuenciaDeLista(secuenciaAEliminar, listaSecuencias)
    return filter!(secuencia -> secuencia !== secuenciaAEliminar, listaSecuencias)
end

function encontrarMejorSecuenciaQueSigue(secuencias, profile, matrizDeCostoEIndices)
    mejorSecuencia = secuencias[1] #elijo la primera para empezar a comparar
    str2 = mejorSecuencia.valorCadena
    lProfile = largoProfile(profile)
    W = fill(typemin(Float64), lProfile, length(str2))
    scoreMejorSecuencia = needle_top_down(profile, str2, lProfile, length(str2), W, matrizDeCostoEIndices)
    matrizDeAlineamientoConMejorSecuencia = W

    for secuencia in secuencias[2:end] #busco la que mas me conviene
        str2 = secuencia.valorCadena
        W = fill(typemin(Float64), lProfile, length(str2))
        scoreAlineamientoConSecuencia = needle_top_down(profile, str2, lProfile, length(str2), W, matrizDeCostoEIndices) #averiguo el score de este par

        if(scoreAlineamientoConSecuencia > scoreMejorSecuencia) #si el score es mejor que el que ya tenia, actualizo
            scoreMejorSecuencia = scoreAlineamientoConSecuencia
            mejorSecuencia = secuencia
            matrizDeAlineamientoConMejorSecuencia = W
        end
    end

    return (mejorSecuencia, scoreMejorSecuencia, matrizDeAlineamientoConMejorSecuencia)
end

p = alineamientoGreedy([
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
], matrizDeAminoacidos())

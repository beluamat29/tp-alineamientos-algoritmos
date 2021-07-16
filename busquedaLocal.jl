include("algoritmo greedy random.jl")

#buscaremos en tantas vecindades como cantidadMaximaDeIteracionesPorVecindario veces
#haremos tantos cambios de gaps como (cantidadDeFilas del profile)^2
function busquedaLocal(profile, cantidadMaximaDeIteracionesPorVecindario)
    mejorResultado = profile[1] #El que me dieron por parametro. de alguna manera guardar el score que me dio el profile (Struct Result tal vez?)

    while(cantidadMaximaDeIteracionesPorVecindario > 0)
        cantidadDeFilas = cantidadDeFilas(mejorResultado.profile)

        mejorResultadoDelVecindario = mejorResultado
        for i in cantidadDeFilas #Busqueda dentro del vecindario
            cadenasParaCalcularNuevoPorcentaje = swapearGaps(mejorResultadoDelVecindario.profile, i)
            profileYScoreConGapsSwapeados = calcularScoreConGapsSwapeados(cadenasParaCalcularNuevoPorcentaje) #devuelve Profile y nuevo score

            if(profileYScoreConGapsSwapeados.score > mejorProfileDelVecindario.score)
                mejorResultadoDelVecindario = profileYScoreConGapsSwapeados
            end
        end

        if(mejorResultadoDelVecindario.score > mejorResultado)
            mejorResultado = mejorResultadoDelVecindario
        end

        cantidadMaximaDeIteracionesPorVecindario -= 1
        #actualizar contador
    end
    return mejorResultado
end

function swapearGaps(cadenasAux, i)
    nuevasCadenas = []
    for cadena in cadenasAux
        print(cadena)
        largoCadena = length(cadena)
        indice = 0
        numeroDeGap = 0
        encontrado = false

        while(indice < largoCadena && !encontrado) #encontrar el indice del gap numero i
            indice += 1
            if (string(cadena[indice]) === "-")
                numeroDeGap += 1

            end

            if(numeroDeGap === i)
                encontrado = true
            end
        end

        if(encontrado)
            if(indice + 1 <= largoCadena && cadena[indice + 1] !== "-") #el gap tiene una letra a la derecha. En indice + 1 hay una letra
                cadenaNueva = cadena[1:indice - 1] * cadena[indice+ 1] * "-" * cadena[indice + 2: end]
            elseif (cadena[indice - 1] !== "-" && indice - 1 > 0) #el gap tiene una letra a la izquierda. En indice - 1 hay una letra
                cadenaNueva = cadena[1: indice - 2] * "-" * cadena[indice - 1] * cadena[indice + 1: end]
            end

            nuevasCadenas = push!(nuevasCadenas, cadenaNueva)
        else
            nuevasCadenas = push!(nuevasCadenas, cadena)
        end
    end

    return nuevasCadenas
end

cadenas = []

p = algoritmoGreedyRandom([
"LCQGTSNKLTQLGTFEDHFLSLRRMFNNCEVVLGNLEITYVQKNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYGTNKSGLRELPMRSLQEVL",
"VCQGTSNRLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYMQRNYDLSFLKTIQEVAGYVLIALNTVEKIPLENLQIIRGNVLYENTHALSVLSNYGSNKTGLQELPLRNLHEIL",
"IILVQICQGTSNRLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYMQKNYDLSFLKTIQEVAGYVLIALNTVEKIPLENLQIIRGNVLYENTHALSVLSNYGANKVGLRELPMRNLQEIL",
"FCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNLLYENTYALAVLSNYGANKTGVKELPMRNLQEIL",
"VCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL",
"LEEKKVCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL",
"MFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL",
"LEEKKVCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL",
"MFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL",
"LEEKKVCQGTSNKLTQLGTFEDHFLSLQRMFNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNTVERIPLENLQIIRGNMYYENSYALAVLSNYDANKTGLKELPMRNLQEIL",
"FLPSLVCQGTSNKLTQLGTFEDHFVSLQRMFNNCEVVLGNLEITYVQKNYDLSFLKTIQEVAGYVLIALNAVEKIPLENLQVIRGNVLYENFYALSVLSNYDVNKTGVKELPMRNLLEIL",
"LASGICQGTGNKLTQLGTLDDHFLSLQRMYNNCEVVLGNLEITYVQRNYDLSFLKTIQEVAGYVLIALNSVETIPLVNLQIIRGNVLYEGFALAVLSNYGMNKTGLKELPMRNLLEIL"
], matrizDeAminoacidos())

swapearGaps(p[2].profileListaDeCadenas, 1)

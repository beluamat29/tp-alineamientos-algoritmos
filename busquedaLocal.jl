include("algoritmo greedy random.jl")
include("result.jl")
include("needleman.jl")
include("algoritmo greedy.jl")
#buscaremos en tantas vecindades como cantidadMaximaDeIteracionesPorVecindario veces
#haremos tantos cambios de gaps como (cantidadDeFilas del profile)^2
function busquedaLocal(resultado, cantidadMaximaDeIteracionesPorVecindario)
    print("Bueno el random salio bien")
    mejorResultado = resultado #El que me dieron por parametro.
    matriz = matrizDeAminoacidos() #la inicializo aca asi evito instanciarla en cada iteracion

    while(cantidadMaximaDeIteracionesPorVecindario > 0)
        cantidadDeFilas = cantidadDeFilas(mejorResultado.profile)

        mejorResultadoDelVecindario = mejorResultado
        for i in cantidadDeFilas #Busqueda dentro del vecindario
            cadenasParaCalcularNuevoPorcentaje = swapearGaps(mejorResultadoDelVecindario.profile, i)
            profileYScoreConGapsSwapeados = calcularScoreConGapsSwapeados(cadenasParaCalcularNuevoPorcentaje, matriz) #devuelve Profile y nuevo score

            if(profileYScoreConGapsSwapeados.score > mejorProfileDelVecindario.score)
                #Si el resultado de la iteracion actual es mejor que el mejor del vecindario actualizo
                mejorResultadoDelVecindario = profileYScoreConGapsSwapeados
            end
        end

        if(mejorResultadoDelVecindario.score > mejorResultado.score)
            #si el mejor del vecindario que acabo de procesar es mejor que el mejor general, actualizo
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

function calcularScoreConGapsSwapeados(cadenasConGapsAlterados, matrizDeScores) #paso la matriz por parametro para no instanciarla en cada iteracion
    profile = inicializarProfile(cadenasConGapsAlterados[1]) #arranco el profile con la primera cadena
    restoDeLasCadenas = eliminarSecuenciaDeLista(cadenasConGapsAlterados[1], cadenasConGapsAlterados) #elimino la primera secuencia de la lista (la que use para construir el profile)

    nuevoScore = 0
    for cadena in restoDeLasCadenas

        for (charIndex, char) in cadena
            ##PODEMOS ASUMIR QUE LAS CADENAS TIENEN EL MISMO LARGO QUE EL PROFILE (VIENEN DE UN ALINEAMIENTO YA HECHO)
            nuevoScore += scoreColumna(profile, charIndex, char, matrizDeScores)
        end

        profile = actualizarProfile(profile, cadena)
    end

    return Result(profile, scoreProfile)
end

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

#swapearGaps(p[2].profileListaDeCadenas, 1)

include("profile.jl")
include("result.jl")
include("needleman.jl")
include("algoritmo_greedy.jl")
include("algoritmo_greedy_random.jl")
include("matrices_de_costo.jl")
#buscaremos en tantas vecindades como cantidadMaximaDeIteracionesPorVecindario veces
#haremos tantos cambios de gaps como (cantidadDeFilas del profile)^2
function busquedaLocal(resultado, cantidadMaximaDeIteracionesPorVecindario, matrizDeScores)
    mejorResultado = resultado #El que me dieron por parametro.

    j = cantidadMaximaDeIteracionesPorVecindario
    while(j > 0)

        mejorResultadoDelVecindario = mejorResultado
        cantidadDeFilasProfile = cantidadDeFilas(mejorResultadoDelVecindario.profile)

        for i in 1:cantidadDeFilasProfile*1.5 #Busqueda dentro del vecindario
            cadenasParaCalcularNuevoPorcentaje = swapearGaps(mejorResultadoDelVecindario.profile.profileListaDeCadenas, i) #devuelve cadenas con los gaps swapeados
            profileYScoreConGapsSwapeados = calcularScoreConGapsSwapeados(cadenasParaCalcularNuevoPorcentaje, matrizDeScores) #devuelve Profile y nuevo score

            if(profileYScoreConGapsSwapeados.score > mejorResultadoDelVecindario.score)
                #println("el resultado del swap fue mejor que el mejor del vecindario. Actualizo mejor del vecindario:")
                #println("Mejor score del mejor del vecindario:", mejorResultadoDelVecindario.score)
                #println("Score del swapeo:", profileYScoreConGapsSwapeados.score)
                #Si el resultado de la iteracion actual es mejor que el mejor del vecindario actualizo
                mejorResultadoDelVecindario = profileYScoreConGapsSwapeados
            end
        end

        if(mejorResultadoDelVecindario.score > mejorResultado.score)
            #si el mejor del vecindario que acabo de procesar es mejor que el mejor general, actualizo

            #println("el resultado de la vecindad fue mejor que el acumulado, me muevo de vecindad:")
            #println("Mejor score general acumulado: ", mejorResultado.score)
            #println("Mejor score vecindad: ", mejorResultadoDelVecindario.score)

            mejorResultado = mejorResultadoDelVecindario
        end

        j -= 1
        #actualizar contador
    end
    return mejorResultado
end

function swapearGaps(cadenas, i)
    nuevasCadenas = []
    for cadena in cadenas

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

            nuevasCadenas = push!(nuevasCadenas, Cadena(cadenaNueva))
        else
            nuevasCadenas = push!(nuevasCadenas, Cadena(cadena))
        end
    end

    return nuevasCadenas
end

function calcularScoreConGapsSwapeados(secuenciasConGapsAlterados, matrizDeScores) #paso la matriz por parametro para no instanciarla en cada iteracion
    profile = inicializarProfile(secuenciasConGapsAlterados[1].valorCadena) #arranco el profile con la primera cadena
    restoDeLasCadenas = eliminarSecuenciaDeLista(secuenciasConGapsAlterados[1], secuenciasConGapsAlterados) #elimino la primera secuencia de la lista (la que use para construir el profile)

    for secuencia in secuenciasConGapsAlterados[1: end - 1]
         cadena = secuencia.valorCadena
         profile = actualizarProfile(profile, cadena)
    end

    nuevoScore = 0

    for (charIndex, char) in enumerate(secuenciasConGapsAlterados[end].valorCadena)
        ##PODEMOS ASUMIR QUE LAS CADENAS TIENEN EL MISMO LARGO QUE EL PROFILE (VIENEN DE UN ALINEAMIENTO YA HECHO)
        nuevoScore += scoreColumna(profile, charIndex, char, matrizDeScores)
    end


    return Result(profile, nuevoScore)
end

matrizDeScores = matrizDeAminoacidos()

resultado = algoritmoGreedyRandom([
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
], matrizDeScores, 1.5)

talVezMejorResultado2 = busquedaLocal(resultado, 20, matrizDeScores)

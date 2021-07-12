function reconstruccion_top_down(profile, str2,  W)
    alineado_1 = profile
    alineado_2 = str2
    m = largoProfile(profile)
    n = length(str2)

    while m > 1 || n > 1
        if m == 1
            n -= 1
            alineado_1 = agregarColumnaDeGaps(alineado_1, 1) #agrego gap adelante de todo en el profile
        elseif  n == 1
            m -= 1
            alineado_2 = "-" * alineado_2  #agrego gap adelante de todo en la cadena
        else
            gap_en_str2_mayor_gap_en_str1 = W[m-1, n] > W[m, n-1]

            if(gap_en_str2_mayor_gap_en_str1)

                gap_en_str2_mayor_mismatch = W[m-1, n] > W[m-1, n-1]

                if(gap_en_str2_mayor_mismatch)

                    if n == length(alineado_2)
                        alineado_2 *= "-"
                    else
                        alineado_2 = alineado_2[1:n] * "-" * alineado_2[n+1:end]
                    end

                    m -= 1
                else

                    m -= 1
                    n -= 1
                end
            else
                gap_en_str1_mayor_mismatch = W[m, n-1] > W[m-1, n-1]

                if(gap_en_str1_mayor_mismatch)

                    if m == largoProfile(alineado_1)
                        alineado_1 = agregarColumnaDeGaps(alineado_1, largoProfile(alineado_1) + 1) #agrego columna de gaps al final del profile
                    else
                        alineado_1 = agregarColumnaDeGaps(alineado_1, m)  #agrego columna de gaps en el m del profile
                    end

                    n -= 1
                else

                    m -= 1
                    n -= 1
                end
            end
        end

    end

    return (alineado_1, alineado_2)

end

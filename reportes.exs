# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez

# Reportes

defmodule Reportes do
  @meta_diaria 2000
  @dias 6
  @motivos [
    :productor_desconocido,
    :tanque_desconocido,
    :dia_invalido,
    :litros_fuera_de_rango,
    :porcentaje_invalido
  ]

  # R1: entregas rechazadas

  # rechazadas es una lista de {entrega, motivo}.
  # Devuelve [{motivo, cantidad}] con los 5 motivos, aunque alguno tenga 0
  def contar_rechazos(rechazadas) do
    frecuencias =
      rechazadas
      |> Enum.map(fn {_entrega, motivo} -> motivo end)
      |> Enum.frequencies()

    for motivo <- @motivos, do: {motivo, Map.get(frecuencias, motivo, 0)}
  end
  def imprimir_r1(rechazadas, conteos) do
    Util.mostrar("\n R1 Entregas rechazadas :  ")

    # mirar porque dia, litros y grasa pueden venir como texto
    Enum.each(rechazadas, fn {e, motivo} ->
      Util.mostrar(
        "#{e.productor} | #{e.tanque} | dia #{inspect(e.dia)} | " <>
          "litros #{inspect(e.litros)} | grasa #{inspect(e.grasa)} -> #{motivo}"
      )
    end)

    Util.mostrar("\nRechazos por motivo:")
    Enum.each(conteos, fn {motivo, cantidad} -> Util.mostrar("  #{motivo}: #{cantidad}") end)
    :ok
  end
  # R2: ocupación de tanques

  # Devuelve una lista de mapas ordenada por porcentaje, de mayor a menor
  def ocupacion_tanques(validas, tanques) do
    por_tanque = Enum.group_by(validas, fn e -> e.tanque end)

    ocupacion =
      for t <- tanques do
        litros =
          por_tanque
          |> Map.get(t.id, [])
          |> Enum.map(fn e -> e.litros end)
          |> Enum.sum()

        %{
          id: t.id,
          nombre: t.nombre,
          litros: litros,
          capacidad: t.capacidad,
          porcentaje: litros / t.capacidad * 100
        }
      end

    Enum.sort_by(ocupacion, fn t -> t.porcentaje end, :desc)
  end
  def imprimir_r2(ocupacion) do
    Util.mostrar("\n R2. Ocupación de tanques : ")

    Enum.each(ocupacion, fn t ->
      Util.mostrar(
        String.pad_trailing(t.id, 5) <>
          String.pad_trailing(t.nombre, 18) <>
          String.pad_leading(formatear_litros(t.litros), 9) <>
          " L de " <>
          String.pad_leading(Integer.to_string(t.capacidad), 5) <>
          " L  " <>
          formatear_porcentaje(t.porcentaje)
      )
    end)

    :ok
  end
   # R3: litros por día y meta

  # Devuelve un mapa %{1 => litros, ..., 6 => litros}. Los días sin entregas quedan en 0
  def litros_por_dia(validas) do
    por_dia = Enum.group_by(validas, fn e -> e.dia end)

    for dia <- 1..@dias, into: %{} do
      litros =
        por_dia
        |> Map.get(dia, [])
        |> Enum.map(fn e -> e.litros end)
        |> Enum.sum()

      {dia, litros}
    end
  end
  #Map.Merge/3
  def combinar_litros_diarios(litros_centro, litros_vecino) do
    Map.merge(litros_centro, litros_vecino, fn _dia, litros_locales, litros_vecino ->
      litros_locales + litros_vecino
    end)
  end

  def imprimir_r3(litros_dia) do
    Util.mostrar("\n R3. Litros recibidos por día (meta: #{@meta_diaria} L) ")

    Enum.each(1..@dias, fn dia ->
      litros = Map.get(litros_dia, dia, 0)
      estado = if litros >= @meta_diaria, do: "meta alcanzada", else: "meta NO alcanzada"
      Util.mostrar("Dia #{dia}: #{String.pad_leading(formatear_litros(litros), 9)} L  -> #{estado}")
    end)

    valores = Map.values(litros_dia)
    todos = Enum.all?(valores, fn l -> l >= @meta_diaria end)
    alguno = Enum.any?(valores, fn l -> l >= @meta_diaria end)

    Util.mostrar("\nMeta cumplida todos los días: #{si_no(todos)}")
    Util.mostrar("Meta cumplida al menos un día: #{si_no(alguno)}")
    :ok
  end
   # R4: liquidación de productores

  # liquidacion es una lista de mapas:
  # %{codigo, nombre, litros, valor_entregas, bonificaciones, transporte, neto}
  def ordenar_liquidacion(liquidacion) do
    Enum.sort_by(liquidacion, fn p -> p.neto end, :desc)
  end

  def imprimir_r4(liquidacion_ordenada) do
    Util.mostrar("\nR4. Liquidación de productores : ")

    Util.mostrar(
      String.pad_trailing("#", 4) <>
        String.pad_trailing("Cod", 6) <>
        String.pad_trailing("Nombre", 18) <>
        String.pad_leading("Litros", 9) <>
        String.pad_leading("Entregas", 13) <>
        String.pad_leading("Bonif.", 11) <>
        String.pad_leading("Transp.", 11) <>
        String.pad_leading("Neto", 13)
    )

    liquidacion_ordenada
    |> Enum.with_index(1)
    |> Enum.each(fn {p, posicion} ->
      Util.mostrar(
        String.pad_trailing("#{posicion}", 4) <>
          String.pad_trailing(p.codigo, 6) <>
          String.pad_trailing(p.nombre, 18) <>
          String.pad_leading(formatear_litros(p.litros), 9) <>
          String.pad_leading(formatear_pesos(p.valor_entregas), 13) <>
          String.pad_leading(formatear_pesos(p.bonificaciones), 11) <>
          String.pad_leading(formatear_pesos(p.transporte), 11) <>
          String.pad_leading(formatear_pesos(p.neto), 13)
      )
    end)

    :ok
  end

  #R5

    @doc """
  Encuentra los productores con más litros entregados en cada día.
  Recibe únicamente entregas válidas.
  """
  def lideres_por_dia(entregas_validas) do
    litros_por_productor =
      entregas_validas
      |> Enum.group_by(fn entrega -> {entrega.dia, entrega.productor} end)
      |> Enum.map(fn {{dia, codigo}, entregas} ->
        litros =
          entregas
          |> Enum.map(fn entrega -> entrega.litros end)
          |> Enum.sum()

        %{dia: dia, codigo: codigo, litros: litros}
      end)

    for dia <- 1..@dias do
      productores_del_dia =
        Enum.filter(litros_por_productor, fn productor ->
          productor.dia == dia
        end)

      case productores_del_dia do
        [] ->
          %{dia: dia, ganadores: []}

        _ ->
          maximo_litros =
            productores_del_dia
            |> Enum.map(fn productor -> productor.litros end)
            |> Enum.max()

          ganadores =
            productores_del_dia
            |> Enum.filter(fn productor -> productor.litros == maximo_litros end)
            |> Enum.sort_by(fn productor -> productor.codigo end)

          %{dia: dia, ganadores: ganadores}
      end
    end
  end

  @doc """
  Imprime los líderes diarios y quiénes ocuparon el primer lugar más días.
  """
  def imprimir_r5(lideres_por_dia, productores) do
    nombres =
      Map.new(productores, fn productor ->
        {productor.codigo, productor.nombre}
      end)

    Util.mostrar("\nR5. Productores con más litros por día")

    Enum.each(lideres_por_dia, fn resultado_dia ->
      Util.mostrar("Día #{resultado_dia.dia}:")

      case resultado_dia.ganadores do
        [] ->
          Util.mostrar("  Sin entregas válidas")

        ganadores ->
          Enum.each(ganadores, fn ganador ->
            nombre = Map.get(nombres, ganador.codigo, ganador.codigo)

            Util.mostrar(
              "  #{nombre} (#{ganador.codigo}): " <>
                "#{formatear_litros(ganador.litros)} L"
            )
          end)
      end
    end)

    frecuencias =
      lideres_por_dia
      |> Enum.flat_map(fn resultado_dia ->
        Enum.map(resultado_dia.ganadores, fn ganador -> ganador.codigo end)
      end)
      |> Enum.frequencies()

    Util.mostrar("\nPrimer lugar durante más días:")

    if map_size(frecuencias) == 0 do
      Util.mostrar("  No hubo entregas válidas")
    else
      maximos_dias =
        frecuencias
        |> Map.values()
        |> Enum.max()

      frecuencias
      |> Enum.filter(fn {_codigo, dias} -> dias == maximos_dias end)
      |> Enum.sort_by(fn {codigo, _dias} -> codigo end)
      |> Enum.each(fn {codigo, dias} ->
        nombre = Map.get(nombres, codigo, codigo)
        Util.mostrar("  #{nombre} (#{codigo}): #{dias} día(s)")
      end)
    end

    :ok
  end

  #R6

    @doc """
  Encuentra al productor con mejor porcentaje de grasa ponderado por litros,
  considerando solo quienes tienen al menos 3 entregas válidas.
  """
  def mejor_calidad(entregas_validas, productores) do
    candidatos =
      Enum.flat_map(productores, fn productor ->
        entregas_productor =
          Enum.filter(entregas_validas, fn entrega ->
            entrega.productor == productor.codigo
          end)

        if length(entregas_productor) >= 3 do
          litros_totales =
            entregas_productor
            |> Enum.map(fn entrega -> entrega.litros end)
            |> Enum.sum()

          suma_grasa_ponderada =
            entregas_productor
            |> Enum.map(fn entrega -> entrega.grasa * entrega.litros end)
            |> Enum.sum()

          [
            %{
              codigo: productor.codigo,
              nombre: productor.nombre,
              cantidad_entregas: length(entregas_productor),
              porcentaje_ponderado: suma_grasa_ponderada / litros_totales
            }
          ]
        else
          []
        end
      end)

    case candidatos do
      [] ->
        []

      _ ->
        maximo =
          candidatos
          |> Enum.map(fn candidato -> candidato.porcentaje_ponderado end)
          |> Enum.max()

        candidatos
        |> Enum.filter(fn candidato ->
          candidato.porcentaje_ponderado == maximo
        end)
        |> Enum.sort_by(fn candidato -> candidato.codigo end)
    end
  end

  @doc """
  Imprime el resultado del reporte R6.
  """
  def imprimir_r6(mejores) do
    Util.mostrar("\nR6. Productor con mejor calidad de leche")

    case mejores do
      [] ->
        Util.mostrar("No hay productores con al menos 3 entregas válidas.")

      _ ->
        Enum.each(mejores, fn productor ->
          Util.mostrar(
            "#{productor.nombre} (#{productor.codigo}) | " <>
              "Entregas válidas: #{productor.cantidad_entregas} | " <>
              "Grasa ponderada: #{formatear_porcentaje(productor.porcentaje_ponderado)}"
          )
        end)
    end

    :ok
  end

  #R7

    @doc """
  Calcula el total pagado y el costo promedio por litro de la semana.
  """
  def resumen_r7(liquidacion) do
    total_pagado =
      liquidacion
      |> Enum.map(fn productor -> productor.neto end)
      |> Enum.sum()

    total_litros =
      liquidacion
      |> Enum.map(fn productor -> productor.litros end)
      |> Enum.sum()

    costo_promedio =
      if total_litros > 0 do
        total_pagado / total_litros
      else
        nil
      end

    %{
      total_pagado: total_pagado,
      total_litros: total_litros,
      costo_promedio: costo_promedio
    }
  end

  @doc """
  Imprime el total pagado y el costo promedio por litro.
  """
  def imprimir_r7(resumen) do
    Util.mostrar("\nR7. Total pagado y costo promedio por litro")
    Util.mostrar("Total pagado: #{formatear_pesos(resumen.total_pagado)}")
    Util.mostrar("Litros válidos recibidos: #{formatear_litros(resumen.total_litros)} L")

    case resumen.costo_promedio do
      nil ->
        Util.mostrar("Costo promedio: no calculable porque no hubo litros recibidos")

      costo ->
        Util.mostrar("Costo promedio pagado por litro: $#{Float.round(costo, 2)}")
    end

    :ok
  end

  #R8
    @doc """
  Devuelve los productores con al menos una entrega válida en cada tanque.
  """
  def productores_en_todos_los_tanques(entregas_validas, productores, tanques) do
    Enum.filter(productores, fn productor ->
      Enum.all?(tanques, fn tanque ->
        Enum.any?(entregas_validas, fn entrega ->
          entrega.productor == productor.codigo and entrega.tanque == tanque.id
        end)
      end)
    end)
  end

  @doc """
  Imprime los productores que realizaron entregas válidas en todos los tanques.
  """
  def imprimir_r8(productores) do
    Util.mostrar("\nR8. Productores con entregas válidas en todos los tanques")

    case productores do
      [] ->
        Util.mostrar("Ningún productor entregó leche en todos los tanques.")

      _ ->
        Enum.each(productores, fn productor ->
          Util.mostrar("#{productor.nombre} (#{productor.codigo})")
        end)
    end

    :ok
  end

  defp formatear_litros(litros), do: Float.to_string(Float.round(litros / 1, 1))

  defp formatear_porcentaje(porcentaje), do: "#{Float.round(porcentaje / 1, 1)}%"

  defp si_no(true), do: "Sí"
  defp si_no(false), do: "No"

  # 1234567 -> "$1.234.567"
  defp formatear_pesos(valor) do
    entero = round(valor)
    signo = if entero < 0, do: "-", else: ""

    texto =
      entero
      |> abs()
      |> Integer.to_string()
      |> String.graphemes()
      |> Enum.reverse()
      |> Enum.chunk_every(3)
      |> Enum.map(fn grupo -> grupo |> Enum.reverse() |> Enum.join() end)
      |> Enum.reverse()
      |> Enum.join(".")

    signo <> "$" <> texto
  end
end

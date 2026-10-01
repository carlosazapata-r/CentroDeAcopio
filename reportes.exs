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
    IO.puts("\n R1 Entregas rechazadas :  ")

    # mirar porque dia, litros y grasa pueden venir como texto
    Enum.each(rechazadas, fn {e, motivo} ->
      IO.puts(
        "#{e.productor} | #{e.tanque} | dia #{inspect(e.dia)} | " <>
          "litros #{inspect(e.litros)} | grasa #{inspect(e.grasa)} -> #{motivo}"
      )
    end)

    IO.puts("\nRechazos por motivo:")
    Enum.each(conteos, fn {motivo, cantidad} -> IO.puts("  #{motivo}: #{cantidad}") end)
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
    IO.puts("\n R2. Ocupación de tanques : ")

    Enum.each(ocupacion, fn t ->
      IO.puts(
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
end

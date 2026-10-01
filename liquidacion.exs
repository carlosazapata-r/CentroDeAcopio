# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez

defmodule Liquidacion do
  @moduledoc "Funciones para calcular la liquidación de las entregas."

  @tarifa_base 1800
  @litros_bonificacion 450
  @bonificacion_diaria 25000
  @costo_transporte_diario 18000

  @doc """
  Calcula el valor de una entrega válida según su porcentaje de grasa.
  """
  def valor_entrega(entrega) do
    valor_base = entrega.litros * @tarifa_base

    cond do
      entrega.grasa >= 3.5 ->
        valor_base * 1.06

      entrega.grasa >= 3.0 ->
        valor_base

      entrega.grasa >= 2.5 ->
        valor_base * 0.92

      true ->
        valor_base * 0.80
    end
  end

  @doc """
  Calcula la liquidación de cada productor usando solo entregas válidas.
  """
  def calcular(productores, entregas_validas) do
    Enum.map(productores, fn productor ->
      calcular_productor(productor, entregas_validas)
    end)
  end

  defp calcular_productor(productor, entregas_validas) do
    entregas_productor =
      Enum.filter(entregas_validas, fn entrega ->
        entrega.productor == productor.codigo
      end)

    litros =
      entregas_productor
      |> Enum.map(fn entrega -> entrega.litros end)
      |> Enum.sum()

    valor_entregas =
      entregas_productor
      |> Enum.map(fn entrega -> valor_entrega(entrega) end)
      |> Enum.sum()

    bonificaciones = calcular_bonificaciones(entregas_productor)
    transporte = calcular_transporte(productor, entregas_productor)
    neto = valor_entregas + bonificaciones - transporte

    %{
      codigo: productor.codigo,
      nombre: productor.nombre,
      litros: litros,
      valor_entregas: valor_entregas,
      bonificaciones: bonificaciones,
      transporte: transporte,
      neto: neto
    }
  end

  defp calcular_bonificaciones(entregas_productor) do
    dias_bonificados =
      entregas_productor
      |> Enum.group_by(fn entrega -> entrega.dia end)
      |> Enum.count(fn {_dia, entregas_dia} ->
        litros_dia =
          entregas_dia
          |> Enum.map(fn entrega -> entrega.litros end)
          |> Enum.sum()

        litros_dia >= @litros_bonificacion
      end)

    dias_bonificados * @bonificacion_diaria
  end

  defp calcular_transporte(productor, entregas_productor) do
    if productor.transporte do
      dias_con_entrega =
        entregas_productor
        |> Enum.map(fn entrega -> entrega.dia end)
        |> Enum.uniq()
        |> length()

      dias_con_entrega * @costo_transporte_diario
    else
      0
    end
  end
end

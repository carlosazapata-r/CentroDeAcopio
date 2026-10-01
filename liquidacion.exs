# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez 


defmodule Liquidacion do
  @moduledoc "Funciones para calcular la liquidación de las entregas."

  @tarifa_base 1800

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
end

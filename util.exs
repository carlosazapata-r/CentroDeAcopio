# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez

defmodule Util do
  @moduledoc "Funciones auxiliares para entrada y salida por consola."

  def mostrar(texto), do: IO.puts(texto)

  def linea, do: IO.puts("")

  def leer(mensaje) do
    mensaje
    |> IO.gets()
    |> convertir_entrada()
  end

  defp convertir_entrada(nil), do: ""
  defp convertir_entrada(texto), do: String.trim(texto)
end

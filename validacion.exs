# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez

# Validación de entregas

defmodule Validacion do
  @moduledoc """
  Valida las entregas de leche y convierte texto en entregas.

  Reglas: el productor y el tanque deben existir, el día debe ser un entero
  de 1 a 6, los litros deben ser un número mayor que 0 y hasta 800, y la
  grasa un número entre 0 y 15.
  """

  @dia_minimo 1
  @dia_maximo 6
  @litros_maximo 800
  @grasa_minima 0
  @grasa_maxima 15

  @doc """
  Valida una entrega y devuelve `{:ok, entrega}` o `{:error, motivo}`.

  Las reglas se revisan en orden y se devuelve el primer motivo que falle:
  `:productor_desconocido`, `:tanque_desconocido`, `:dia_invalido`,
  `:litros_fuera_de_rango` o `:porcentaje_invalido`.

  """
  # Valida una entrega en el orden
  # Devuelve {:ok, entrega} o {:error, motivo} con el primer motivo que falle
  def validar_entrega(entrega, productores, tanques) do
    with :ok <- validar_productor(entrega.productor, productores),
         :ok <- validar_tanque(entrega.tanque, tanques),
         :ok <- validar_dia(entrega.dia),
         :ok <- validar_litros(entrega.litros),
         :ok <- validar_grasa(entrega.grasa) do
      {:ok, entrega}
    end
  end

  @doc """
  Valida una lista de entregas y devuelve `{validas, rechazadas}`.

  `validas` es la lista de entregas correctas y `rechazadas` es una lista de
  tuplas `{entrega, motivo}`.


  """
  # Valida toda la lista y la separa en {validas, rechazadas}
  def validar_todas(entregas, productores, tanques) do
    resultados = for e <- entregas, do: {e, validar_entrega(e, productores, tanques)}

    validas = for {e, {:ok, _}} <- resultados, do: e
    rechazadas = for {e, {:error, motivo}} <- resultados, do: {e, motivo}

    {validas, rechazadas}
  end

  @doc """
  Convierte un texto `"productor;tanque;dia;litros;grasa"` en una entrega.

  Devuelve `{:ok, entrega}` o `{:error, :formato_invalido}` si faltan campos
  o el día, los litros o la grasa no son números.


  """
  # Convierte el texto en una entrega o {:error, :formato_invalido}
  def parsear_entrega(texto) do
    campos =
      texto
      |> String.trim()
      |> String.split(";")
      |> Enum.map(&String.trim/1)

    with [productor, tanque, dia_texto, litros_texto, grasa_texto] <- campos,
         {dia, ""} <- Integer.parse(dia_texto),
         {:ok, litros} <- convertir_numero(litros_texto),
         {:ok, grasa} <- convertir_numero(grasa_texto) do
      {:ok, %{productor: productor, tanque: tanque, dia: dia, litros: litros, grasa: grasa}}
    else
      _ -> {:error, :formato_invalido}
    end
  end

  # Comprueba que el productor exista; si no, devuelve :productor_desconocido
  defp validar_productor(codigo, productores) do
    productores
    |> existe_productor?(codigo)
    |> generar_resultado(:productor_desconocido)
  end

  # Comprueba que el tanque exista; si no, devuelve :tanque_desconocido
  defp validar_tanque(id, tanques) do
    tanques
    |> existe_tanque?(id)
    |> generar_resultado(:tanque_desconocido)
  end

  # Comprueba que el día sea válido; si no, devuelve :dia_invalido
  defp validar_dia(dia) do
    dia
    |> dia_valido?()
    |> generar_resultado(:dia_invalido)
  end

  # Comprueba que los litros estén en rango; si no, devuelve :litros_fuera_de_rango
  defp validar_litros(litros) do
    litros
    |> litros_validos?()
    |> generar_resultado(:litros_fuera_de_rango)
  end

  # Comprueba que la grasa esté en rango; si no, devuelve :porcentaje_invalido
  defp validar_grasa(grasa) do
    grasa
    |> grasa_valida?()
    |> generar_resultado(:porcentaje_invalido)
  end


  # Devuelve true si algún productor de la lista tiene ese código
  defp existe_productor?(productores, codigo),
    do: Enum.any?(productores, fn p -> p.codigo == codigo end)

  # Devuelve true si algún tanque de la lista tiene ese id
  defp existe_tanque?(tanques, id),
    do: Enum.any?(tanques, fn t -> t.id == id end)

  # Devuelve true si el día es un entero entre el día mínimo y el máximo
  # is_integer descarta días como 2.5
  defp dia_valido?(dia)
       when is_integer(dia) and dia >= @dia_minimo and dia <= @dia_maximo,
       do: true

  defp dia_valido?(_), do: false

  # Devuelve true si los litros son un número mayor que 0 y hasta el máximo
  # is_number descarta textos como "abc"
  defp litros_validos?(litros)
       when is_number(litros) and litros > 0 and litros <= @litros_maximo,
       do: true

  defp litros_validos?(_), do: false

  # Devuelve true si la grasa es un número entre el mínimo y el máximo
  defp grasa_valida?(grasa)
       when is_number(grasa) and grasa >= @grasa_minima and grasa <= @grasa_maxima,
       do: true

  defp grasa_valida?(_), do: false


  # Convierte un booleano en :ok o {:error, motivo}
  defp generar_resultado(true, _motivo), do: :ok
  defp generar_resultado(false, motivo), do: {:error, motivo}



  # Convierte un texto en entero; si no es entero, intenta convertirlo a decimal
  defp convertir_numero(texto) do
    case Integer.parse(texto) do
      {entero, ""} -> {:ok, entero}
      _ -> convertir_decimal(texto)
    end
  end

  # Convierte un texto en decimal o devuelve :error si no es un número
  defp convertir_decimal(texto) do
    case Float.parse(texto) do
      {decimal, ""} -> {:ok, decimal}
      _ -> :error
    end
  end
end

# Integrantes: Carlos Alberto Zapata Rangel - Isabella Valencia Gomez

# Traspaso de datos de planilla del centro de acopio

defmodule Datos do
  @moduledoc """
  Datos de la planilla del centro de acopio de leche.

  Expone tres listas fijas: `productores/0`, `tanques/0` y `entregas/0`
  (días 1 al 6, con entregas válidas e inválidas).
  """

  @doc """
  Devuelve los 10 productores registrados (P01 a P10).

  Cada mapa tiene `:codigo`, `:nombre` y `:transporte` (`true` si usa el
  servicio de transporte). P10 usa transporte pero no tiene entregas válidas.

  ## Examples

      iex> Datos.productores() |> length()
      10

      iex> Datos.productores() |> List.first()
      %{codigo: "P01", nombre: "Marta Gómez", transporte: true}

  """
  def productores do
    [
      %{codigo: "P01", nombre: "Marta Gómez", transporte: true},
      %{codigo: "P02", nombre: "Luis Cardona", transporte: false},
      %{codigo: "P03", nombre: "Carlos Ramírez", transporte: true},
      %{codigo: "P04", nombre: "Ana Beltrán", transporte: false},
      %{codigo: "P05", nombre: "Jorge Osorio", transporte: true},
      %{codigo: "P06", nombre: "Sandra Londoño", transporte: false},
      %{codigo: "P07", nombre: "Andrés Villegas", transporte: true},
      %{codigo: "P08", nombre: "Diana Ocampo", transporte: false},
      %{codigo: "P09", nombre: "Hernán Arias", transporte: false},
      # P10 usa transporte pero no tiene entregas válidas
      %{codigo: "P10", nombre: "Paula Mejía", transporte: true}
    ]
  end

  @doc """
  Devuelve los 4 tanques de almacenamiento (T1 a T4).

  Cada mapa tiene `:id`, `:nombre` y `:capacidad` (en litros).

  ## Examples

      iex> Datos.tanques() |> length()
      4

      iex> Datos.tanques() |> List.first()
      %{id: "T1", nombre: "Tanque Norte", capacidad: 6000}

  """
     def tanques do
    [
      %{id: "T1", nombre: "Tanque Norte", capacidad: 6000},
      %{id: "T2", nombre: "Tanque Central", capacidad: 5000},
      %{id: "T3", nombre: "Tanque Sur", capacidad: 4500},
      %{id: "T4", nombre: "Tanque Oriente", capacidad: 4000}
    ]
  end

  @doc """
  Devuelve las 97 entregas del periodo: 82 válidas (días 1 al 6) y 15
  inválidas al final.

  Cada mapa tiene `:productor`, `:tanque`, `:dia`, `:litros` y `:grasa`.

  Entre las válidas, los días 2 y 5 no llegan a la meta de 2000 L, y hay una
  `:grasa` entera (`3`) a propósito. Las inválidas se rechazan por un solo
  motivo cada una: `:productor_desconocido` (3), `:tanque_desconocido` (2),
  `:dia_invalido` (3), `:litros_fuera_de_rango` (4) y `:porcentaje_invalido`
  (3). Algunas traen tipos incorrectos a propósito (texto en `:litros` o
  `:grasa`, día decimal).


  """
  # 82 entregas válidas y 15 inválidas al final
  def entregas do
    [
      # día 1
      %{productor: "P01", tanque: "T1", dia: 1, litros: 240, grasa: 3.8},
      %{productor: "P01", tanque: "T2", dia: 1, litros: 230, grasa: 2.9},
      %{productor: "P02", tanque: "T1", dia: 1, litros: 180, grasa: 3.2},
      %{productor: "P02", tanque: "T3", dia: 1, litros: 150, grasa: 3.4},
      %{productor: "P02", tanque: "T2", dia: 1, litros: 110.5, grasa: 3.4},
      %{productor: "P03", tanque: "T2", dia: 1, litros: 300, grasa: 3.6},
      %{productor: "P03", tanque: "T3", dia: 1, litros: 200, grasa: 3.1},
      %{productor: "P04", tanque: "T4", dia: 1, litros: 120, grasa: 2.4},
      %{productor: "P04", tanque: "T1", dia: 1, litros: 160, grasa: 3.0},
      %{productor: "P05", tanque: "T2", dia: 1, litros: 210, grasa: 3.5},
      %{productor: "P05", tanque: "T2", dia: 1, litros: 100, grasa: 3.3},
      %{productor: "P06", tanque: "T3", dia: 1, litros: 350, grasa: 3.7},
      %{productor: "P06", tanque: "T4", dia: 1, litros: 140, grasa: 2.7},
      %{productor: "P07", tanque: "T4", dia: 1, litros: 90, grasa: 4.0},
      %{productor: "P07", tanque: "T1", dia: 1, litros: 130, grasa: 3.1},
      %{productor: "P08", tanque: "T1", dia: 1, litros: 260, grasa: 3.0},

      # día 2 (no llega a la meta, 1950 L)
      %{productor: "P01", tanque: "T1", dia: 2, litros: 200, grasa: 3.5},
      %{productor: "P02", tanque: "T2", dia: 2, litros: 220, grasa: 2.8},
      %{productor: "P02", tanque: "T2", dia: 2, litros: 150, grasa: 3.0},
      %{productor: "P03", tanque: "T3", dia: 2, litros: 180, grasa: 3.2},
      %{productor: "P04", tanque: "T3", dia: 2, litros: 140, grasa: 2.2},
      %{productor: "P05", tanque: "T1", dia: 2, litros: 250, grasa: 3.9},
      %{productor: "P06", tanque: "T2", dia: 2, litros: 120, grasa: 3.1},
      %{productor: "P07", tanque: "T4", dia: 2, litros: 160, grasa: 3.6},
      %{productor: "P07", tanque: "T4", dia: 2, litros: 110, grasa: 3.4},
      %{productor: "P08", tanque: "T3", dia: 2, litros: 90, grasa: 4.8},
      %{productor: "P08", tanque: "T2", dia: 2, litros: 130, grasa: 3.0},
      %{productor: "P09", tanque: "T1", dia: 2, litros: 200, grasa: 3.3},

      # día 3
      %{productor: "P01", tanque: "T3", dia: 3, litros: 400, grasa: 3.6},
      %{productor: "P01", tanque: "T4", dia: 3, litros: 60, grasa: 3.0},
      %{productor: "P02", tanque: "T4", dia: 3, litros: 300, grasa: 3.1},
      # P02 llega justo a 450 L este día
      %{productor: "P02", tanque: "T1", dia: 3, litros: 150, grasa: 3.5},
      %{productor: "P03", tanque: "T1", dia: 3, litros: 220, grasa: 3.0},
      %{productor: "P04", tanque: "T2", dia: 3, litros: 280, grasa: 3.4},
      %{productor: "P04", tanque: "T2", dia: 3, litros: 120, grasa: 2.9},
      %{productor: "P05", tanque: "T3", dia: 3, litros: 190, grasa: 3.2},
      %{productor: "P05", tanque: "T4", dia: 3, litros: 100, grasa: 3.6},
      %{productor: "P06", tanque: "T1", dia: 3, litros: 310, grasa: 3.8},
      %{productor: "P06", tanque: "T2", dia: 3, litros: 90, grasa: 2.8},
      %{productor: "P07", tanque: "T2", dia: 3, litros: 140, grasa: 2.9},
      %{productor: "P08", tanque: "T4", dia: 3, litros: 350, grasa: 2.8},
      %{productor: "P08", tanque: "T1", dia: 3, litros: 130, grasa: 4.2},
      %{productor: "P09", tanque: "T3", dia: 3, litros: 170, grasa: 3.4},

      # día 4
      %{productor: "P01", tanque: "T2", dia: 4, litros: 180, grasa: 3.4},
      %{productor: "P01", tanque: "T3", dia: 4, litros: 120, grasa: 3.2},
      %{productor: "P02", tanque: "T3", dia: 4, litros: 260, grasa: 3.0},
      %{productor: "P03", tanque: "T4", dia: 4, litros: 150, grasa: 2.4},
      %{productor: "P03", tanque: "T4", dia: 4, litros: 130, grasa: 2.6},
      %{productor: "P04", tanque: "T1", dia: 4, litros: 300, grasa: 3.7},
      %{productor: "P04", tanque: "T4", dia: 4, litros: 200, grasa: 3.2},
      %{productor: "P05", tanque: "T2", dia: 4, litros: 240, grasa: 3.1},
      %{productor: "P05", tanque: "T1", dia: 4, litros: 80, grasa: 3.5},
      %{productor: "P06", tanque: "T3", dia: 4, litros: 200, grasa: 3.5},
      %{productor: "P06", tanque: "T2", dia: 4, litros: 100, grasa: 3.0},
      %{productor: "P07", tanque: "T1", dia: 4, litros: 280, grasa: 3.3},
      %{productor: "P08", tanque: "T2", dia: 4, litros: 190, grasa: 2.8},
      %{productor: "P08", tanque: "T3", dia: 4, litros: 160, grasa: 3.1},

      # día 5 (no llega a la meta, 1820 L)
      %{productor: "P01", tanque: "T4", dia: 5, litros: 220, grasa: 3.7},
      %{productor: "P02", tanque: "T1", dia: 5, litros: 190, grasa: 3.0},
      %{productor: "P03", tanque: "T2", dia: 5, litros: 250, grasa: 3.5},
      %{productor: "P04", tanque: "T3", dia: 5, litros: 170, grasa: 3.3},
      %{productor: "P05", tanque: "T4", dia: 5, litros: 130, grasa: 2.3},
      %{productor: "P06", tanque: "T1", dia: 5, litros: 280, grasa: 3.9},
      %{productor: "P06", tanque: "T4", dia: 5, litros: 90, grasa: 3.2},
      # grasa entera a propósito
      %{productor: "P07", tanque: "T3", dia: 5, litros: 200, grasa: 3},
      %{productor: "P07", tanque: "T2", dia: 5, litros: 150, grasa: 3.5},
      %{productor: "P08", tanque: "T4", dia: 5, litros: 140, grasa: 3.0},

      # día 6
      %{productor: "P01", tanque: "T1", dia: 6, litros: 300, grasa: 3.9},
      %{productor: "P01", tanque: "T3", dia: 6, litros: 200, grasa: 3.6},
      %{productor: "P02", tanque: "T4", dia: 6, litros: 210, grasa: 3.2},
      %{productor: "P02", tanque: "T2", dia: 6, litros: 150, grasa: 3.1},
      %{productor: "P03", tanque: "T3", dia: 6, litros: 280, grasa: 3.3},
      %{productor: "P03", tanque: "T1", dia: 6, litros: 120, grasa: 3.0},
      %{productor: "P04", tanque: "T2", dia: 6, litros: 250, grasa: 3.5},
      %{productor: "P04", tanque: "T4", dia: 6, litros: 140, grasa: 3.0},
      %{productor: "P05", tanque: "T1", dia: 6, litros: 330, grasa: 3.4},
      %{productor: "P05", tanque: "T3", dia: 6, litros: 150, grasa: 3.0},
      %{productor: "P06", tanque: "T2", dia: 6, litros: 260, grasa: 3.6},
      %{productor: "P07", tanque: "T3", dia: 6, litros: 190, grasa: 3.2},
      %{productor: "P07", tanque: "T1", dia: 6, litros: 90, grasa: 3.8},
      %{productor: "P08", tanque: "T2", dia: 6, litros: 220, grasa: 2.8},
      %{productor: "P08", tanque: "T4", dia: 6, litros: 100, grasa: 4.9},

      # inválidas: productor_desconocido
      %{productor: "P99", tanque: "T1", dia: 2, litros: 150, grasa: 3.2},
      %{productor: "P00", tanque: "T2", dia: 4, litros: 200, grasa: 3.5},
      # esta tiene todo malo, debe salir solo productor_desconocido
      %{productor: "P98", tanque: "T8", dia: 9, litros: 0, grasa: 20},

      # inválidas: tanque_desconocido
      %{productor: "P03", tanque: "T9", dia: 3, litros: 100, grasa: 3.1},
      %{productor: "P05", tanque: "T0", dia: 5, litros: 180, grasa: 3.4},

      # inválidas: dia_invalido
      %{productor: "P02", tanque: "T1", dia: 7, litros: 120, grasa: 3.2},
      %{productor: "P06", tanque: "T3", dia: 0, litros: 90, grasa: 3.0},
      # día decimal, no es entero
      %{productor: "P04", tanque: "T2", dia: 2.5, litros: 130, grasa: 3.3},

      # inválidas: litros_fuera_de_rango
      %{productor: "P10", tanque: "T2", dia: 3, litros: 950, grasa: 3.5},
      %{productor: "P07", tanque: "T1", dia: 4, litros: 0, grasa: 3.1},
      %{productor: "P01", tanque: "T3", dia: 5, litros: -40, grasa: 3.0},
      # litros como texto
      %{productor: "P04", tanque: "T4", dia: 6, litros: "cien", grasa: 3.2},

      # inválidas: porcentaje_invalido
      %{productor: "P03", tanque: "T2", dia: 5, litros: 200, grasa: 16.5},
      %{productor: "P09", tanque: "T3", dia: 6, litros: 110, grasa: -1},
      # grasa como texto
      %{productor: "P06", tanque: "T1", dia: 2, litros: 140, grasa: "3.5"}
    ]
  end
  end

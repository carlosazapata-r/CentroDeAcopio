# Traspaso de datos de planilla del centro de acopio

defmodule Datos do

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
     def tanques do
    [
      %{id: "T1", nombre: "Tanque Norte", capacidad: 6000},
      %{id: "T2", nombre: "Tanque Central", capacidad: 5000},
      %{id: "T3", nombre: "Tanque Sur", capacidad: 4500},
      %{id: "T4", nombre: "Tanque Oriente", capacidad: 4000}
    ]
  end
  end

end

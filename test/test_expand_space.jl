using Catalyst: spatial_convert_err
include("../src/DiscreteStochasticSimulation.jl")
using .DiscreteStochasticSimulation
using Catalyst
using Test

test_expand = begin

  local k₁, k₂, X, Y
  rn = @reaction_network begin
    k₁, 0 --> X
    k₂, 0 --> Y
    k₃, X + Y --> X
  end

  # define a state and place it in a state set 
  U₀ = CartesianIndex(50, 50)
  X = Set([U₀])

  # define boundaries (rectangular lattice in this case)
  bounds = (0, 100)
  boundary_condition(x) = RectLatticeBoundaryCondition(x, bounds)

  # expand state space 
  model = DiscreteStochasticSystem(rn)
  X = Expand1!(X, model, boundary_condition)

  true == true
end

@test test_expand

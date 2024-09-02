using Catalyst: spatial_convert_err
include("../src/DiscreteStochasticSimulation.jl")
using .DiscreteStochasticSimulation
using Catalyst

experiment = begin

  # birth death chemical reactions 
  local k₁, k₂, k₃, k₄, X, Y
  rn = @reaction_network begin
    k₁, 0 --> X
    k₂, X --> 0
    k₃, X + Y --> 2Y
    k₄, Y --> 0
  end

  # define discrete stochastic system
  model = DiscreteStochasticSystem(rn)

  # define boundaries (rectangular lattice in this case)
  bounds = (0, 100)
  boundary_condition(x) = RectLatticeBoundaryCondition(x, bounds)

  # define initial value and expand the space a bit 
  U₀ = CartesianIndex(50, 50)
  X = Set([U₀])

  # expand 
  X = Expand!(X, model, boundary_condition, 2)

  # source states
  MasterOperator(X, model, boundary_condition, 0)

end

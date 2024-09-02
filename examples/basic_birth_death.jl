using Catalyst: spatial_convert_err
include("../src/DiscreteStochasticSimulation.jl")
using .DiscreteStochasticSimulation
using Catalyst
using Plots
using Expokit

experiment = begin

  # birth death chemical reactions 
  local k₁, k₂, X
  rn = @reaction_network begin
    k₁, 0 --> X
    k₂, X --> 0
  end

  # define discrete stochastic system
  model = DiscreteStochasticSystem(rn)

  # define boundaries (rectangular lattice in this case)
  bounds = 100
  boundary_condition(x) = RectLatticeBoundaryCondition(x, bounds)

  # define initial value and expand the space a bit 
  U₀ = CartesianIndex(50)
  X = Set([U₀])

  # expand 
  X = Expand!(X, model, boundary_condition, 20)

  # source states
  A = MasterOperator(X, model, [1.0, 0.1], boundary_condition, 1.0)
  Plots.bar(expmv(1.0, A, p₀))
  display(A)

end

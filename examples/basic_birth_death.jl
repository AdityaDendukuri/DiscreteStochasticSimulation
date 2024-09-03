using Catalyst: spatial_convert_err
include("../src/DiscreteStochasticSimulation.jl")
using .DiscreteStochasticSimulation
using Catalyst
using Plots
using Expokit

experiment = begin
  # birth death chemical reactions 
  local k₁, k₂, X, Y
  rn = @reaction_network begin
    k₁, X --> Y
    k₂, X + Y --> 2X + Y
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
  X = Expand!(X, model, boundary_condition, 20)
  A = MasterEquation(X, model, [1.0, 0.4], boundary_condition, 1.0)

  # probability
  P = zeros(bounds[2], bounds[2])
  li = LinearIndices(P)
  p₀ = zeros(X |> length)
  p₀[DiscreteStochasticSimulation.FindElement(U₀, X)] = 1
  p₀ = expmv(1.0, A, p₀)
  sum(A, dims=1) |> display

  P[X|>collect] = p₀

  f = heatmap(P)
  savefig(f, "asd.png")
end

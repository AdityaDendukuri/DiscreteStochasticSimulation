using Catalyst: spatial_convert_err
include("../src/DiscreteStochasticSimulation.jl")
using .DiscreteStochasticSimulation
using Catalyst
using Plots
using Expokit

experiment = begin

  local k₁, k₂, X
  rn = @reaction_network begin
    k₁, 0 --> X
    k₂, X --> 0
  end


  # define discrete stochastic system
  model = DiscreteStochasticSystem(rn)

  # define boundaries (rectangular lattice in this case)
  bounds = (0, 100)
  boundary_condition(x) = RectLatticeBoundaryCondition(x, bounds)

  # define initial value and expand the space a bit 
  U₀ = CartesianIndex(1)
  X = Set([U₀])

  # expand
  X = Expand!(X, model, boundary_condition, 50)
  A = MasterEquation(X, model, [10.0, 1.0], boundary_condition, 0.25)

  # probability
  P1 = zeros(bounds[2])
  P2 = zeros(bounds[2])
  P3 = zeros(bounds[2])

  # full initial probability vector
  p₀ = zeros(X |> length)
  p₀[DiscreteStochasticSimulation.FindElement(U₀, X)] = 1

  # compute solution at three different times
  p₁ = expmv(0.5, A, p₀)
  p₂ = expmv(0.75, A, p₀)
  p₃ = expmv(1.0, A, p₀)

  # plot everything
  P1[X|>collect] = p₁
  f = bar(P1)
  savefig(f, "asd1.png")
  P2[X|>collect] = p₂
  f = bar(P2)
  savefig(f, "asd2.png")
  P3[X|>collect] = p₃
  f = bar(P3)
  savefig(f, "asd3.png")

end

include("../src/DiscreteStochasticSimulation.jl")
using .DiscreteStochasticSimulation
using Catalyst
using Plots
using Expokit


experiment = begin

  # define reaction network 
  local k₁, k₂, k₃, k₄, k₅, k₆, g₁, g₂, g₃, g₄, LRP
  rn = @reaction_network begin
    k₁, g₁ + LRP --> g₂
    k₂, g₂ --> g₁ + LRP
    k₃, g₁ + LRP --> g₃
    k₄, g₃ --> g₁ + LRP
    k₅, g₁ + LRP --> g₄
    k₆, g₄ --> g₁ + LRP
  end
  model = DiscreteStochasticSystem(rn)

  # boundary conditions 
  bounds = (0, 100)
  boundary_condition(x) = RectLatticeBoundaryCondition(x, bounds)

  # define fsp system 
  U₀ = CartesianIndex(10, 10, 10, 10, 20)
  X = Set([U₀])

  # expand
  X = Expand!(X, model, boundary_condition, 5)

  A = MasterEquation(X, model, [1.0, 1.375, 1.0, 1.2, 1.0, 1.3], boundary_condition, 0.25)

  idxs = sortperm([x[1] for x ∈ collect(X)])
  display(A[idxs, idxs])

end

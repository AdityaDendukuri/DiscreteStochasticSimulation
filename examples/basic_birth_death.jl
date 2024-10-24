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
  X = Expand!(X, model, boundary_condition, 20)
  A = MasterEquation(X, model, [10.0, 1.0], boundary_condition, 0.25)

  # probability
  P1 = zeros(bounds[2])
  P2 = zeros(bounds[2])
  P3 = zeros(bounds[2])

  # full initial probability vector
  p₀ = zeros(X |> length)
  p₀[DiscreteStochasticSimulation.FindElement(U₀, X)] = 1

  δt = 0.01
  global pₜ = p₀
  a = @animate for t ∈ 0:0.1:10
    global pₜ = expmv(δt, A, pₜ)
    P1 = zeros(bounds[2])
    P1[X|>collect] = pₜ
    f = bar(P1)
    ylims!(0.0, 1.0)
  end
  gif(a, "anim_fps15.gif")


end



using Catalyst: spatial_convert_err
include("../src/DiscreteStochasticSimulation.jl")
using .DiscreteStochasticSimulation
using Catalyst
using ProgressMeter
using Plots
using Expokit

experiment = begin

  local k₁, k₂, k₃, X, Y
  rn = @reaction_network begin
    k₁, X --> 2X
    k₂, X + Y --> 2Y
    k₃, Y --> 0
  end


  # define discrete stochastic system
  model = DiscreteStochasticSystem(rn)

  # define boundaries (rectangular lattice in this case)
  bounds = (0, 100)
  boundary_condition(x) = RectLatticeBoundaryCondition(x, bounds)

  # define initial value and expand the space a bit 
  U₀ = CartesianIndex(30, 30)
  X = Set([U₀])
  X = Expand!(X, model, boundary_condition, 20)

  # full initial probability vector
  p₀ = zeros(X |> length)
  p₀[DiscreteStochasticSimulation.FindElement(U₀, X)] = 1

  # probability
  P1 = zeros(bounds[2], bounds[2])

  δt = 0.01
  global pₜ = p₀
  a = @animate for t ∈ 0:0.01:0.5

    #expand space and assemble matrix
    X = Expand!(X, model, boundary_condition, 10)
    A = MasterEquation(X, model, [1.0, 0.25, 0.001], boundary_condition, t)

    # solve system and normalize 
    global pₜ = expmv(δt, A, pₜ)
    pₜ /= sum(pₜ)

    # purge lowest 50% probability states
    X = Purge!(X, pₜ, 30)

    # set probability values to full space for visualization 
    P1 .= 0
    P1[X|>collect] = pₜ
    f = heatmap(P1)

  end
  gif(a, "anim_fps15.gif")

end

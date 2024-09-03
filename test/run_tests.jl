
include("../src/DiscreteStochasticSimulation.jl")
using Catalyst
using .DiscreteStochasticSimulation
using Test

@testset "State Space" begin
  include("test_state_space_exploration.jl")
end

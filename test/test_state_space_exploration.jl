using .DiscreteStochasticSimulation
using Test

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

# expand space 
X = Expand1!(X, model, boundary_condition)

# test if states in expanded space
@testset "find reachable states" begin
  @test collect(X) |> length == 3
  @test CartesianIndex(50) ∈ X
  @test CartesianIndex(51) ∈ X
  @test CartesianIndex(49) ∈ X
end

# test source states 
X₁ = GetSourceStates(CartesianIndex(49), model, boundary_condition)
X₂ = GetSourceStates(CartesianIndex(51), model, boundary_condition)
X₃ = GetSourceStates(CartesianIndex(50), model, boundary_condition)

@testset "find source states" begin
  @test CartesianIndex(50) ∈ (X₁ ∩ X₂)
  @test (X₁ ∪ X₂ ∪ X₃) ∩ X == X
  @test setdiff(X₁ ∪ X₂ ∪ X₃, X) == Set([CartesianIndex(48), CartesianIndex(52)])
end

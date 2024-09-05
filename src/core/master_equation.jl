
struct MasterOperatorIngredients{T,ElementType,ModelType}
  active_states_vec::Vector{ElementType} # currently active states 
  state_id_map::Dict # an integer id for each source state 
  bound_cond::Function
  model::ModelType # underlying model of the system 
  rates::Vector{T} # rates for eahc reaction channel 
  t::T # current time step 
end

function MasterEquationNonDiagonal(matrix_values::MasterOperatorIngredients)
  # unpack values 
  active_states = matrix_values.active_states_vec
  state_id_map = matrix_values.state_id_map
  boundary_condition = matrix_values.bound_cond
  model = matrix_values.model
  rates = matrix_values.rates
  t = matrix_values.t

  # Get source state for each active state 
  source_states = map(active_states) do state
    sources = ExpandBackward(state, model, boundary_condition)
    filter(x -> x ∈ active_states, sources)
  end

  # for each source state 
  non_diag = map(source_states |> enumerate) do source
    i, X = source
    map(X |> collect) do xⱼ
      # get connected state id 
      j = state_id_map[xⱼ]
      xᵢ = active_states[i]
      # get the corrosponding reaction 
      S = xᵢ - xⱼ
      k = FindElement(S, model.stoichvecs)
      α = model.propensities[k](xⱼ, rates, t)
      # define sparse matrix entry 
      (i, j, α)
    end
  end |> Make1D

  # construct sparse matrix
  I = [X[1] for X ∈ non_diag]
  J = [X[2] for X ∈ non_diag]
  K = [X[3] for X ∈ non_diag]

  # define sparse matrix
  sparse(I, J, K)
end

function MasterEquationDiagonal(matrix_values::MasterOperatorIngredients)
  # unpack values 
  active_states = matrix_values.active_states_vec
  model = matrix_values.model
  rates = matrix_values.rates
  t = matrix_values.t

  # for each source state 
  diagonal_elements = map(active_states |> enumerate) do state
    i, xᵢ = state
    α = map(model.stoichvecs |> enumerate) do reaction
      k, S = reaction
      xⱼ = xᵢ + S
      α = model.propensities[k](xⱼ, rates, t)
    end |> sum
    (i, -α)
  end

  # construct sparse matrix
  I = [X[1] for X ∈ diagonal_elements]
  K = [X[2] for X ∈ diagonal_elements]

  # define sparse matrix
  sparse(I, I, K)
end

function MasterEquation(active_states::Set{ElementType}, model::ModelType, rates::Array{T}, boundary_condition::Function, t::T) where {T,ElementType,ModelType}

  # state id values for assembling matrix
  active_states_vec = collect(active_states)
  state_id_map = Dict(active_states .=> LinearIndices(active_states_vec))

  matrix_ingredients = MasterOperatorIngredients(active_states_vec, state_id_map, boundary_condition, model, rates, t)
  S₁ = MasterEquationNonDiagonal(matrix_ingredients)
  S₂ = MasterEquationDiagonal(matrix_ingredients)
  # diag + non-diag 
  S₁ + S₂
end

export MasterEquation

"""
    MasterOperator(states::Set{ElementType}, model::DiscreteModel) where {ElementType,DiscreteModel}

TBW
"""
function MasterOperator(states::Set{ElementType}, model::ModelType, rates::Array{T}, boundary_condition::Function, t::T) where {T,ElementType,ModelType}

  # get all source state ids  (stats from which the current state is reachable)
  state_vec = collect(states)
  edges = map(state_vec) do state
    source_states = GetSourceStates(state, model, boundary_condition)
    FindElement(source_states, states) |> FilterEmptyValues
  end

  # indices to construct sparse matrix 
  J = [i for i in eachindex(edges) for _ in edges[i]]
  I = [val for subvec in edges for val in subvec]

  # compute edge values 
  edge_values = map(zip(I, J)) do edge
    # get the reaction responsible for the edge 
    i, j = edge
    Xᵢ, Xⱼ = state_vec[i], state_vec[j]
    k = FindElement(Xⱼ - Xᵢ, stoichvecs(model))
    # set propensity value 
    model.propensities[k](Xᵢ, rates, t)
  end

  # compute diagonal values 
  diag_values = map(state_vec |> enumerate) do state
    i, x = state
    reachable_states = GetReachableStates(x, model, boundary_condition)
    sum([model.propensities[i](state, rates, t) for (i, state) in enumerate(reachable_states)])
  end

  # add diagonal indices in sparse representation 
  I = [I; collect(1:length(state_vec))]
  J = [J; collect(1:length(state_vec))]
  K = [edge_values; diag_values]


  sparse(I, J, K)

end

export MasterOperator


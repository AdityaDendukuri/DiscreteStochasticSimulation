"""
    MasterOperator(states::Set{ElementType}, model::DiscreteModel) where {ElementType,DiscreteModel}

TBW
"""
function MasterOperator(states::Set{ElementType}, model::ModelType, boundary_condition::Function) where {ElementType,ModelType}

  # get all source state ids  (stats from which the current state is reachable)
  edges = map(states |> collect) do state
    source_states = GetSourceStates(state, model, boundary_condition)
    FindElement(source_states, states) |> FilterEmptyValues
  end

  # indices to construct sparse matrix 
  J = [i for i in eachindex(edges) for _ in edges[i]]
  I = [val for subvec in edges for val in subvec]

  # 
end

export MasterOperator


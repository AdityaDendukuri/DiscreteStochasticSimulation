
"""
    Expand1!(X::Set{Element}, model::Model, boundary_condition::Function) where {Element,Model}

TBW
"""
function Expand1!(X::Set{Element}, model::Model, boundary_condition::Function) where {Element,Model}
  map(X |> collect) do x
    X = X ∪ GetReachableStates(x, model, boundary_condition)
  end |> Set |> CombineSets
end

"""
    Expand!(X::Set{Element}, model::Model, boundary_condition::Function, N::Int) where {Element,Model}

TBW
"""
function Expand!(X::Set{Element}, model::Model, boundary_condition::Function, N::Int) where {Element,Model}
  for _ ∈ 1:N
    X = Expand1!(X, model, boundary_condition)
  end
  return X
end

export Expand1!, Expand!, GetSourceStates

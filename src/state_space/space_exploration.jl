"""
    GetConnectedStates(x::Element, model::Model, boundary_condition::Function) where {Element,Model}

TBW
"""
function GetReachableStates(x::Element, model::Model, boundary_condition::Function) where {Element,Model}
  map(model.forward) do f
    y = f(x)
    boundary_condition(y) ? y : x
  end |> Set
end

"""
    GetSourceStates(X::Element, model::Model) where {Element,Model}

TBW
"""
function GetSourceStates(x::Element, model::Model, boundary_condition::Function) where {Element,Model}
  map(model.backward) do f
    y = f(x)
    boundary_condition(y) ? y : x
  end |> Set
end


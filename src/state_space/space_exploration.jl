"""
    GetConnectedStates(x::Element, model::Model, boundary_condition::Function) where {Element,Model}

TBW
"""
function GetReachableStates(x::Element, model::Model, boundary_condition::Function) where {Element,Model}
  map(model.stoichvecs) do S
    x_ = x + S
    boundary_condition(x_) ? x_ : x
  end |> Set
end

"""
    GetSourceStates(X::Element, model::Model) where {Element,Model}

TBW
"""
function GetSourceStates(x::Element, model::Model, boundary_condition::Function) where {Element,Model}
  map(model.stoichvecs) do S
    x_ = x - S
    boundary_condition(x_) ? x_ : x
  end |> Set
end


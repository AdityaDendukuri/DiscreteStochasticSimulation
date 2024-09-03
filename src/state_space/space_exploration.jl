"""
    GetConnectedStates(x::Element, model::Model, boundary_condition::Function) where {Element,Model}

TBW
"""
function ExpandForward(x::Element, model::Model, boundary_condition::Function) where {Element,Model}
  map(model.stoichvecs) do S
    x_ = x + S
    boundary_condition(x_) ? x_ : nothing
  end |> FilterEmptyValues |> Set
end

"""
    GetSourceStates(X::Element, model::Model) where {Element,Model}

TBW
"""
function ExpandBackward(x::Element, model::Model, boundary_condition::Function) where {Element,Model}
  map(model.stoichvecs) do S
    x_ = x - S
    boundary_condition(x_) ? x_ : nothing
  end |> FilterEmptyValues |> Set
end


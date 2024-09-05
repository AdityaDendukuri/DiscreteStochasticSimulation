"""
    Expand1!(X::Set{Element}, model::Model, boundary_condition::Function) where {Element,Model}

TBW
"""
function Expand1!(X::Set{Element}, model::Model, boundary_condition::Function) where {Element,Model}
  map(X |> collect) do x
    X = X ∪ ExpandForward(x, model, boundary_condition)
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

function Expand!(X::Set{Element}, pₜ::Vector, model::Model, boundary_condition::Function, N::Int) where {Element,Model}
  X_prev = X |> collect
  for _ ∈ 1:N
    X = Expand1!(X, model, boundary_condition)
  end
  idxs = [findfirst(x_ -> x_ == x__, X |> collect) for x__ ∈ X_prev]
  qₜ = zeros(X |> length)
  qₜ[idxs] = pₜ
  return X, qₜ
end

"""
    Purge!(X::Set{Element}, p::Vector{T}, percentage::Number) where {Element,T}

TBW
"""
function Purge!(X::Set{Element}, p::Vector{T}, percentage::Number) where {Element,T}
  X_ = X |> collect
  idxs = FindLowestValuesPercent(p, percentage)
  p = [p[i] for i ∈ eachindex(p) if !(i ∈ idxs)]
  return setdiff(X, Set(X_[idxs])), p
end

export Expand1!, Expand!, Purge!

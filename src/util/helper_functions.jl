"""
    CombineSets(X::Set{Set{Element}}) where {Element}

TBW
"""
function CombineSets(X::Set{Set{Element}}) where {Element}
  reduce(union!, X)
end


"""
    FindElement(X::Element, states::Set{Element}) where {Element}

TBW
"""
function FindElement(X::Element, states::Set{Element}) where {Element}
  findfirst(x -> x == X, states |> collect)
end


"""
    FindElement(X::Element, states::Set{Element}) where {Element}

TBW
"""
function FindElement(X::Set{Element}, states::Set{Element}) where {Element}
  map(X |> collect) do x
    FindElement(x, states)
  end
end

"""
    FilterEmptyValues(X::Vector{Union{Nothing,T}}) where {T}

TBW
"""
function FilterEmptyValues(X::Vector{Union{Nothing,T}}) where {T}
  filter(x -> !isnothing(x), X) |> Vector{T}
end

"""
    FilterEmptyValues(X::Vector{T}) where {T}

TBW
"""
function FilterEmptyValues(X::Vector{T}) where {T}
  filter(x -> !isnothing(x), X)
end

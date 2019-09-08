struct PermutedVector{T, C, P} <: AbstractVector{T}
    parent::C
    permutation::P
    function PermutedVector(parent::C; permutation::P = sortperm(parent)) where {C, P}
        new{eltype(parent), C, P}(parent, permutation)
    end
end

Base.parent(p::PermutedVector) = getfield(p, 1)
permutation(p::PermutedVector) = getfield(p, 2)
Base.size(p::PermutedVector) = size(parent(p))
Base.axes(p::PermutedVector) = axes(parent(p))
Base.@propagate_inbounds function Base.getindex(p::PermutedVector, i::Int)
    Base.@boundscheck checkbounds(permutation(p), i)
    @inbounds ret = getindex(parent(p), permutation(p)[i])
    return ret
end
Base.IndexStyle(::Type{<:PermutedVector}) = IndexLinear()

struct PermutedSubVector{T, C, P, I<:AbstractUnitRange} <: AbstractVector{T}
    parent::C
    permutation::P
    indices::I
    function PermutedSubVector(parent::C;
                            permutation::P = sortperm(parent),
                            indices::I = axes(permutation, 1)) where {C, P, I}
        new{eltype(parent), C, P, I}(parent, permutation, indices)
    end
end

Base.parent(p::PermutedSubVector) = getfield(p, 1)
permutation(p::PermutedSubVector) = getfield(p, 2)
indices(p::PermutedSubVector) = getfield(p, 3)
Base.size(p::PermutedSubVector) = size(indices(p))
Base.axes(p::PermutedSubVector) = axes(indices(p))
Base.@propagate_inbounds function Base.getindex(p::PermutedSubVector, i::Int)
    Base.@boundscheck checkbounds(indices(p), i)
    i1 = first(indices(p)) + (i - 1)
    @inbounds ret = getindex(parent(p), permutation(p)[i1])
    return ret
end
Base.IndexStyle(::Type{<:PermutedSubVector}) = IndexLinear()

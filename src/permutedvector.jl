struct PermutedVector{T, C, P} <: AbstractVector{T}
    parent::C
    sortperm::P
    function PermutedVector(parent::C; sortperm::P = sortperm(parent)) where {C, P}
        new{eltype(parent), C, P}(parent, sortperm)
    end
end

Base.parent(p::PermutedVector) = getfield(p, 1)
Base.sortperm(p::PermutedVector) = getfield(p, 2)
Base.size(p::PermutedVector) = size(parent(p))
Base.axes(p::PermutedVector) = axes(parent(p))
Base.getindex(p::PermutedVector, i::Int) = getindex(parent(p), sortperm(p)[i])
Base.IndexStyle(::Type{<:PermutedVector}) = IndexLinear()

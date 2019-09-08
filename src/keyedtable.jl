struct KeyedTable{K, V}
    keys::K
    values::V
end

Base.keys(kt::KeyedTable) = getfield(kt, 1)
Base.values(kt::KeyedTable) = getfield(kt, 2)
function Base.pairs(kt::KeyedTable{K, V}) where {K, V}
    KE, VE = eltype(K), eltype(V)
    return StructArray{Pair{KE, VE}}((keys(kt), values(kt)))
end


struct KeyedTable{K, V}
    keys::K
    values::V
end

function KeyedTable(iter)
    str = StructArray(iter)
    return KeyedTable(fieldarrays(str))
end

KeyedTable(kt::KeyedTable) = kt

Base.keys(kt::KeyedTable) = getfield(kt, 1)
Base.values(kt::KeyedTable) = getfield(kt, 2)
function Base.pairs(kt::KeyedTable{K, V}) where {K, V}
    KE, VE = eltype(K), eltype(V)
    return StructArray{Pair{KE, VE}}((keys(kt), values(kt)))
end

function group(kt::KeyedTable; sortperm = sortperm(keys(kt)))
    itr = GroupPerm(keys(kt), sortperm)
    (keys(kt)[first(idxs)] => PermutedSubVector(values(kt),
                                                permutation = sortperm,
                                                indices = idxs) for idxs in itr)
end

struct SortedKeyedTable{K, V}
    keys::K
    values::V
end

function Base.merge(f::Function, kt1::SortedKeyedTable{K}, kt2::SortedKeyedTable{K}) where {K}
    k1, k2 = keys(kt1), keys(kt2)
    itr = GroupJoinPerm(k1, k2, axes(k1)[1], axes(k2)[1])
    f = function ((idxs1, idxs2),)
        key = isempty(idxs1) ? k2[first(idxs2)] : k1[first(idxs1)]
        v2 = PermutedSubVector(values(k1);
                               permutation = sortperm(kt1))


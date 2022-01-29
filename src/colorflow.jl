using LinearAlgebra: norm

using Colors: HSV

"""
    colorflow(flo; maxflow)

Visualize the given flow field `flo` by creating an image encoding
direction as color and length as saturation (scaled using `maxflow`).
Missing values are encoded as black.
If `maxflow` is omitted, it will be computed from the input using the `maxflow`
function.
"""
function colorflow(flo; maxflow = maxflow(flo))
    CT = HSV{Float32}
    color(x1, x2) = ismissing(x1) || ismissing(x2) ?
        CT(0, 1, 0) :
        CT(180f0 / pi * atan(x1, x2), norm((x1, x2)) / maxflow, 1)
    x1 = selectdim(flo, 1, 1)
    x2 = selectdim(flo, 1, 2)
    return color.(x1, x2)
end

"""
    maxflow(flo)

Compute maximum 2-norm of all displacement vectors.
Missing values are skipped.
"""
function maxflow(flo)
    return maximum(CartesianIndices(axes(flo)[2:end])) do I
        v = view(flo, :, I)
        any(ismissing, v) && return zero(eltype(flo))
        return norm(v)
    end
end

using LinearAlgebra: norm

using Colors: HSV

"""
    colorflow(flo; maxflow=maximum(skipmissing(norm.(flo))))

Visualize the given 2d-vectorfield `flo` by creating an image encoding
direction as color and length as saturation.
Missing values are encoded as black.
"""
function colorflow(flo; maxflow=maximum(skipmissing(norm.(flo))))
    CT = HSV{Float32}
    color(v) = any(ismissing, v) ?
        CT(0, 1, 0) : CT(180f0 / pi * atan(v[1], v[2]), norm(v) / maxflow, 1)
    return color.(flo)
end

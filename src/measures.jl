using LinearAlgebra: dot, norm

function angular_error(x, y)
    x3 = (1, x...)
    y3 = (1, y...)
    z = dot(x3, y3) / sqrt(dot(x3, x3) * dot(y3, y3))
    # gracefully handle z > 1 in case of rounding errors
    return acos(clamp(z, 0., 1.))
end

function endpoint_error(x, y)
    return norm(x .- y)
end

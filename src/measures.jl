using LinearAlgebra: dot, norm

using StaticArrays: Size, similar_type

function angular_error(x::SVector{2}, y::SVector{2})
    x3 = similar_type(x, Size(3))(1, x...)
    y3 = similar_type(y, Size(3))(1, y...)
    z = dot(x3, y3) / sqrt(dot(x3, x3) * dot(y3, y3))
    # gracefully handle z > 1 in case of rounding errors
    return acos(clamp(z, 0., 1.))
end

function endpoint_error(x::SVector{2}, y::SVector{2})
    return norm(x .- y)
end

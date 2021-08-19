# Optical flow `.flo` fileformat¹² as used by various optical flow
# benchmarks³⁴.
#
# Implementation notes:
#   - to match behaviour for image data the flow vector field is transformed to
#     julia col-major (i.e. height is first dimension)
#   - missing data (i.e. any component `> 1f9`) is represented using the
#     Missing type in julia
#   - as satisfied per spec `floatmax(Float32)` is used to save missing data
#
# [1] https://vision.middlebury.edu/flow/code/flow-code/README.txt
# [2] https://doi.org/10.1007/s11263-010-0390-2
# [3] https://vision.middlebury.edu/flow/
# [4] http://sintel.is.tue.mpg.de/

using FileIO: File, Stream, @format_str, skipmagic, magic

const iodims = 2
const T = Float32
const T_ = Union{Missing,T}
const nodata = floatmax(T)

function load(f::File{format"FLO"})
    open(f) do s
        skipmagic(s)
        load(s)
    end
end

function load(s::Stream{format"FLO"})
    sz = ntuple(iodims) do k
        read(s, Int32) |> ltoh
    end

    data = Array{T_}(undef, iodims, sz...)
    for I in eachindex(data)
        data[I] = read(s, T) |> ltoh
    end

    for J in CartesianIndices(sz)
        Jv = view(data, :, J)
        # spec wording is misleading: infering from the ground truth files
        # it should be "or" instead of "either or"
        if any(x -> abs(x) > 1f9, Jv)
            Jv .= missing
        end
    end
    # row- to col-major
    reverse!(data, dims = 1)
    return permutedims(data, (1, 3, 2, (4:iodims + 1)...))
end

function save(f::File{format"FLO"}, data::AbstractArray)
    open(f, "w") do s
        write(s, magic(format"FLO"))
        save(s, data)
    end
end

function save(s::Stream{format"FLO"}, data::AbstractArray)
    size(data, 1) != ndims(data) - 1 &&
        throw(ArgumentError("invalid dimensions $(size(data)) for flow field"))

    # col- to row-major
    data = permutedims(data, (1, 3, 2, (4:iodims + 1)...))
    reverse!(data, dims = 1)

    for k in 1:iodims
        write(s, Int32(size(data, k + 1)) |> htol)
    end

    for I in eachindex(data)
        v = convert(T, coalesce(data[I], nodata))
        write(s, v |> htol)
    end
end

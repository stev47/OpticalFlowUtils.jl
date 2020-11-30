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
using StaticArrays: StaticVector, SVector

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
    sz = read(s, SVector{iodims,Int32}) .|> ltoh
    data = Matrix{SVector{iodims,T_}}(undef, sz...)

    for I in eachindex(data)
        v = read(s, SVector{iodims,T}) .|> ltoh

        # transform directions row- to col-major
        v = reverse(v)

        # spec wording is misleading: infering from the ground truth files
        # it should be "or" instead of "either or"
        data[I] = any(abs.(v) .> 1f9) ?
            fill(missing, SVector{iodims,T_}) : v
    end
    # row- to col-major
    return permutedims(data)
end

function save(f::File{format"FLO"}, data::FlowField)
    open(f, "w") do s
        write(s, magic(format"FLO"))
        save(s, data)
    end
end

function save(s::Stream{format"FLO"}, data::FlowField)
    # col- to row-major
    data = permutedims(data)

    write(s, SVector{iodims,Int32}(size(data)) .|> htol)

    for I in eachindex(data)
        v = convert.(T, coalesce.(data[I], nodata))

        # transform directions col- to row-major
        v = reverse(v)

        write.(Ref(s), v .|> htol)
    end
end

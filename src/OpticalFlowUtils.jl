module OpticalFlowUtils

export colorflow

using StaticArrays: StaticVector

const FlowField = AbstractArray{<:Union{StaticVector{N},NTuple{N}},N} where N

include("io.jl")
include("colorflow.jl")

# TODO: remove once file format has been registered
@info """Until the *.flo file format is registered in `FileIO` you may want to
do so yourself:
    using FileIO: @format_str, add_format
    add_format(format"FLO", b"PIEH", ".flo", [:OpticalFlowUtils])
"""

end # module

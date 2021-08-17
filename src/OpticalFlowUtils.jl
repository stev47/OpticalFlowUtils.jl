module OpticalFlowUtils

export colorflow, angular_error, endpoint_error

using StaticArrays: StaticVector

const FlowField = AbstractArray{<:Union{StaticVector{N},NTuple{N}},N} where N

include("io.jl")
include("colorflow.jl")
include("measures.jl")

end # module

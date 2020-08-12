module OpticalFlowUtils

export colorflow

using StaticArrays: StaticVector

const FlowField = AbstractArray{<:StaticVector{N},N} where N

include("io.jl")
include("colorflow.jl")

end # module

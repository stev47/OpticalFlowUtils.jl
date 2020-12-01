# OpticalFlowUtils

Basic operations for handling optical flow vector fields:

  - `load/save` to [`.flo` fileformat¹](https://vision.middlebury.edu/flow/code/flow-code/README.txt)
  - `colorflow` to visualize the flow field

## Usage

```julia
using OpticalFlowUtils, FileIO, Plots

x = load("input.flo")

plot(colorflow(x))

save("output.flo", x)
```

## User Notes

  - loaded flow fields currently have the type signature
    `Array{SVector{2,Union{Missing,Float32}},2}`
  - you should be able to save any of the following:
      - `AbstractArray{<:NTuple{2},2}`
      - `AbstractArray{<:SVector{2},2}`

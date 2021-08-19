# OpticalFlowUtils

Basic operations for handling optical flow vector fields:

  - `load/save` to [`.flo` fileformat¹](https://vision.middlebury.edu/flow/code/flow-code/README.txt)
  - `colorflow` to visualize the flow field

## Example Usage

```julia
using OpticalFlowUtils, FileIO, Plots

x = load("input.flo")

plot(colorflow(x))

save("output.flo", x)
```

## User Notes

  - loaded flow fields have type `Array{Union{Missing, Float32}, 3}` with the
    first dimension containing the pointwise flow direction.

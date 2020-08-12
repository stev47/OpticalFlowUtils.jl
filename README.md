# OpticalFlowUtils

Basic operations for handling optical flow vector fields.
Current features include

  - `load/save` to `.flo` fileformat
  - `colorflow` to visualize the flow field

## Usage

```julia
using OpticalFlowUtils, FileIO, Plots

x = load("input.flo")

plot(colorflow(x))

save("output.flo", x)
```

## Implementation Notes

 - flow fields have the type signature `AbstractArray{<:StaticVector{N},N} where N`
   while currently only `N = 2` is supported.

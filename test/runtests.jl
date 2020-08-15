using Test

using FileIO: Stream, File, @format_str, load, save
using OpticalFlowUtils
using StaticArrays: SA

#@testset "io" begin
#    data = UInt32[0x48454950, 0x00000002, 0x00000001, 0x00000000, 0x3f800000, 0x7f7fffff, 0x00000000]
#
#    file, io = mktemp()
#    write(io, data)
#    close(io)
#
#    x = load(file)
#    @test size(x) == (1, 2)
#    @test x[1, 1] == SA[1., 0]
#    @test all(ismissing, x[1, 2])
#
#    save(file, x)
#    saveddata = reinterpret(eltype(data), read(file))
#    # last entry will be written as being missing
#    @test saveddata[1:end-1] == data[1:end-1]
#    @test saveddata[end] == 0x7f7fffff
#end

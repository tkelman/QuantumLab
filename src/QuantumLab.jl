module QuantumLab

print(" + (ProgressMeter................")
using ProgressMeter
ProgressMeter.printover(STDOUT," + (Reexport...................")
using Reexport
ProgressMeter.printover(STDOUT,"")

print(" + BaseModule..................")
include("SubModules/BaseModule.jl")
@reexport using .BaseModule
println("Done.")

print(" + AtomModule..................")
include("SubModules/AtomModule.jl")
@reexport using .AtomModule 
println("Done.")

print(" + GeometryModule..............")
include("SubModules/GeometryModule.jl")
@reexport using .GeometryModule
println("Done.")

print(" + BasisSetModule..............")
include("SubModules/BasisSetModule.jl")
@reexport using .BasisSetModule
println("Done.")

print(" + BasisFunctionsModule........")
include("SubModules/BasisFunctionsModule.jl")
@reexport using .BasisFunctionsModule
println("Done.")

print(" + IntegralsModule.............")
include("SubModules/IntegralsModule.jl")
@reexport using .IntegralsModule
println("Done.")

print(" + BasisModule.................")
include("SubModules/BasisModule.jl")
@reexport using .BasisModule
println("Done.")

print(" + SpecialMatricesModule.......")
include("SubModules/SpecialMatricesModule.jl")
@reexport using .SpecialMatricesModule
println("Done.")

end # module

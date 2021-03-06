module BasisModule
export GaussianBasis, PrimitiveGaussianBasisFunction, ContractedGaussianBasisFunction, computeBasis, normalize!

using ..BaseModule
using ..BasisFunctionsModule
using ..BasisSetModule
using ..GeometryModule
using ..AtomModule
using ..IntegralsModule

abstract Basis


type GaussianBasis <: Basis
  contractedBFs::Array{ContractedGaussianBasisFunction,1}
end

function computeBasis(basSet::BasisSet,geo::Geometry)
  bas=GaussianBasis([])
  for atom in geo.atoms
    for contractedDefinition in basSet.definitions[atom.element]
      for mqn in MQuantumNumbers(contractedDefinition.lQuantumNumber)
	contractedBF = ContractedGaussianBasisFunction([],[])
	for primitiveDefinition in contractedDefinition.primitives
	  exponent=primitiveDefinition.exponent
	  primitiveBF = PrimitiveGaussianBasisFunction(atom.position,exponent,mqn)
	  norm = IntegralsModule.Overlap(primitiveBF,primitiveBF)
	  append!(contractedBF.coefficients,[primitiveDefinition.prefactor/sqrt(norm)])
	  append!(contractedBF.primitiveBFs,[primitiveBF])
	end
	append!(bas.contractedBFs,[contractedBF])
      end
    end
  end
  return bas
end

function normalize!(basis::GaussianBasis)
  for (cgb in basis.contractedBFs)
    normalize!(cgb)
  end
end

function normalize!(cgb::ContractedGaussianBasisFunction)
  N = Overlap(cgb,cgb)
  scale!(cgb.coefficients,1/sqrt(N))
end

end # module

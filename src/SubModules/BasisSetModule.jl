module BasisSetModule
export BasisSet, readBasisSetTX93
using ..BaseModule
using ..AtomModule

immutable PrimitiveGaussianBasisFunctionDefinition
	exponent::Real
	prefactor::Real
end

immutable ContractedGaussianBasisFunctionDefinition
	lQuantumNumber::LQuantumNumber
	primitives::Array{PrimitiveGaussianBasisFunctionDefinition,1}
end

immutable BasisSet
	definitions::Dict{Element,Array{ContractedGaussianBasisFunctionDefinition,1}}
end


function readBasisSetTX93(filename::AbstractString)
  basSet = BasisSet(Dict())									# initialize return value

  elem = Element("H")										# functionglobal elem
  lqn = "S"											# functionglobal lqn
  contractedDefinition = ContractedGaussianBasisFunctionDefinition(LQuantumNumber("S"),[])	# functionglobal contractedDefinition

  fd = open(filename)
  for line in eachline(fd)
    # comments
    if ismatch(r"^(!|\s*$)",line) continue end				# skip

    # new element
    if ismatch(r"^FOR",line)
      if(contractedDefinition.primitives != []) 				#   and not the first	
	append!(basSet.definitions[elem],[contractedDefinition]) 					#   finish contractedDefinition
	contractedDefinition = ContractedGaussianBasisFunctionDefinition(LQuantumNumber(lqn),[])	#   start new contractedDefinition
      end
      elem = Element(match(r"^FOR\s*(\w*)",line).captures[1])			#   update elem
      basSet.definitions[elem] = ContractedGaussianBasisFunctionDefinition[]	#   initialize elem-definitions empty

    # definition line
    else
      # floatregex = r"[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?"
      regmatch = match(r"(?<lqn>\w*)?\s*(?<exp>[-+]?[0-9]*\.?[0-9]+)\s*(?<lin>[-+]?[0-9]*\.?[0-9]+)",line)
      # new contracted
      if regmatch.captures[1] != ""					# if new contracted
	lqn = regmatch.captures[1]
	if(contractedDefinition.primitives != []) 				#    not a new element
	  append!(basSet.definitions[elem],[contractedDefinition])					#   finish contractedDefinition
	end
	  contractedDefinition = ContractedGaussianBasisFunctionDefinition(LQuantumNumber(lqn),[])	#   start new contractedDefinition
      end
      # always (add primitive to current contracted)
      exponent, linfactor = map(float,regmatch.captures[2:3])
      append!(contractedDefinition.primitives,[PrimitiveGaussianBasisFunctionDefinition(exponent,linfactor)])
    end
  end
  if(contractedDefinition.primitives != []) 				#   if still contracteds left
    append!(basSet.definitions[elem],[contractedDefinition]) 		#   finish contractedDefinition
  end
  close(fd)
  return basSet
end

end # module

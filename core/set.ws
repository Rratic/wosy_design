type Set{T}<:UnorderedCollection where T
	@builtin
end
const 集合::Type : Set

rule 空集公理()
	∃(∅,Set,∀(x,¬(∈(x,∅))))
end

const ∅ : exampleof(空集公理)

theory ∅是集合()
	isa(∅,Set)
end
proof ∅是集合
	∃(∅,Set,∀(x,¬(∈(x,∅)))) :c 空集公理
	@QED : @exist [1]
end

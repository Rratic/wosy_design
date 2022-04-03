rule 合并交换(t1::Type,t2::Type)
	=(Union(t1,t2),Union(t2,t1))
end
rule 合并类型(x,t::Type,t2::Type)
	⇒(isa(x,t),isa(x,Union(t,t2)))
end

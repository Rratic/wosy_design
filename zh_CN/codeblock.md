# 注释
```
# 单行注释


#=
多行注释

=#
```

# 常量定义
```
const 量名::类型名可省略 : 量
```
例如
```
const 真::Bool : true
```

# 类型定义
```
type 类型名{参数列表}<:标签名 where 泛型说明
	域::类型/标签名
end
```
例如
```
type Pair{T1,T2} where T1 T2
	first::T1
	second::T2
end

type Array{T}<:Container where T
	data::Set{Pair{自然数,T}}
	first::自然数
	last::Union{自然数,Nothing}
end
```

# 标签定义
```
tag 标签名<:标签名
```
例如
```
tag Number<:Any
```

# 设计定义
```
design 设计名{参数列表}<:标签名 where 泛型说明
	规则 : 表达式
end
```
例如
```
"用皮亚诺规则定义的非负整数"
design 自然数<:Number
	zero(::Type)
	next(::this)
	=(::this,::this)::Bool
	初始值规则 : isa(zero(this),this)
	后继规则(n::this) : isa(next(n),this)
	前继规则(n::this) : ⇒(≠(n,zero(this)),∃(p,this,=(n,next(p))))
	唯一性规则(a::this,b::this) : ⇒(≠(a,b),≠(next(a),next(b)))
	相等规则 : n_and(自反性(=(::this,::this)),对称性(=(::this,::this)),传递性(=(::this,::this)))
	归纳规则(p::Function{Tuple{this},Bool}) : n_⇒(
		call(p,zero(this)),
		∀(n,this,⇒(call(p,n),call(p,next(n)))),
		恒等于(p,true)
	)
end
```

# 构造定义
```
construct 对应的设计名
	域::类型/标签名
	函数
	规则 : 证明
end
```
例如
```
construct 自然数
	data::Set
	function zero(t::Type)
		if same(t,this)
			return new(∅)
		else
			@findnext
		end
	end
	next(n::this): this(∪(n.data,Set(n.data)))
	=(a::this,b::this): =(a.data,b.data)
	proof 初始值规则()
		same(this,this)						:c same_is_same this
		same(zero(this),callbranch(rough))	:@branch zero(this) [1]
		same(callbranch(rough),new(∅))		:@leaf callbranch(zero,this,`a`)
		same(zero(this),new(∅))				:a [3|1] [2|1]
		isa(new(∅),this)					:@calc_type new(∅)
		@QED								:a [5|1] [4|1]
	end
	proof 后继规则(n::this)
		isa(this(rough),this) 		:@calc_type this(∪(n.data,Set(n.data)))
		same(next(n),this(rough)) 	:@leaf next(n)
		@QED						:a [1|1] [2|1]
	end
	proof 前继规则(n::this)
		@QED :@jump
	end
	# todo
end
enviroment
	let Nat: 自然数
	let 0: zero(Nat)
	function one(t::Type)
		if same(t,Nat)
			return next(zero(Nat))
		else
			@findnext
		end
	end
	function prev(n::Nat)
		if same(n,0)
			return undefined
		else
			return 逆函数call(next,n)
		end
	end
	function +(a::Nat,b::Nat)
		if same(b,0)
			return a
		else
			return +(next(a),prev(b))
		end
	end
end
```

# 函数
```
函数名(参数列表)::返回值类型: 表达式

function 函数名::返回值类型
	return 表达式
end
```
函数中允许嵌入`let 量名:值`表达式和`if ... else ... end`  
`返回值类型`可以省略  
对于`参数列表`
* 基本结构是`参数名::类型/标签名`
* 允许一个用`,`隔开的列表，例如`l::Int,r::Int`，最后一个参数名后可以加`...`，表示允许多参数，以元组显示传参
* 允许在上条后加一个`;`然后拼接用`,`隔开的列表

可以用`@findnext`表示寻找下一个函数名和参数列表的函数继续，若寻找不到则返回`undefined`

例如
```
function getfield(p::Point2D,s::Symbol)
	if same(s,`x`)
		return getindex(p,one(自然数))
	elif same(s,`y`)
		return getindex(p,two(自然数))
	else
		@findnext
	end
end
function +(p::Point2D{T},v::Vector2D{T}) where T
	return Point2D{T}(p.x+v.x,p.y+v.y)
end
```

# 形式
通常用于抽象代数
```
pattern 形式名(参数列表)
	规则 : 表达式
end
```
例如
```
pattern 自反性(f::Function{Tuple{T,T},Bool}) where T
	_ : ∀(x,T,call(f,x,x))
end
```

# 定理
```
theory 定理名(参数列表)
	表达式
end
```
例如
```
theory ∅是集合()
	isa(∅,Set)
end
```

# 规则
```
rule 规则名()
	表达式
end
```

# 证明
```
proof 对应定理名
	表达式 : 原因
end
```
`表达式`部分会被忽略，但建议遵循一定规范：
* 通常按照表达式格式
* `rough`表示省略
* `@QED`表示最后一行

原因部分有多种选择：
* `a 原地址 替换地址`进行类似α-重命名的操作
* `b 原地址`进行类似β-规约的操作
* `c 定理名 args...`对全称消除的使用
* `@branch 函数（含参数） 原因`分支判断
* `@leaf 函数（含参数）`结果判断
* `@calc_type 量`对于已知类型信息的量，得到`isa(量,尽量精确的信息)`
* `@exist 原因`对存在消除的使用，得到`isa(exampleof(rough),rough)`
* `@example_exist 量`对存在消除的使用，得到`∃(rough,rough,rough)`
* `@forall`对全称消除的使用，得到`∀(rough,rough,rough)`
* `@jump`跳过证明，会被标记

关于地址：
* 形如`[a|b,c]`，当没有`b,c`时简写成`[a]`
* `a`表示有效行编号
* `b,c...`表示表达式中依次的分支序号

最后可以加上`->地址`表示导出至

# 模块
```jl
module 模块名
export 导出物列表
东西
end
```

* 模块可以嵌套
* 使用`using`（在无歧义时调用无需标注模块名）或`import`调用，可以使用`.`调用其中的指定物
* 所有模块均会using`核心模块(Core)`，在不使用`baremodule`时会import`基本模块(Base)`
* 顶层模块称为`Top`

例如
```jl
module Example

module Foo
export x,y,z
using Base.zero,Base.自然数,Base.next
const x : zero(自然数)
const y : x
const z : next(x)
end

import Foo.y
const x : Foo.y

end
```

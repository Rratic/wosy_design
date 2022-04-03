# 类型
`Expr`表达式（保留）  
`Rough`（保留）  
`Module`模块，不可出现在内容中  
`Type`类型类  
`Tag`标签类  
`Construct`构造类  
`Function{Tuple,T}`函数，表达式和定理会在恰当的时候进行`函数化`  
`Tuple{T1,T2...}`元组  
`Undefined`未定义，作为函数进行未定义的使用方式的返回值，（【实验性】会进行`StackTrace`）  
`Bool`布尔  
`Union{T1,T2...}`合并  
`Symbol`标识符  
`String`字符串  
`Set{T}<:UnorderedCollection`集合  

# 量
`true::Bool`字面意思  
`false::Bool`  
`Any::Tag`根标签，`::Any`总是可以省略  
`undefined::Undefined`  

# 函数
`same(a,b)`完全相同，时可以对其中一个使用α-重命名成为另一个  
`getfield(a,s::Symbol)`获取a指定的域s（对于设计类，获取的是函数与规则（以`Function`形式呈现）），可以简写成`a.s`  
`call(f::Function,args...)`将`args...`作为参数传递给f  
`callbranch(f::Function,pos::Symbol,args...)`将`args...`作为参数传递给f的分支（`pos`信息用空格隔开，表示依次选取的分支）  
`exampleof(f::Function)`对于已证明的形如`∃(x,t,...)`的命题，返回`x::t`且`f`是其唯一已知信息  
`∀(x,t::Type,f)`
`∃(x,t::Type,f)`
`⇒(a,b)`

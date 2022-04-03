# Wosy简介
一个自然科学及其衍生物的结构记录形式  
wosy : a **Wo**nderful **Sy**mbol for **Wo**rld **Sy**stem

# 文档
[类型系统的相关概念](./zh_CN/typesystem.md)  
[语法块](./zh_CN/codeblock.md)  
[预定义](./zh_CN/predef.md)  
[特殊处理](./zh_CN/special.md)  
[关键字与保留字列表](./zh_CN/keywords.md)  
[core的部分样例](./core)  
作者没有时间一一列出细节，未说明处请根据经验合理判断

# TODO
1. 通用图灵机的底层嵌入

# Q&A
1. 为什么不用[coq](https://github.com/coq/coq)？
> coq的文档我看了一下，存在以下问题：
> - 部分语法设计存在多余或影响使用的问题
> - 命名方式的不可读性
> - 不注重类型系统
> - 难以进行抽象分析
> - 将对应相同设计的不同结构分离
>
> 同时，本设计还包含了
> - 允许有不同的参数列表的函数共用函数名
> - 更可读的证明系统
> - 泛型
> - 标签系统

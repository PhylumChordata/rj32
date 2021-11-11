package codegen

import (
	"go/constant"
	"go/types"
	"log"

	"github.com/rj45/rj32/gorj/ir"
	"github.com/rj45/rj32/gorj/ir/op"
	"github.com/rj45/rj32/gorj/sizes"
)

func (gen *gen) genFunc(fn *ir.Func) {
	for _, glob := range fn.Globals {
		if gen.emittedGlobals[glob] {
			continue
		}
		gen.emittedGlobals[glob] = true

		if gen.section != "data" {
			gen.emit("\n#bank data")
			gen.section = "data"
		}

		typ := glob.Type
		if ptr, ok := typ.(*types.Pointer); ok {
			typ = ptr.Elem()
		}

		size := sizes.Sizeof(typ)

		gen.emit("%s:  ; %s", constant.StringVal(glob.Value), typ)

		gen.emit("\t#res %d", size)
	}

	if gen.section != "code" {
		gen.emit("\n#bank code")
		gen.section = "code"
	}

	gen.emit("\n; %s", fn.Type)
	gen.emit("%s:", fn.Name)

	var retblock *ir.Block

	for i, blk := range fn.Blocks {
		if blk.Op == op.Return {
			if retblock != nil {
				log.Fatalf("two return blocks! %s", fn.LongString())
			}

			retblock = blk
			continue
		}

		var next *ir.Block
		if (i + 1) < len(fn.Blocks) {
			next = fn.Blocks[i+1]
		}

		gen.genBlock(blk, next)
	}

	if retblock != nil {
		gen.genBlock(retblock, nil)
	}
}

var ifcc = map[op.Op]string{
	op.Equal:        "eq",
	op.NotEqual:     "ne",
	op.Less:         "lt",
	op.LessEqual:    "le",
	op.GreaterEqual: "ge",
	op.Greater:      "gt",
}

func (gen *gen) genBlock(blk, next *ir.Block) {
	gen.emit(".%s:", blk)
	gen.indent = "\t"

	if blk.Op == op.If && blk.Controls[0].Op.IsCompare() {
		blk.RemoveInstr(blk.Controls[0])
	}

	for _, instr := range blk.Instrs {
		name := instr.Op.Asm()
		if name != "" {
			for len(name) < 6 {
				name += " "
			}
		}

		ret := ""
		if !instr.Op.IsSink() {
			ret = " "
			ret += instr.String()
			if len(instr.Args) > 0 {
				ret += ","
			}
		}

		switch instr.Op {
		case op.Load:
			gen.genLoad(instr)
			continue

		case op.Store:
			gen.genStore(instr)
			continue

		case op.Call:
			gen.emit("%s %s", name, instr.Args[0])
			continue
		}

		if name != "" {
			for len(name) < 6 {
				name += " "
			}
			if instr.Op.ClobbersArg() {
				if instr.Reg != instr.Args[0].Reg {
					gen.emit("move   %s, %s", instr.Reg, instr.Args[0])
				}
				switch len(instr.Args) {
				case 2:
					gen.emit("%s%s %s", name, ret, instr.Args[1])
				case 3:
					gen.emit("%s%s %s, %s", name, ret, instr.Args[1], instr.Args[1])
				default:
					gen.emit("; %s", instr.LongString())
				}
				continue
			}
			switch len(instr.Args) {
			case 0:
				gen.emit("%s%s", name, ret)
			case 1:
				gen.emit("%s%s %s", name, ret, instr.Args[0])
			case 2:
				gen.emit("%s%s %s, %s", name, ret, instr.Args[0], instr.Args[1])
			case 3:
				gen.emit("%s%s %s, %s, %s", name, ret, instr.Args[0], instr.Args[1], instr.Args[1])
			default:
				gen.emit("; %s", instr.LongString())
			}
		} else {
			gen.emit("; %s", instr.LongString())
		}
	}

	switch blk.Op {
	case op.Jump:
		if blk.Succs[0].Block != next {
			gen.emit("jump   .%s", blk.Succs[0].Block)
		}

	case op.Return:
		gen.emit("return")

	case op.If:
		ctrl := blk.Controls[0]
		cond := op.NotEqual
		sign := ""
		space := " "
		arg1 := ctrl
		arg2 := "0"

		if ctrl.Op.IsCompare() {
			cond = ctrl.Op
			if isUnsigned(ctrl.Type) && ctrl.Op != op.Equal && ctrl.Op != op.NotEqual {
				sign = "u"
				space = ""
			}
			arg1 = ctrl.Args[0]
			arg2 = ctrl.Args[1].String()
		}

		succ0 := blk.Succs[0].Block
		succ1 := blk.Succs[1].Block
		if succ0 == next {
			cond = cond.Opposite()
			succ0, succ1 = succ1, succ0
		}

		gen.emit("if.%s%s%s %s, %s", sign, ifcc[cond], space, arg1, arg2)
		gen.emit("  jump .%s", succ0)

		if succ1 != next {
			gen.emit("jump   .%s", succ1)
		}

	default:
		panic("unimpl")
	}

	gen.indent = ""
}

func isUnsigned(typ types.Type) bool {
	basic, ok := typ.(*types.Basic)
	if !ok {
		return false
	}
	switch basic.Kind() {
	case types.Uint, types.Uint8, types.Uint16, types.Uint32, types.Uint64, types.Uintptr:
		return true
	}
	return false
}

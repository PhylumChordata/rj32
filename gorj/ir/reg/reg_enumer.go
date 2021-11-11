// Code generated by "enumer -type=Reg -transform lower"; DO NOT EDIT.

package reg

import (
	"fmt"
	"strings"
)

const _RegName = "noneraa0a1a2s0s1s2s3t0t1t2t3t4t5gpsp"
const _RegLowerName = "noneraa0a1a2s0s1s2s3t0t1t2t3t4t5gpsp"

var _RegMap = map[Reg]string{
	0:     _RegName[0:4],
	2:     _RegName[4:6],
	4:     _RegName[6:8],
	8:     _RegName[8:10],
	16:    _RegName[10:12],
	32:    _RegName[12:14],
	64:    _RegName[14:16],
	128:   _RegName[16:18],
	256:   _RegName[18:20],
	512:   _RegName[20:22],
	1024:  _RegName[22:24],
	2048:  _RegName[24:26],
	4096:  _RegName[26:28],
	8192:  _RegName[28:30],
	16384: _RegName[30:32],
	32768: _RegName[32:34],
	65536: _RegName[34:36],
}

func (i Reg) String() string {
	if str, ok := _RegMap[i]; ok {
		return str
	}
	return fmt.Sprintf("Reg(%d)", i)
}

// An "invalid array index" compiler error signifies that the constant values have changed.
// Re-run the stringer command to generate them again.
func _RegNoOp() {
	var x [1]struct{}
	_ = x[None-(0)]
	_ = x[RA-(2)]
	_ = x[A0-(4)]
	_ = x[A1-(8)]
	_ = x[A2-(16)]
	_ = x[S0-(32)]
	_ = x[S1-(64)]
	_ = x[S2-(128)]
	_ = x[S3-(256)]
	_ = x[T0-(512)]
	_ = x[T1-(1024)]
	_ = x[T2-(2048)]
	_ = x[T3-(4096)]
	_ = x[T4-(8192)]
	_ = x[T5-(16384)]
	_ = x[GP-(32768)]
	_ = x[SP-(65536)]
}

var _RegValues = []Reg{None, RA, A0, A1, A2, S0, S1, S2, S3, T0, T1, T2, T3, T4, T5, GP, SP}

var _RegNameToValueMap = map[string]Reg{
	_RegName[0:4]:        None,
	_RegLowerName[0:4]:   None,
	_RegName[4:6]:        RA,
	_RegLowerName[4:6]:   RA,
	_RegName[6:8]:        A0,
	_RegLowerName[6:8]:   A0,
	_RegName[8:10]:       A1,
	_RegLowerName[8:10]:  A1,
	_RegName[10:12]:      A2,
	_RegLowerName[10:12]: A2,
	_RegName[12:14]:      S0,
	_RegLowerName[12:14]: S0,
	_RegName[14:16]:      S1,
	_RegLowerName[14:16]: S1,
	_RegName[16:18]:      S2,
	_RegLowerName[16:18]: S2,
	_RegName[18:20]:      S3,
	_RegLowerName[18:20]: S3,
	_RegName[20:22]:      T0,
	_RegLowerName[20:22]: T0,
	_RegName[22:24]:      T1,
	_RegLowerName[22:24]: T1,
	_RegName[24:26]:      T2,
	_RegLowerName[24:26]: T2,
	_RegName[26:28]:      T3,
	_RegLowerName[26:28]: T3,
	_RegName[28:30]:      T4,
	_RegLowerName[28:30]: T4,
	_RegName[30:32]:      T5,
	_RegLowerName[30:32]: T5,
	_RegName[32:34]:      GP,
	_RegLowerName[32:34]: GP,
	_RegName[34:36]:      SP,
	_RegLowerName[34:36]: SP,
}

var _RegNames = []string{
	_RegName[0:4],
	_RegName[4:6],
	_RegName[6:8],
	_RegName[8:10],
	_RegName[10:12],
	_RegName[12:14],
	_RegName[14:16],
	_RegName[16:18],
	_RegName[18:20],
	_RegName[20:22],
	_RegName[22:24],
	_RegName[24:26],
	_RegName[26:28],
	_RegName[28:30],
	_RegName[30:32],
	_RegName[32:34],
	_RegName[34:36],
}

// RegString retrieves an enum value from the enum constants string name.
// Throws an error if the param is not part of the enum.
func RegString(s string) (Reg, error) {
	if val, ok := _RegNameToValueMap[s]; ok {
		return val, nil
	}

	if val, ok := _RegNameToValueMap[strings.ToLower(s)]; ok {
		return val, nil
	}
	return 0, fmt.Errorf("%s does not belong to Reg values", s)
}

// RegValues returns all values of the enum
func RegValues() []Reg {
	return _RegValues
}

// RegStrings returns a slice of all String values of the enum
func RegStrings() []string {
	strs := make([]string, len(_RegNames))
	copy(strs, _RegNames)
	return strs
}

// IsAReg returns "true" if the value is listed in the enum definition. "false" otherwise
func (i Reg) IsAReg() bool {
	_, ok := _RegMap[i]
	return ok
}

# rj32

A 16-bit RISC CPU with 32 instructions built with [Digital](https://github.com/hneemann/Digital).

## Description

This is a CPU built from scratch in a visual way using a digital circuit simulator called [Digital](https://github.com/hneemann/Digital). This is then able to be exported to verilog or VHDL and that can be converted into a digital circuit that can run on an [FPGA](https://en.wikipedia.org/wiki/Field-programmable_gate_array).

I have built a couple CPUs before, but this time I decided to record it as a youtube series. I start out being a bit of a youtube n00b, but the quality hopefully gets better as the series goes on.

[![Introduction Video - Building a CPU From Scratch](https://img.youtube.com/vi/FSVhlqE7EgA/0.jpg)](https://www.youtube.com/watch?v=FSVhlqE7EgA&list=PLilenfQGj6CEG6iZ4TQJ10PI7pCWsy1AO&index=1)

## Building and Running

For the simulation, open `dig/frontpanel.dig` in [Digital](https://github.com/hneemann/Digital).

For the verilog version, see [the HDL documentation](./hdl/README.md).

## Design

A [minimal instruction set computer](https://en.wikipedia.org/wiki/Minimal_instruction_set_computer) with exactly 32 instructions. Well, 32 opcodes anyway, technically there's more instructions. Though that may change with the next instruction set update.

Currently it is a RISC instruction set with a Harvard memory architecture. In other words, data memory is accessed only through load/store instructions, and data memory is separate from program memory. Program memory can only be used to execute code.

There is currently two pipeline stages: fetch and execute. In the first stage the instruction is fetched from program memory. In the second stage the instruction is decoded, has its operands loaded from the register file, executed, then the result written.

Currently the CPU is designed to run on ice40 FPGAs using the open source toolchain.

### Instruction Set

[Instruction Set Documentation](./docs/instructions.md).

## Contributing

**Contributions are welcome!**

- Please follow the existing style and implement as much as possible in the Digital simulation rather than verilog.
- Fork and submit a PR, please update any documentation and tests and explain exactly what you changed (preferably with screenshots) in the PR description.
- I will be showing all contributions in youtube videos showing what you changed. I will give you credit.
- I reserve the right to reject any changes that take the processor in a different direction than I want it to go
- Changes I would like to make are listed in the issues. If I haven't begun working on something, feel free to take it up.
- If no issues looks interesting, feel free to submit an issue for something you'd like to do, and I can approve it.
- Feel free to submit PRs without an issue or approval if you don't mind me deciding not to accept it.

## Contributors

- rj45
- advice from BigEd, joanlluch, oldben, robfinch, robinsonb5, DiTBho, MichaelM on AnyCPU

## License

This project is licensed under the MIT License - see the LICENSE file for details.

NOTE: The youtube videos do not fall under this license. They are under the standard youtube copyright, and I ask you not re-publish them elsewhere. You can create your own youtube videos with the content in this repo, however.

## Acknowledgments

- [Ben Eater](https://eater.net/)
- Many awesome folks on [AnyCPU](http://anycpu.org/forum/)
- John Lluch's [CPU74](https://github.com/John-Lluch/CPU74/)
- [Dieter "ttlworks"](http://www.6502.org/users/dieter/)
- So many inspirations I can't hope to enumerate them all

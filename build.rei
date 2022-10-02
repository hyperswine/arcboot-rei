require = {
    core = { version = "0.1", features = ["log"] }
}

// rein allows you to switch between target views => ctrl shift p -> switch target
target = {
    phantasm_ir = {
        default_target = true
    }
    aarch64_uefi = {}
    riscv64_none = {}
}

bin = {
    default = "arc"
}

// a project can define multiple library targets
// if you do, you have to assign direct submodules @!lib = "lib-name"
// its best to just have a single lib target and/or a few bin targets
lib = {
    default = "lib"
}

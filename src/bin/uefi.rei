@!cfg(feature="uefi")

use uefi::common::*

@entry
main: () -> Status {
    let bt = BootServices::get_table()

    info("Boot services started!")

    let rt = bt.exit()

    info("Runtime services started!")

    rt.exit()
}

/*
entry: annotation () {
    (f: Fn) => {
        basically, no_mangle and call this label from uefi
    }
}
*/

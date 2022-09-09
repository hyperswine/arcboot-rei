@!cfg(feature="uefi")

use uefi::common::*

@entry
fn main() -> ! {
    let bt = BootServices::get_table()

    info("Boot services started!")

    let rt = bt.exit()

    info("Runtime services started!")

    rt.exit()
}

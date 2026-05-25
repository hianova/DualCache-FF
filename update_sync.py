with open("src/sync.rs", "r") as f:
    content = f.read()

new_content = content + """
#[cfg(target_has_atomic = "64")]
pub mod index_types {
    pub type AtomicIndex = super::atomic::AtomicU64;
    pub type IndexType = u64;
    pub const EMPTY: u64 = 0;
    pub const TOMBSTONE: u64 = u64::MAX;
    pub const TAG_SHIFT: usize = 48;
    pub const INDEX_MASK: u64 = 0x0000_FFFF_FFFF_FFFF;
    pub type AtomicTick = super::atomic::AtomicU64;
}

#[cfg(not(target_has_atomic = "64"))]
pub mod index_types {
    pub type AtomicIndex = super::atomic::AtomicU32;
    pub type IndexType = u32;
    pub const EMPTY: u32 = 0;
    pub const TOMBSTONE: u32 = u32::MAX;
    pub const TAG_SHIFT: usize = 24;
    pub const INDEX_MASK: u32 = 0x00FF_FFFF;
    // daemon_tick wraps naturally, u32 is sufficient if u64 atomics are missing.
    pub type AtomicTick = super::atomic::AtomicU32;
}
"""

with open("src/sync.rs", "w") as f:
    f.write(new_content)

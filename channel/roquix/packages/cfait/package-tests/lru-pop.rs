use lru::LruCache;
use std::num::NonZeroUsize;
use std::panic::{AssertUnwindSafe, catch_unwind};
use std::sync::atomic::{AtomicBool, Ordering};

#[test]
fn panicking_key_drop_preserves_cache_links() {
    static ARMED: AtomicBool = AtomicBool::new(false);
    #[derive(PartialEq, Eq, Hash)]
    struct Key(u32);
    impl Drop for Key {
        fn drop(&mut self) {
            if ARMED.swap(false, Ordering::SeqCst) {
                panic!("key destructor");
            }
        }
    }
    let mut cache = LruCache::new(NonZeroUsize::new(3).unwrap());
    cache.put(Key(1), "one");
    cache.put(Key(2), "two");
    cache.put(Key(3), "three");
    ARMED.store(true, Ordering::SeqCst);
    assert!(catch_unwind(AssertUnwindSafe(|| cache.pop(&Key(2)))).is_err());
    // An evicted node must not retain links to the key whose destructor panicked.
    cache.put(Key(4), "four");
    cache.put(Key(5), "five");
    assert_eq!(
        cache.iter().map(|(k, _)| k.0).collect::<Vec<_>>(),
        [5, 4, 3]
    );
    assert_eq!(cache.get(&Key(3)), Some(&"three"));
}

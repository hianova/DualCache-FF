mod ai;

use std::collections::HashMap;
use std::fmt::Debug;
use std::hash::Hash;
use std::mem::MaybeUninit;
use std::sync::Arc;

use anyhow::Result;
use arc_swap::ArcSwap;
use tracing::instrument;

/// 一個雙層緩存實現（FIFO 和 LFU）
///
/// # 範例
///
/// ```
/// use your_crate::DualCacheFF;
///
/// // 創建一個新的緩存實例
/// let mut cache = DualCacheFF::new();
///
/// // 放入數據
/// cache.put("key1", 100).unwrap();
/// cache.put("key2", 200).unwrap();
///
/// // 獲取數據
/// let value = cache.get("key1").unwrap();
/// assert_eq!(*value, 100);
///
/// // 獲取不存在的鍵
/// let result = cache.get("key3");
/// assert!(result.is_err());
/// ```
///
/// # 容量管理範例
///
/// ```
/// use your_crate::{DualCacheFF, Config};
///
/// // 使用自定義配置
/// let config = Config {
///     capacity: 100,
/// };
/// let mut cache = DualCacheFF::from(config);
///
/// // 放入多個項目
/// for i in 0..150 {
///     cache.put(i, format!("value_{}", i)).unwrap();
/// }
///
/// // 由於 FIFO 策略，最早的項目應該被淘汰
/// assert!(cache.get(&0).is_err());  // 最早的鍵可能已被淘汰
/// assert!(cache.get(&149).is_ok()); // 最新的鍵應該存在
/// ```
pub struct DualCacheFF<K, V> {
    nodes: Vec<Arc<Node<K, V>>>,
    index: HashMap<K, usize>,
    arena: Paginated,
    mirror: ArcSwap<Paginated>,
    lookup_count: u64,
}
impl<K, V> DualCacheFF<K, V>
where
    K: Hash + Eq + Clone + Debug,
    V: Clone + Debug,
{
    /// 創建一個新的緩存實例，使用默認配置（容量 10,000,000）
    ///
    /// # 範例
    ///
    /// ```
    /// # use your_crate::DualCacheFF;
    /// let cache = DualCacheFF::<String, i32>::new();
    /// ```
    pub fn new() -> Self {
        let default = Config {
            capacity: (10 as usize).pow(7),
        };
        Self::from(default)
    }

    /// 將鍵值對放入緩存
    ///
    /// 如果緩存已滿，會根據 FIFO 策略淘汰最舊的項目
    ///
    /// # 參數
    /// * `key` - 要存儲的鍵
    /// * `value` - 要存儲的值
    ///
    /// # 範例
    ///
    /// ```
    /// # use your_crate::DualCacheFF;
    /// let mut cache = DualCacheFF::new();
    ///
    /// // 基本使用
    /// cache.put("user:1", "Alice").unwrap();
    /// cache.put("user:2", "Bob").unwrap();
    ///
    /// // 更新已存在的鍵
    /// cache.put("user:1", "Alice Updated").unwrap();
    /// ```
    ///
    /// # 錯誤處理
    ///
    /// ```
    /// # use your_crate::DualCacheFF;
    /// let mut cache = DualCacheFF::new();
    ///
    /// // 正常操作不會返回錯誤
    /// assert!(cache.put("key", "value").is_ok());
    /// ```
    #[instrument(skip(self, value), fields(key = ?key))]
    pub fn put(&mut self, key: K, value: V) -> Result<()> {
        todo!("put...");
    }

    /// 從緩存中獲取值
    ///
    /// 獲取值時會增加該鍵的使用次數（用於 LFU 策略）
    ///
    /// # 參數
    /// * `key` - 要查詢的鍵
    ///
    /// # 返回值
    /// 返回 `Result<&V>`，如果鍵不存在則返回錯誤
    ///
    /// # 範例
    ///
    /// ```
    /// # use your_crate::DualCacheFF;
    /// let mut cache = DualCacheFF::new();
    /// cache.put("answer", 42).unwrap();
    ///
    /// // 成功獲取
    /// let value = cache.get("answer").unwrap();
    /// assert_eq!(*value, 42);
    ///
    /// // 多次獲取會增加使用頻率
    /// cache.get("answer").unwrap();
    /// cache.get("answer").unwrap();
    ///
    /// // 獲取不存在的鍵
    /// assert!(cache.get("nonexistent").is_err());
    /// ```
    ///
    /// # 使用模式範例
    ///
    /// ```
    /// # use your_crate::DualCacheFF;
    /// let mut cache = DualCacheFF::new();
    ///
    /// // 常見的 get-or-insert 模式
    /// let key = "user:profile";
    /// let value = match cache.get(key) {
    ///     Ok(v) => v,
    ///     Err(_) => {
    ///         // 從數據庫加載
    ///         let new_value = "profile data";
    ///         cache.put(key, new_value).unwrap();
    ///         cache.get(key).unwrap()
    ///     }
    /// };
    /// ```
    #[instrument(skip(self), fields(key = ?key))]
    pub fn get(&mut self, key: K) -> Result<V> {
        todo!("get...");
    }
}

struct Config {
    capacity: usize,
}
impl<K, V> From<Config> for DualCacheFF<K, V> {
    fn from(config: Config) -> Self {
        Self {
            nodes: Vec::with_capacity(config.capacity),
            index: HashMap::with_capacity(config.capacity),
            arena: Paginated::new(),
            mirror: ArcSwap::from_pointee(Paginated::new()),
            lookup_count: 0,
        }
    }
}

struct Node<K, V> {
    key: K,
    value: Arc<V>,
    epoch: u64,
}
struct Paginated {
    pages: Vec<Page>,
    len: usize,
}
impl Paginated {
    fn new() -> Self {
        Self {
            pages: Vec::new(),
            len: 0,
        }
    }
}
impl Clone for Paginated {
    fn clone(&self) -> Self {
        Self {
            pages: self.pages.clone(),
            len: self.len,
        }
    }
}

struct Page {
    data: [usize; 1024],
}
impl Clone for Page {
    fn clone(&self) -> Self {
        let mut new_page: MaybeUninit<Page> = MaybeUninit::uninit();
        unsafe {
            std::ptr::copy_nonoverlapping(
                &self.data as *const usize,
                new_page.as_mut_ptr() as *mut usize,
                1024,
            );
            new_page.assume_init()
        }
    }
}

# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/08/08/
> 分类: RocksDB

数据库内核月报
 -->
  

  

  

  

  

  

  

  

  

  
 -->
  
hljs.initHighlightingOnLoad();

  

  

  

  

  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-62056244-1', 'auto');
  ga('send', 'pageview');

 -->

  

  

  数据库内核月报
	

  

    
数据库内核月报 － 2018 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · 主库 binlog 概览
                      

                    

                    

                  
                      

                        MySQL · RocksDB · Write Prepared Policy
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 使用对称秘钥实现列加密
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · InnoDB对binlog_format的限制
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · sharding chunk 分裂与迁移详解
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · PostgreSQL物理备份内部原理
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 连接与认证过程
                      

                    

                    

                  
                      

                        MySQL · RocksDB ·  MemTable的写入逻辑
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · Greenplum RoaringBitmap多阶段聚合
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 高并发空间位置更新、多属性KNN搜索并测
                      

                    

 
        

    

  

    
 MySQL · RocksDB ·  MemTable的写入逻辑  

    
 Author: diaoliang  

  

  

  
简介

在之前的文章中我们知道RocksDB每一次写入，都是先写WAL，然后写Memtable,这次我们就来分析下MemTable的实现.

在RocksDB中，每个ColumnFamily都有自己的Memtable,互不影响．而在RocksDB中Memtable有多种实现(SkipList/HashSkipList/HashLinkList/Vector),具体的区别可以看
这里
,我们这次主要来分析默认的实现skiplist(只有skiplist是可以并发插入的).

实现

首先从创建Memtable开始，Memtable的创建(ColumnFamilyData::CreateNewMemtable)是在创建ColumnFamily(VersionSet::CreateColumnFamily)的时候创建的．这里就是创建memtable,然后设置到ColumnFamilyData的mem_域中．

MemTable* ColumnFamilyData::ConstructNewMemtable(
    const MutableCFOptions& mutable_cf_options, SequenceNumber earliest_seq) {
  return new MemTable(internal_comparator_, ioptions_, mutable_cf_options,
                      write_buffer_manager_, earliest_seq, id_);
}
void ColumnFamilyData::CreateNewMemtable(
    const MutableCFOptions& mutable_cf_options, SequenceNumber earliest_seq) {
  if (mem_ != nullptr) {
    delete mem_->Unref();
  }
  SetMemtable(ConstructNewMemtable(mutable_cf_options, earliest_seq));
  mem_->Ref();
}

上面所提及的，RocksDB有多种MemTable的实现，那么它是如何来做的呢，RocksDB通过memtable_factory来根据用户的设置来创建不同的memtable.这里要注意的是核心的memtable实现是在MemTable这个类的table_域中.

MemTable::MemTable:
      table_(ioptions.memtable_factory->CreateMemTableRep(
          comparator_, &arena_, ioptions.prefix_extractor, ioptions.info_log,
          column_family_id)),

class MemTableRepFactory {
 public:
  virtual ~MemTableRepFactory() {}

  virtual MemTableRep* CreateMemTableRep(const MemTableRep::KeyComparator&,
                                         Allocator*, const SliceTransform*,
                                         Logger* logger) = 0;
  virtual MemTableRep* CreateMemTableRep(
      const MemTableRep::KeyComparator& key_cmp, Allocator* allocator,
      const SliceTransform* slice_transform, Logger* logger,
      uint32_t /* column_family_id */) {
    return CreateMemTableRep(key_cmp, allocator, slice_transform, logger);
  }
........................

然后最后会调用对应的实现的CreateMemTableRep方法，这里我们就来看SkipList的实现．

MemTableRep* SkipListFactory::CreateMemTableRep(
    const MemTableRep::KeyComparator& compare, Allocator* allocator,
    const SliceTransform* transform, Logger* /*logger*/) {
  return new SkipListRep(compare, allocator, transform, lookahead_);
}

最终就是创建SkipListRep对象，在这个对象里面会创建SkipList(class InlineSkipList).

class SkipListRep : public MemTableRep {
  InlineSkipList<const MemTableRep::KeyComparator&> skip_list_;
...................................
public:
 explicit SkipListRep(const MemTableRep::KeyComparator& compare,
                      Allocator* allocator, const SliceTransform* transform,
                      const size_t lookahead)
     : MemTableRep(allocator),
       skip_list_(compare, allocator),
       cmp_(compare),
       transform_(transform),
       lookahead_(lookahead) {}

这里SkipList就不分析实现了，如果对这个数据结构不了解的，可以去
WIKI
看一下．这里我们只需要知道最终所有的memtable数据都是保存在SkipList中就可以了.

在之前的分析中我们知道Memtable的插入是通过WriteBatch然后遍历ColumnFamily来插入的，而最终则是会调用MemTable::Add这个函数.

bool MemTable::Add(SequenceNumber s, ValueType type,
                   const Slice& key, /* user key */
                   const Slice& value, bool allow_concurrent,
                   MemTablePostProcessInfo* post_process_info) {
bool res = table->InsertKeyConcurrently(handle);
    if (UNLIKELY(!res)) {
      return res;
    }
..............................
                   }

最终会调用InlineSkipList来对数据进行插入.

template <class Comparator>
bool InlineSkipList<Comparator>::InsertConcurrently(const char* key) {
  Node* prev[kMaxPossibleHeight];
  Node* next[kMaxPossibleHeight];
  Splice splice;
  splice.prev_ = prev;
  splice.next_ = next;
  return Insert<true>(key, &splice, false);
}

看到这里或许会有疑问了，那就是skiplist里面只有key,而RocksDB是一个ＫＶ存储，那么这个KV是如何存储的呢，这里是这样的，RocksDB会将KV打包成一个key传递给SkipList, 对应的KEY的结构是这样的.

  // Format of an entry is concatenation of:
  //  key_size     : varint32 of internal_key.size()
  //  key bytes    : char[internal_key.size()]
  //  value_size   : varint32 of value.size()
  //  value bytes  : char[value.size()]

而数据的格式化就在之前的MemTable::Add中实现的.

uint32_t key_size = static_cast<uint32_t>(key.size());
  uint32_t val_size = static_cast<uint32_t>(value.size());
  uint32_t internal_key_size = key_size + 8;
  const uint32_t encoded_len = VarintLength(internal_key_size) +
                               internal_key_size + VarintLength(val_size) +
                               val_size;
  char* buf = nullptr;
  std::unique_ptr<MemTableRep>& table =
      type == kTypeRangeDeletion ? range_del_table_ : table_;
  KeyHandle handle = table->Allocate(encoded_len, &buf);

  char* p = EncodeVarint32(buf, internal_key_size);
  memcpy(p, key.data(), key_size);
  Slice key_slice(p, key_size);
  p += key_size;
  uint64_t packed = PackSequenceAndType(s, type);
  EncodeFixed64(p, packed);
  p += 8;
  p = EncodeVarint32(p, val_size);
  memcpy(p, value.data(), val_size);

而对于真正的KEY的解析是在SkipList的Comparator中实现的(compare_).下面的代码片段可以看到会解析出来真正的key,然后再进行查找以及插入.

bool InlineSkipList<Comparator>::Insert(const char* key, Splice* splice,
                                        bool allow_partial_splice_fix) {
  Node* x = reinterpret_cast<Node*>(const_cast<char*>(key)) - 1;
  const DecodedKey key_decoded = compare_.decode_key(key);
...............................
                                        }

  

    

		

 -->
  

  
阿里云PolarDB-数据库内核组
 -->
  
 -->
  
社招/校招 欢迎投递简历 直达招聘信息
 -->
  
 -->
  
直连月报小编
 -->
  
 -->
  
欢迎在github上star AliSQL
 -->
  

  阅读：
 - 

  

本作品采用
知识共享署名-非商业性使用-相同方式共享 3.0 未本地化版本许可协议
进行许可。

  jQuery(document).ready(function($){
    // browser window scroll (in pixels) after which the "back to top" link is shown
    var offset = 300,
      //browser window scroll (in pixels) after which the "back to top" link opacity is reduced
      offset_opacity = 1200,
      //duration of the top scrolling animation (in ms)
      scroll_top_duration = 700,
      //grab the "back to top" link
      $back_to_top = $('.cd-top');

    //hide or show the "back to top" link
    $(window).scroll(function(){
      ( $(this).scrollTop() > offset ) ? $back_to_top.addClass('cd-is-visible') : $back_to_top.removeClass('cd-is-visible cd-fade-out');
      if( $(this).scrollTop() > offset_opacity ) {
        $back_to_top.addClass('cd-fade-out');
      }
    });

    //smooth scroll to top
    $back_to_top.on('click', function(event){
      event.preventDefault();
      $('body,html').animate({
        scrollTop: 0 ,
        }, scroll_top_duration
      );
    });

  });
